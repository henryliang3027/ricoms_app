import 'package:flutter/material.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommonWidget {
  /// 顯示底部選單，自動處理 Android 系統導航欄重疊問題。
  /// 此方法包裝標準的 showModalBottomSheet，自動加入安全區域內邊距，
  /// 防止底部選單被 Android 設備的系統導航欄遮蔽。
  static Future<T?> showSafeModalBottomSheet<T>({
    /// 顯示底部選單的建構上下文
    required BuildContext context,

    /// 建構器函數，用於建立要顯示在底部選單中的 widget
    required Widget Function(BuildContext) builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom,
          ),
          child: builder(context),
        );
      },
    );
  }

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
                style: const TextStyle(color: CustomStyle.customRed),
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
