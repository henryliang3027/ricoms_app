import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getMessageLocalization({
  required String msg,
  required BuildContext context,
}) {
  String localizeMsg = '';
  switch (msg) {
    case 'There are no records to show':
      localizeMsg = AppLocalizations.of(context)!.noMoreRecordToShow;
      break;
    case 'No more result.':
      localizeMsg = AppLocalizations.of(context)!.dialogMessage_NoMoreData;
      break;
    case 'The device does not respond!':
      localizeMsg =
          AppLocalizations.of(context)!.dialogMessage_DeviceDoesNotRespond;
      break;
    case 'No node':
      localizeMsg = AppLocalizations.of(context)!.dialogMessage_NoNode;
      break;
    case 'Export root data success':
      localizeMsg =
          AppLocalizations.of(context)!.dialogMessage_ExportRootDataSuccess;
      break;
    case 'Export history data success':
      localizeMsg =
          AppLocalizations.of(context)!.dialogMessage_ExportHistoryDataSuccess;
      break;
    case 'Connection failed!':
      localizeMsg = AppLocalizations.of(context)!.connectionFailed;
      break;
    default:
      localizeMsg = msg;
  }

  return localizeMsg;
}
