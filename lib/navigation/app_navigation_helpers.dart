import 'package:flutter/material.dart';

import '../navigation/main_navigation.dart';

Future<void> navigateToTab(BuildContext context, int index) {
  return Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => MainNavigation(initialIndex: index)),
    (route) => false,
  );
}
