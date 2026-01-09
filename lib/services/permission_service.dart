import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  const PermissionService._();

  static Future<bool> ensureMicrophonePermission(BuildContext context) {
    return _requestPermission(
      Permission.microphone,
      context,
      'microphone access',
    );
  }

  static Future<bool> ensureGalleryPermission(BuildContext context) {
    final permission = Platform.isIOS ? Permission.photos : Permission.storage;
    return _requestPermission(
      permission,
      context,
      'media storage access',
    );
  }

  static Future<bool> _requestPermission(
    Permission permission,
    BuildContext context,
    String feature,
  ) async {
    final status = await permission.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      _showSettingsSnackBar(context, feature);
      return false;
    }
    final result = await permission.request();
    if (result.isGranted) return true;
    _showSettingsSnackBar(context, feature);
    return false;
  }

  static void _showSettingsSnackBar(BuildContext context, String feature) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Grant $feature to continue.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: 'Settings',
          textColor: Colors.amber,
          onPressed: openAppSettings,
        ),
      ),
    );
  }
}
