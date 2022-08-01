import 'package:flutter/material.dart';

class CommonWidget {
  static Future<bool?> showExitAppDialog({
    required BuildContext context,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to exit app ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop(true); // pop dialog
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // pop dialog
              },
            ),
          ],
        );
      },
    );
  }
}
