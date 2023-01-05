import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/advanced/bloc/log_record_setting/log_record_setting_bloc.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/custom_style.dart';

class LogRecordSettingForm extends StatelessWidget {
  const LogRecordSettingForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _archivedHistoricalRecordQuanitiyController =
        TextEditingController();
    TextEditingController apiLogPreservedQuantityController =
        TextEditingController();
    TextEditingController apiLogPreservedDaysController =
        TextEditingController();
    TextEditingController userSystemLogPreservedQuantityController =
        TextEditingController();
    TextEditingController userSystemLogPreservedDaysController =
        TextEditingController();
    TextEditingController deviceSystemLogPreservedQuantityController =
        TextEditingController();
    TextEditingController deviceSystemLogPreservedDaysController =
        TextEditingController();

    Future<void> _showSuccessDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitle_editSuccess,
              style: const TextStyle(
                color: CustomStyle.customGreen,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _showFailureDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.dialogTitle_error,
              style: const TextStyle(
                color: CustomStyle.customRed,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(msg),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    return BlocListener<LogRecordSettingBloc, LogRecordSettingState>(
      listener: (context, state) {
        if (state.status.isRequestSuccess) {
          _archivedHistoricalRecordQuanitiyController.text =
              state.archivedHistoricalRecordQuanitiy;
          apiLogPreservedQuantityController.text =
              state.apiLogPreservedQuantity;
          apiLogPreservedDaysController.text = state.apiLogPreservedDays;
          userSystemLogPreservedQuantityController.text =
              state.userSystemLogPreservedQuantity;
          userSystemLogPreservedDaysController.text =
              state.userSystemLogPreservedDays;
          deviceSystemLogPreservedQuantityController.text =
              state.deviceSystemLogPreservedQuantity;
          deviceSystemLogPreservedDaysController.text =
              state.deviceSystemLogPreservedDays;
        } else if (state.status.isRequestFailure) {
          _showFailureDialog(state.requestErrorMsg);
        } else if (state.submissionStatus.isSubmissionSuccess) {
          _showSuccessDialog();
        } else if (state.submissionStatus.isSubmissionFailure) {
          _showFailureDialog(state.submissionErrorMsg);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.deviceWorkingCycle,
          ),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                ),
                _SettingTitle(
                  title: AppLocalizations.of(context)!.trapHistory,
                ),
                _ArchivedHistoricalRecordQuanitiyInput(
                  archivedHistoricalRecordQuanitiyController:
                      _archivedHistoricalRecordQuanitiyController,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SettingTitle(
                      title: AppLocalizations.of(context)!.apiLog,
                    ),
                    const _ApiLogPreservationSwitchTile(),
                  ],
                ),
                _ApiLogPreservedQuantityInput(
                  apiLogPreservedQuantityController:
                      apiLogPreservedQuantityController,
                ),
                _ApiLogPreservedDaysInput(
                  apiLogPreservedDaysController: apiLogPreservedDaysController,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SettingTitle(
                      title: AppLocalizations.of(context)!.userSystemLog,
                    ),
                    const _UserSystemLogPreservationSwitchTile(),
                  ],
                ),
                _UserSystemLogPreservedQuantityInput(
                  userSystemLogPreservedQuantityController:
                      userSystemLogPreservedQuantityController,
                ),
                _UserSystemLogPreservedDaysInput(
                  userSystemLogPreservedDaysController:
                      userSystemLogPreservedDaysController,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SettingTitle(
                      title: AppLocalizations.of(context)!.deviceSystemLog,
                    ),
                    const _DeviceSystemLogPreservationSwitchTile(),
                  ],
                ),
                _DeviceSystemLogPreservedQuantityInput(
                  deviceSystemLogPreservedQuantityController:
                      deviceSystemLogPreservedQuantityController,
                ),
                _DeviceSystemLogPreservedDaysInput(
                  deviceSystemLogPreservedDaysController:
                      deviceSystemLogPreservedDaysController,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: const _LogRecordSettingEditFloatingActionButton(),
      ),
    );
  }
}

// class _LogRecordSettingPanel extends StatelessWidget {
//   const _LogRecordSettingPanel({
//     Key? key,
//     required this.panelTitle,
//     required this.preservedQuantityController,
//     required this.preservedDaysController,
//   }) : super(key: key);

//   final String panelTitle;
//   final TextEditingController preservedQuantityController;
//   final TextEditingController preservedDaysController;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _SettingTitle(
//               title: panelTitle,
//             ),
//             const _DeviceSystemLogPreservationSwitchTile(),
//           ],
//         ),
//         _UserSystemLogPreservedQuantityInput(
//           userSystemLogPreservedQuantityController: preservedQuantityController,
//         ),
//         _UserSystemLogPreservedDaysInput(
//           userSystemLogPreservedDaysController: preservedDaysController,
//         ),
//       ],
//     );
//   }
// }

