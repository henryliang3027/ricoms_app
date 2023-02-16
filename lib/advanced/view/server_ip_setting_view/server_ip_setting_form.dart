import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/advanced/bloc/server_ip_setting/server_ip_setting_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/custom_style.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class ServerIPSettingForm extends StatelessWidget {
  const ServerIPSettingForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _masterServerIPController = TextEditingController();
    TextEditingController _slaveServerIPController = TextEditingController();
    TextEditingController _synchronizationIntervalController =
        TextEditingController();
    TextEditingController _onlineServerIPController = TextEditingController();

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
                  Text(
                    getMessageLocalization(
                      msg: msg,
                      context: context,
                    ),
                  ),
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

    return BlocListener<ServerIPSettingBloc, ServerIPSettingState>(
      listener: (context, state) {
        if (state.status.isRequestSuccess) {
          _masterServerIPController.text = state.masterServerIP.value;
          _slaveServerIPController.text = state.slaveServerIP.value;
          _synchronizationIntervalController.text =
              state.synchronizationInterval;
          _onlineServerIPController.text = state.onlineServerIP.value;
        } else if (state.status.isRequestFailure) {
          _showFailureDialog(state.errmsg);
        }
        if (state.submissionStatus.isSubmissionSuccess) {
          _showSuccessDialog();
        } else if (state.submissionStatus.isSubmissionFailure) {
          _showFailureDialog(state.errmsg);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.serverIPSetting,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              _MasterServerIPInput(
                  masterServerIPController: _masterServerIPController),
              _SlaveServerIPInput(
                  slaveServerIPController: _slaveServerIPController),
              _SynchronizationIntervalInput(
                  synchronizationIntervalController:
                      _synchronizationIntervalController),
              _OnlineServerIPInput(
                  onlineServerIPController: _onlineServerIPController),
              const _ServerIPSettingHint(),
            ],
          ),
        ),
        floatingActionButton: const _ServerIPSettingEditFloatingActionButton(),
      ),
    );
  }
}

class _MasterServerIPInput extends StatelessWidget {
  const _MasterServerIPInput({Key? key, required this.masterServerIPController})
      : super(key: key);

  final TextEditingController masterServerIPController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerIPSettingBloc, ServerIPSettingState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.masterServerIP != current.masterServerIP,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              vertical: CommonStyle.lineSpacing, horizontal: 36.0),
          child: TextFormField(
            key: const Key('serverIPsettingForm_masterServerIPInput_textField'),
            controller: masterServerIPController,
            textInputAction: TextInputAction.done,
            enabled: state.isEditing,
            style: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            onChanged: (ip) {
              context
                  .read<ServerIPSettingBloc>()
                  .add(MasterServerIPChanged(ip));
            },
            maxLength: 64,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: state.isEditing ? Colors.white : Colors.grey.shade300,
              counterText: '',
              labelText: AppLocalizations.of(context)!.masterServerIP,
              labelStyle: TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey.shade400,
              ),
              errorMaxLines: 2,
              errorStyle: const TextStyle(
                fontSize: CommonStyle.sizeS,
                color: Colors.red,
              ),
              errorText: state.masterServerIP.invalid
                  ? AppLocalizations.of(context)!.ipErrorText
                  : null,
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

class _SlaveServerIPInput extends StatelessWidget {
  const _SlaveServerIPInput({Key? key, required this.slaveServerIPController})
      : super(key: key);

  final TextEditingController slaveServerIPController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerIPSettingBloc, ServerIPSettingState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.slaveServerIP != current.slaveServerIP,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              vertical: CommonStyle.lineSpacing, horizontal: 36.0),
          child: TextFormField(
            key: const Key('serverIPsettingForm_slaveServerIPInput_textField'),
            controller: slaveServerIPController,
            textInputAction: TextInputAction.done,
            enabled: state.isEditing,
            style: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            onChanged: (ip) {
              context.read<ServerIPSettingBloc>().add(SlaveServerIPChanged(ip));
            },
            maxLength: 64,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: state.isEditing ? Colors.white : Colors.grey.shade300,
              counterText: '',
              labelText: AppLocalizations.of(context)!.slaveServerIP,
              labelStyle: TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey.shade400,
              ),
              errorMaxLines: 2,
              errorStyle: const TextStyle(
                fontSize: CommonStyle.sizeS,
                color: Colors.red,
              ),
              errorText: state.slaveServerIP.invalid
                  ? AppLocalizations.of(context)!.ipErrorText
                  : null,
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

