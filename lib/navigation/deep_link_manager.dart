import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../services/deep_link_handler.dart';
import 'deep_link_navigator.dart';

class DeepLinkManager {
  DeepLinkManager({required this.navigatorKey}) : _handler = const DeepLinkHandler();

  static const _channel = MethodChannel('bridgingbarn/deeplink');

  final GlobalKey<NavigatorState> navigatorKey;
  final DeepLinkHandler _handler;
  Uri? _lastHandledUri;

  Future<void> init() async {
    _channel.setMethodCallHandler(_onMethodCall);
    try {
      final initialUri = await _channel.invokeMethod<String>('getInitialUri');
      await _resolve(initialUri);
    } on PlatformException {
      await _navigateInvalid('Unable to retrieve the reset link.');
      return;
    }
  }

  Future<void> _resolve(String? uriString) async {
    if (uriString == null || uriString.isEmpty) return;
    Uri uri;
    try {
      uri = Uri.parse(uriString);
    } on FormatException {
      await _navigateInvalid('Malformed reset link.');
      return;
    }
    if (_lastHandledUri == uri) return;
    _lastHandledUri = uri;

    final result = await _handler.handle(uri);
    if (result.intent == DeepLinkIntent.none) return;
    await DeepLinkNavigator(navigatorKey: navigatorKey).navigate(result);
  }

  Future<void> _onMethodCall(MethodCall call) async {
    if (call.method != 'pushUri') return;
    final uriString = call.arguments as String?;
    await _resolve(uriString);
  }

  Future<void> _navigateInvalid(String message) async {
    await DeepLinkNavigator(navigatorKey: navigatorKey).navigate(
      DeepLinkResult.invalid(message: message),
    );
  }

  void dispose() {
    _channel.setMethodCallHandler(null);
  }
}