class _SettingTitle extends StatelessWidget {
  const _SettingTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
        ),
      ],
    );
  }
}

class _ArchivedHistoricalRecordQuanitiyInput extends StatelessWidget {
  const _ArchivedHistoricalRecordQuanitiyInput(
      {Key? key, required this.archivedHistoricalRecordQuanitiyController})
      : super(key: key);

  final TextEditingController archivedHistoricalRecordQuanitiyController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogRecordSettingBloc, LogRecordSettingState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.archivedHistoricalRecordQuanitiy !=
              current.archivedHistoricalRecordQuanitiy,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: CommonStyle.lineSpacing,
          ),
          child: TextFormField(
            key: const Key(
                'logRecordSettingForm_archivedHistoricalRecordQuanitiyInput_textField'),
            controller: archivedHistoricalRecordQuanitiyController,
            textInputAction: TextInputAction.done,
            enabled: state.isEditing,
            style: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            onChanged: (value) {
              context
                  .read<LogRecordSettingBloc>()
                  .add(ArchivedHistoricalRecordQuanitiyChanged(value));
            },
            maxLength: 64,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: state.isEditing ? Colors.white : Colors.grey.shade300,
              counterText: '',
              labelText: AppLocalizations.of(context)!
                  .archivedHistoricalRecordQuanitiy,
              labelStyle: TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey.shade400,
              ),
              // errorMaxLines: 2,
              // errorStyle: const TextStyle(
              //   fontSize: CommonStyle.sizeS,
              //   color: Colors.red,
              // ),
              // errorText: state.masterServerIP.invalid
              //     ? AppLocalizations.of(context)!.ipErrorText
              //     : null,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ApiLogPreservationSwitchTile extends StatelessWidget {
  const _ApiLogPreservationSwitchTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogRecordSettingBloc, LogRecordSettingState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.enableApiLogPreservation != current.enableApiLogPreservation,
      builder: (context, state) {
        return Switch(
          value: state.enableApiLogPreservation,
          onChanged: state.isEditing
              ? (value) {
                  context
                      .read<LogRecordSettingBloc>()
                      .add(ApiLogPreservationEnabled(value));
                }
              : null,
        );
      },
    );
  }
}

class _ApiLogPreservedQuantityInput extends StatelessWidget {
  const _ApiLogPreservedQuantityInput(
      {Key? key, required this.apiLogPreservedQuantityController})
      : super(key: key);

  final TextEditingController apiLogPreservedQuantityController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogRecordSettingBloc, LogRecordSettingState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.apiLogPreservedQuantity != current.apiLogPreservedQuantity,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: CommonStyle.lineSpacing,
          ),
          child: TextFormField(
            key: const Key(
                'logRecordSettingForm_apiLogPreservedQuantityInput_textField'),
            controller: apiLogPreservedQuantityController,
            textInputAction: TextInputAction.done,
            enabled: state.isEditing,
            style: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            onChanged: (value) {
              context
                  .read<LogRecordSettingBloc>()
                  .add(ApiLogPreservedQuantityChanged(value));
            },
            maxLength: 64,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: state.isEditing ? Colors.white : Colors.grey.shade300,
              counterText: '',
              labelText: AppLocalizations.of(context)!.preservedQuantity,
              labelStyle: TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey.shade400,
              ),
              // errorMaxLines: 2,
              // errorStyle: const TextStyle(
              //   fontSize: CommonStyle.sizeS,
              //   color: Colors.red,
              // ),
              // errorText: state.masterServerIP.invalid
              //     ? AppLocalizations.of(context)!.ipErrorText
              //     : null,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ApiLogPreservedDaysInput extends StatelessWidget {
  const _ApiLogPreservedDaysInput(
      {Key? key, required this.apiLogPreservedDaysController})
      : super(key: key);

  final TextEditingController apiLogPreservedDaysController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogRecordSettingBloc, LogRecordSettingState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.apiLogPreservedDays != current.apiLogPreservedDays,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: CommonStyle.lineSpacing,
          ),
          child: TextFormField(
            key: const Key(
                'logRecordSettingForm_apiLogPreservedDaysInput_textField'),
            controller: apiLogPreservedDaysController,
            textInputAction: TextInputAction.done,
            enabled: state.isEditing,
            style: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            onChanged: (value) {
              context
                  .read<LogRecordSettingBloc>()
                  .add(ApiLogPreservedDaysChanged(value));
            },
            maxLength: 64,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: state.isEditing ? Colors.white : Colors.grey.shade300,
              counterText: '',
              labelText: AppLocalizations.of(context)!.preservedDays,
              labelStyle: TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey.shade400,
              ),
              // errorMaxLines: 2,
              // errorStyle: const TextStyle(
              //   fontSize: CommonStyle.sizeS,
              //   color: Colors.red,
              // ),
              // errorText: state.masterServerIP.invalid
              //     ? AppLocalizations.of(context)!.ipErrorText
              //     : null,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UserSystemLogPreservationSwitchTile extends StatelessWidget {
  const _UserSystemLogPreservationSwitchTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogRecordSettingBloc, LogRecordSettingState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.enableUserSystemLogPreservation !=
              current.enableUserSystemLogPreservation,
      builder: (context, state) {
        return Switch(
          value: state.enableUserSystemLogPreservation,
          onChanged: state.isEditing
              ? (value) {
                  context
                      .read<LogRecordSettingBloc>()
                      .add(UserSystemLogPreservationEnabled(value));
                }
              : null,
        );
      },
    );
  }
}