class _SynchronizationIntervalInput extends StatelessWidget {
  const _SynchronizationIntervalInput(
      {Key? key, required this.synchronizationIntervalController})
      : super(key: key);

  final TextEditingController synchronizationIntervalController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerIPSettingBloc, ServerIPSettingState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.synchronizationInterval != current.synchronizationInterval,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              vertical: CommonStyle.lineSpacing, horizontal: 36.0),
          child: TextFormField(
            key: const Key(
                'serverIPsettingForm_synchronizationIntervalInput_textField'),
            controller: synchronizationIntervalController,
            textInputAction: TextInputAction.done,
            enabled: false,
            style: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            onChanged: (interval) {
              context
                  .read<ServerIPSettingBloc>()
                  .add(SynchronizationIntervalChanged(interval));
            },
            maxLength: 64,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: Colors.grey.shade300,
              counterText: '',
              labelText: AppLocalizations.of(context)!.synchronizationInterval,
              labelStyle: TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey.shade400,
              ),
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

class _OnlineServerIPInput extends StatelessWidget {
  const _OnlineServerIPInput({Key? key, required this.onlineServerIPController})
      : super(key: key);

  final TextEditingController onlineServerIPController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerIPSettingBloc, ServerIPSettingState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.onlineServerIP != current.onlineServerIP,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              vertical: CommonStyle.lineSpacing, horizontal: 36.0),
          child: TextFormField(
            key: const Key('serverIPsettingForm_onlineServerIPInput_textField'),
            controller: onlineServerIPController,
            textInputAction: TextInputAction.done,
            enabled: false,
            style: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            onChanged: (ip) {
              context
                  .read<ServerIPSettingBloc>()
                  .add(OnlineServerIPChanged(ip));
            },
            maxLength: 64,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: Colors.grey.shade300,
              counterText: '',
              labelText: AppLocalizations.of(context)!.onlineServerIP,
              labelStyle: TextStyle(
                fontSize: CommonStyle.sizeL,
                color: Colors.grey.shade400,
              ),
              errorMaxLines: 2,
              errorStyle: const TextStyle(
                fontSize: CommonStyle.sizeS,
                color: Colors.red,
              ),
              errorText: state.onlineServerIP.invalid
                  ? AppLocalizations.of(context)!.ipErrorText
                  : null,
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

class _ServerIPSettingHint extends StatelessWidget {
  const _ServerIPSettingHint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36.0),
      child: Stack(
        children: [
          const Positioned.fill(
            child: Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Icon(
                Icons.info,
                color: Color.fromARGB(128, 158, 158, 158),
              ),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.serverIPSettingHint,
            style: TextStyle(color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}

class _ServerIPSettingEditFloatingActionButton extends StatelessWidget {
  const _ServerIPSettingEditFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerIPSettingBloc, ServerIPSettingState>(
      builder: (context, state) {
        return state.isEditing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: null,
                    elevation: 0.0,
                    backgroundColor: const Color(0x742195F3),
                    onPressed: () {
                      context
                          .read<ServerIPSettingBloc>()
                          .add(const ServerIPSettingSaved());
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
                            .read<ServerIPSettingBloc>()
                            .add(const EditModeDisabled());
                        context
                            .read<ServerIPSettingBloc>()
                            .add(const ServerIPSettingRequested());
                      },
                      child: const Icon(CustomIcons.cancel)),
                ],
              )
            : FloatingActionButton(
                elevation: 0.0,
                backgroundColor: const Color(0x742195F3),
                onPressed: () {
                  context
                      .read<ServerIPSettingBloc>()
                      .add(const EditModeEnabled());
                },
                child: const Icon(Icons.edit),
              );
      },
    );
  }
}
