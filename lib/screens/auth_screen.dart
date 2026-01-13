import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/auth_provider.dart';
import '../screens/privacy_screen.dart';
import '../screens/terms_screen.dart';
import '../theme/theme_colors.dart';

enum AuthTab { signIn, signUp }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.initialTab = AuthTab.signIn});

  final AuthTab initialTab;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthTab _tab;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _forgotEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tab = widget.initialTab;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _forgotEmailController.dispose();
    super.dispose();
  }

  void _switchTab(AuthTab tab) {
    setState(() => _tab = tab);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    try {
      if (_tab == AuthTab.signIn) {
        await auth.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await auth.signUp(
          displayName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _tab == AuthTab.signIn
                  ? 'Welcome back, ${auth.displayName}!'
                  : 'Thanks for joining, ${auth.displayName}!',
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        final message = error is AuthException ? error.message : error.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  void _showForgotPasswordDialog() {
    _forgotEmailController.text = _emailController.text.trim();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final email = _forgotEmailController.text.trim();
            final canSend = email.contains('@');
            return AlertDialog(
              backgroundColor: const Color(0xFF041B24),
              title: const Text('Forgot password?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Provide your account email and we will send a reset link.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _forgotEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: canSend
                      ? () async {
                          Navigator.of(context).pop();
                          try {
                            await context.read<AuthProvider>().resetPassword(email);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Reset link sent to $email. Check your inbox.',
                                ),
                              ),
                            );
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Could not send reset link: $error')),
                            );
                          }
                        }
                      : null,
                  child: const Text('Send link'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openPolicy(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Widget _buildTabButton(String label, AuthTab tab) {
    final isSelected = _tab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchTab(tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? ThemeColors.primary : Colors.white12,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? ThemeColors.accent : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isProcessing = auth.isProcessing;
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      appBar: AppBar(
        backgroundColor: ThemeColors.primary,
        elevation: 0,
        title: Text(_tab == AuthTab.signIn ? 'Sign in' : 'Create account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF052B38),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildTabButton('Sign in', AuthTab.signIn),
                      const SizedBox(width: 12),
                      _buildTabButton('Sign up', AuthTab.signUp),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (_tab == AuthTab.signUp) ...[
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Full name',
                              labelStyle: TextStyle(color: Colors.white60),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Add your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email address',
                            labelStyle: TextStyle(color: Colors.white60),
                          ),
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return 'Provide a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white60),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Password should be 6+ characters';
                            }
                            return null;
                          },
                        ),
                        if (_tab == AuthTab.signIn)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _showForgotPasswordDialog,
                              child: const Text('Forgot password?'),
                            ),
                          ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isProcessing ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeColors.accent,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: isProcessing
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(_tab == AuthTab.signIn ? 'Sign in' : 'Create account'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                Text(
                  _tab == AuthTab.signIn
                      ? 'Need to set up an account?'
                      : 'Already have an account?',
                  style: const TextStyle(color: Colors.white70),
                ),
                TextButton(
                  onPressed: () => _switchTab(
                    _tab == AuthTab.signIn ? AuthTab.signUp : AuthTab.signIn,
                  ),
                  child: Text(_tab == AuthTab.signIn ? 'Create account' : 'Sign in'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'By continuing you agree to our policies and terms of service.',
              style: const TextStyle(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              children: [
                TextButton(
                  onPressed: () => _openPolicy(const PrivacyScreen()),
                  child: const Text('Privacy Policy'),
                ),
                TextButton(
                  onPressed: () => _openPolicy(const TermsScreen()),
                  child: const Text('Terms of Service'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