class _UserSystemLogPreservedQuantityInput extends StatelessWidget {
  const _UserSystemLogPreservedQuantityInput(
      {Key? key, required this.userSystemLogPreservedQuantityController})
      : super(key: key);

  final TextEditingController userSystemLogPreservedQuantityController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogRecordSettingBloc, LogRecordSettingState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.userSystemLogPreservedQuantity !=
              current.userSystemLogPreservedQuantity,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: CommonStyle.lineSpacing,
          ),
          child: TextFormField(
            key: const Key(
                'logRecordSettingForm_userSystemLogPreservedQuantityInput_textField'),
            controller: userSystemLogPreservedQuantityController,
            textInputAction: TextInputAction.done,
            enabled: state.isEditing,
            style: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            onChanged: (value) {
              context
                  .read<LogRecordSettingBloc>()
                  .add(UserSystemLogPreservedQuantityChanged(value));
            },
            maxLength: 64,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: state.isEditing ? Colors.white : Colors.grey.shade300,
              counterText: '',
              labelText: AppLocalizations.of(context)!.preservedQuantity,
              labelStyle: TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey.shade400,
              ),
              // errorMaxLines: 2,
              // errorStyle: const TextStyle(
              //   fontSize: CommonStyle.sizeS,
              //   color: Colors.red,
              // ),
              // errorText: state.masterServerIP.invalid
              //     ? AppLocalizations.of(context)!.ipErrorText
              //     : null,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UserSystemLogPreservedDaysInput extends StatelessWidget {
  const _UserSystemLogPreservedDaysInput(
      {Key? key, required this.userSystemLogPreservedDaysController})
      : super(key: key);

  final TextEditingController userSystemLogPreservedDaysController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogRecordSettingBloc, LogRecordSettingState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.userSystemLogPreservedDays !=
              current.userSystemLogPreservedDays,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: CommonStyle.lineSpacing,
          ),
          child: TextFormField(
            key: const Key(
                'logRecordSettingForm_userSystemLogPreservedDaysInput_textField'),
            controller: userSystemLogPreservedDaysController,
            textInputAction: TextInputAction.done,
            enabled: state.isEditing,
            style: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            onChanged: (value) {
              context
                  .read<LogRecordSettingBloc>()
                  .add(UserSystemLogPreservedDaysChanged(value));
            },
            maxLength: 64,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: state.isEditing ? Colors.white : Colors.grey.shade300,
              counterText: '',
              labelText: AppLocalizations.of(context)!.preservedDays,
              labelStyle: TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey.shade400,
              ),
              // errorMaxLines: 2,
              // errorStyle: const TextStyle(
              //   fontSize: CommonStyle.sizeS,
              //   color: Colors.red,
              // ),
              // errorText: state.masterServerIP.invalid
              //     ? AppLocalizations.of(context)!.ipErrorText
              //     : null,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DeviceSystemLogPreservationSwitchTile extends StatelessWidget {
  const _DeviceSystemLogPreservationSwitchTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogRecordSettingBloc, LogRecordSettingState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.enableDeviceSystemLogPreservation !=
              current.enableDeviceSystemLogPreservation,
      builder: (context, state) {
        return Switch(
          value: state.enableDeviceSystemLogPreservation,
          onChanged: state.isEditing
              ? (value) {
                  context
                      .read<LogRecordSettingBloc>()
                      .add(DeviceSystemLogPreservationEnabled(value));
                }
              : null,
        );
      },
    );
  }
}

