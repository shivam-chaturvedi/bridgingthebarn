package com.maira.bridging_barn

import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val DEEP_LINK_CHANNEL = "bridgingbarn/deeplink"

class MainActivity : FlutterActivity() {
  private var methodChannel: MethodChannel? = null
  private var pendingInitialUri: String? = null

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEEP_LINK_CHANNEL)
    methodChannel?.setMethodCallHandler { call, result ->
      if (call.method == "getInitialUri") {
        result.success(pendingInitialUri)
        pendingInitialUri = null
      } else {
        result.notImplemented()
      }
    }
    sendPendingUriIfAvailable()
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setInitialUri(intent)
  }

  override fun onNewIntent(intent: Intent) {
    super.onNewIntent(intent)
    setIntent(intent)
    dispatchDeepLink(intent.dataString)
  }

  private fun setInitialUri(intent: Intent?) {
    val dataString = intent?.dataString
    if (dataString != null) {
      pendingInitialUri = dataString
    }
  }

  private fun sendPendingUriIfAvailable() {
    val uri = pendingInitialUri ?: return
    methodChannel?.invokeMethod("pushUri", uri)
  }

  private fun dispatchDeepLink(uri: String?) {
    if (uri.isNullOrEmpty()) return
    methodChannel?.invokeMethod("pushUri", uri)
  }
}
