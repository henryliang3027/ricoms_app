import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getMessageLocalization({
  required String msg,
  required BuildContext context,
}) {
  if (msg == 'There are no records to show') {
    return AppLocalizations.of(context)!.noMoreRecordToShow;
  } else if (msg == 'No more result.') {
    return AppLocalizations.of(context)!.dialogMessage_NoMoreData;
  } else if (msg == 'No results found.') {
    return AppLocalizations.of(context)!.noSearchResult;
  } else if (msg == 'The device does not respond!') {
    return AppLocalizations.of(context)!.dialogMessage_DeviceDoesNotRespond;
  } else if (msg.startsWith('No module in the slot')) {
    RegExp regex =
        RegExp(r'^(No module in the slot ([0-9]+), please try another.)$');

    if (regex.hasMatch(msg)) {
      Iterable<Match> matches = regex.allMatches(msg);
      List<Match> match = matches.toList();
      return AppLocalizations.of(context)!.dialogMessage_NoModuleInTheSlot +
          match[0][2].toString() +
          ' ' +
          AppLocalizations.of(context)!.dialogMessage_PleaseTryAnother;
    } else {
      return msg;
    }
  } else if (msg == 'Please allow permission before you export your data.') {
    return AppLocalizations.of(context)!.dialogMessage_AllFileAccess;
  } else if (msg == 'Login failed. Please reconfirm your account password.') {
    return AppLocalizations.of(context)!.dialogMessage_LoginFailed;
  } else if (msg == 'The device is unconnected and unsupported.') {
    return AppLocalizations.of(context)!.dialogMessage_DeviceUnconnected;
  } else if (msg == 'The device already exists.') {
    return AppLocalizations.of(context)!.dialogMessage_DeviceAlreadyExists;
  } else if (msg == 'No node') {
    return AppLocalizations.of(context)!.dialogMessage_NoNode;
  } else if (msg == 'Export root data success') {
    return AppLocalizations.of(context)!.dialogMessage_ExportRootDataSuccess;
  } else if (msg == 'Export history data success') {
    return AppLocalizations.of(context)!.dialogMessage_ExportHistoryDataSuccess;
  } else if (msg == 'Export system log data success') {
    return AppLocalizations.of(context)!
        .dialogMessage_ExportSystemLogDataSuccess;
  } else if (msg == 'Connection failed!') {
    return AppLocalizations.of(context)!.connectionFailed;
  } else if (msg ==
      'Your confirmation password does not match the new password.') {
    return AppLocalizations.of(context)!.passwordDoesNotMatch;
  } else if (msg == 'Status') {
    return AppLocalizations.of(context)!.deviceSettingTab_status;
  } else if (msg == 'Configuration') {
    return AppLocalizations.of(context)!.deviceSettingTab_configuration;
  } else if (msg == 'IP Configuration') {
    return AppLocalizations.of(context)!.deviceSettingTab_ipConfiguration;
  } else if (msg == 'Threshold') {
    return AppLocalizations.of(context)!.deviceSettingTab_threshold;
  } else if (msg == 'Monitoring Chart') {
    return AppLocalizations.of(context)!.deviceSettingTab_monitoringChart;
  } else if (msg == 'Description') {
    return AppLocalizations.of(context)!.deviceSettingTab_description;
  } else if (msg == 'Summary') {
    return AppLocalizations.of(context)!.deviceSettingTab_summary;
  } else if (msg == 'WAN Settings') {
    return AppLocalizations.of(context)!.deviceSettingTab_wanSettings;
  } else if (msg == 'SNMP Setup') {
    return AppLocalizations.of(context)!.deviceSettingTab_snmpSetup;
  } else if (msg == 'Setup completed!') {
    return AppLocalizations.of(context)!.dialogTitle_setupCompleted;
  } else if (msg == 'Setting failed.') {
    return AppLocalizations.of(context)!.dialogTitle_setupFailed;
  } else if (msg == 'Lost connection to Server.') {
    return AppLocalizations.of(context)!.dialogTitle_lostConnectionToServer;
  } else if (msg ==
      'Please make sure you are on the same domain as the server and try to login again.') {
    return AppLocalizations.of(context)!
        .dialogMessage_lostConnectionToServerContent;
  } else if (msg == 'Error') {
    return AppLocalizations.of(context)!.dialogTitle_error;
  } else {
    return msg;
  }
}