class _DeviceSystemLogPreservedQuantityInput extends StatelessWidget {
  const _DeviceSystemLogPreservedQuantityInput(
      {Key? key, required this.deviceSystemLogPreservedQuantityController})
      : super(key: key);

  final TextEditingController deviceSystemLogPreservedQuantityController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogRecordSettingBloc, LogRecordSettingState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.deviceSystemLogPreservedQuantity !=
              current.deviceSystemLogPreservedQuantity,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: CommonStyle.lineSpacing,
          ),
          child: TextFormField(
            key: const Key(
                'logRecordSettingForm_deviceSystemLogPreservedQuantityInput_textField'),
            controller: deviceSystemLogPreservedQuantityController,
            textInputAction: TextInputAction.done,
            enabled: state.isEditing,
            style: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            onChanged: (value) {
              context
                  .read<LogRecordSettingBloc>()
                  .add(DeviceSystemLogPreservedQuantityChanged(value));
            },
            maxLength: 64,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: state.isEditing ? Colors.white : Colors.grey.shade300,
              counterText: '',
              labelText: AppLocalizations.of(context)!.preservedQuantity,
              labelStyle: TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey.shade400,
              ),
              // errorMaxLines: 2,
              // errorStyle: const TextStyle(
              //   fontSize: CommonStyle.sizeS,
              //   color: Colors.red,
              // ),
              // errorText: state.masterServerIP.invalid
              //     ? AppLocalizations.of(context)!.ipErrorText
              //     : null,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DeviceSystemLogPreservedDaysInput extends StatelessWidget {
  const _DeviceSystemLogPreservedDaysInput(
      {Key? key, required this.deviceSystemLogPreservedDaysController})
      : super(key: key);

  final TextEditingController deviceSystemLogPreservedDaysController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogRecordSettingBloc, LogRecordSettingState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.deviceSystemLogPreservedDays !=
              current.deviceSystemLogPreservedDays,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: CommonStyle.lineSpacing,
          ),
          child: TextFormField(
            key: const Key(
                'logRecordSettingForm_userSystemLogPreservedDaysInput_textField'),
            controller: deviceSystemLogPreservedDaysController,
            textInputAction: TextInputAction.done,
            enabled: state.isEditing,
            style: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            onChanged: (value) {
              context
                  .read<LogRecordSettingBloc>()
                  .add(DeviceSystemLogPreservedDaysChanged(value));
            },
            maxLength: 64,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: state.isEditing ? Colors.white : Colors.grey.shade300,
              counterText: '',
              labelText: AppLocalizations.of(context)!.preservedDays,
              labelStyle: TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey.shade400,
              ),
              // errorMaxLines: 2,
              // errorStyle: const TextStyle(
              //   fontSize: CommonStyle.sizeS,
              //   color: Colors.red,
              // ),
              // errorText: state.masterServerIP.invalid
              //     ? AppLocalizations.of(context)!.ipErrorText
              //     : null,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LogRecordSettingEditFloatingActionButton extends StatelessWidget {
  const _LogRecordSettingEditFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map _userFunctionMap =
        context.read<AuthenticationBloc>().state.userFunctionMap;

    return BlocBuilder<LogRecordSettingBloc, LogRecordSettingState>(
      builder: (context, state) {
        return _userFunctionMap[37]
            ? state.isEditing
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        heroTag: null,
                        elevation: 0.0,
                        backgroundColor: const Color(0x742195F3),
                        onPressed: () {
                          context
                              .read<LogRecordSettingBloc>()
                              .add(const LogRecordSettingSaved());
                        },
                        child: const Icon(CustomIcons.check),
                        //const Text('Save'),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(6.0),
                      ),
                      FloatingActionButton(
                          heroTag: null,
                          elevation: 0.0,
                          backgroundColor: const Color(0x742195F3),
                          onPressed: () {
                            context
                                .read<LogRecordSettingBloc>()
                                .add(const EditModeDisabled());
                            context
                                .read<LogRecordSettingBloc>()
                                .add(const LogRecordSettingRequest());
                          },
                          child: const Icon(CustomIcons.cancel)),
                    ],
                  )
                : FloatingActionButton(
                    elevation: 0.0,
                    backgroundColor: const Color(0x742195F3),
                    onPressed: () {
                      context
                          .read<LogRecordSettingBloc>()
                          .add(const EditModeEnabled());
                    },
                    child: const Icon(Icons.edit),
                  )
            : Container();
      },
    );
  }
}
