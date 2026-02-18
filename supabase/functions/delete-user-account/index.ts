import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle OPTIONS request for CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    console.log('Function invoked', { method: req.method })
    const rawAuthorization = req.headers.get('Authorization') ?? req.headers.get('authorization') ?? ''
    console.log('Auth header:', rawAuthorization || '<none>')
    const token = rawAuthorization.replace(/^Bearer\s+/i, '').trim()
    if (!token) {
      console.log('Missing bearer token, returning 401')
      return new Response(JSON.stringify({ error: 'Missing authorization token.' }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 401,
      })
    }

    // 1. Create a Supabase client using the anon key so we can verify the user
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? ''
    )

    // 2. Parse the email the client wants to delete
    const body = await req.json().catch(() => ({}))
    console.log('Request body:', body)
    const email = typeof body?.email === 'string' ? body.email.trim() : ''

    if (!email) {
      return new Response(JSON.stringify({ error: 'Missing email in request body.' }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 400,
      })
    }

    const emailLower = email.toLowerCase()

    // 3. Make sure the request is coming from the account owner
    const {
      data: { user },
      error: userError,
    } = await supabaseClient.auth.getUser(token)

    console.log('Token verification result', {
      userId: user?.id,
      userEmail: user?.email,
      error: userError?.message,
    })

    if (userError || !user) {
      console.log('Auth getUser failed, returning 401', userError?.message)
      return new Response(JSON.stringify({ error: 'Unable to authenticate user.' }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 401,
      })
    }

    if (user.email?.toLowerCase() !== emailLower) {
      console.log('Email mismatch between token owner and target account', {
        tokenEmail: user.email,
        bodyEmail: email,
      })
      return new Response(JSON.stringify({ error: 'Unauthorized for this email.' }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 401,
      })
    }

    // 4. Create a Supabase client with the SERVICE_ROLE_KEY
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // 5. Delete the user from auth.users
    const { error } = await supabaseAdmin.auth.admin.deleteUser(
      user.id
    )

    if (error) {
      console.log('Admin deleteUser failed', error.message)
      return new Response(JSON.stringify({ error: error.message }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 400,
      })
    }

    console.log('Account deleted successfully', { userId: user.id, email: user.email })

    return new Response(JSON.stringify({ message: "Account deleted successfully" }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 200,
    })
  } catch (error) {
    console.log('Unhandled function error', { error })
    return new Response(JSON.stringify({ error: error instanceof Error ? error.message : 'Unknown error' }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 400,
    })
  }
})
