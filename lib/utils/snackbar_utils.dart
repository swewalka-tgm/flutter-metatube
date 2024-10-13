import 'package:flutter/material.dart';
import 'package:metatube_flutter/utils/app_styles.dart';

class SnackbarUtils {
  static void showSnackbar(
      BuildContext context, String message, IconData icon) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
      children: [
        Icon(
          icon,
          color: AppTheme.accent,
        ),
        SizedBox(
          width: 8,
        ),
        Text(message)
      ],
    )));
  }
}
