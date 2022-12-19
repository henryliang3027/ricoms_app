import 'package:flutter/material.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommonWidget {
  static Future<bool?> showExitAppDialog({
    required BuildContext context,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.dialogTitle_AskBeforeExitApp,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.cancel,
              ),
              onPressed: () {
                Navigator.of(context).pop(false); // pop dialog
              },
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.exit,
                style: TextStyle(
                  color: CustomStyle.severityColor[3],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true); // pop dialog
              },
            ),
          ],
        );
      },
    );
  }
}
