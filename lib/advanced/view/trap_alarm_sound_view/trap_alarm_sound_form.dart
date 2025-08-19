import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/advanced/bloc/trap_alarm_sound/trap_alarm_sound_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/custom_style.dart';

class TrapAlarmSoundForm extends StatelessWidget {
  const TrapAlarmSoundForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return BlocListener<TrapAlarmSoundBloc, TrapAlarmSoundState>(
      listener: (context, state) {
        if (state.status.isRequestSuccess) {
          _showSuccessDialog();
        } else if (state.status.isRequestFailure) {
          _showFailureDialog(state.errmsg);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.trapAlarmSound,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            _TrapAlarmSoundEnableSwitch(),
            _CriticalAlarmSoundEnableSwitch(),
            _WarningAlarmSoundEnableSwitch(),
            _NormalAlarmSoundEnableSwitch(),
            _NoticeAlarmSoundEnableSwitch(),
          ],
        ),
        floatingActionButton: const _SoundSwitchEditFloatingActionButton(),
      ),
    );
  }
}

Widget _buildTrapAlarmSoundSwitchTile({
  required BuildContext context,
  required bool isEditing,
  required String title,
  required bool initValue,
  required Function onChange,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        vertical: CommonStyle.lineSpacing, horizontal: 24.0),
    child: SwitchListTile(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      title: Text(title),
      visualDensity: const VisualDensity(vertical: -4.0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      value: initValue,
      onChanged: isEditing
          ? (bool value) {
              onChange(value);
            }
          : null,
    ),
  );
}

class _TrapAlarmSoundEnableSwitch extends StatelessWidget {
  const _TrapAlarmSoundEnableSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onChangeEnableTrapAlarmSound(bool value) {
      context.read<TrapAlarmSoundBloc>().add(TrapAlarmSoundEnabled(value));
    }

    return BlocBuilder<TrapAlarmSoundBloc, TrapAlarmSoundState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.enableTrapAlarmSound != current.enableTrapAlarmSound,
      builder: (context, state) {
        return _buildTrapAlarmSoundSwitchTile(
          context: context,
          isEditing: state.isEditing,
          title: AppLocalizations.of(context)!.trapAlarmSoundEnable,
          initValue: state.enableTrapAlarmSound,
          onChange: onChangeEnableTrapAlarmSound,
        );
      },
    );
  }
}

class _CriticalAlarmSoundEnableSwitch extends StatelessWidget {
  const _CriticalAlarmSoundEnableSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onChangeEnableCriticalAlarmSound(bool value) {
      context.read<TrapAlarmSoundBloc>().add(CriticalAlarmSoundEnabled(value));
    }

    return BlocBuilder<TrapAlarmSoundBloc, TrapAlarmSoundState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.enableCriticalAlarmSound != current.enableCriticalAlarmSound,
      builder: (context, state) {
        return _buildTrapAlarmSoundSwitchTile(
          context: context,
          isEditing: state.isEditing,
          title: AppLocalizations.of(context)!.criticalTrapAlarmSound,
          initValue: state.enableCriticalAlarmSound,
          onChange: onChangeEnableCriticalAlarmSound,
        );
      },
    );
  }
}

class _WarningAlarmSoundEnableSwitch extends StatelessWidget {
  const _WarningAlarmSoundEnableSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onChangeEnableWarningAlarmSound(bool value) {
      context.read<TrapAlarmSoundBloc>().add(WarningAlarmSoundEnabled(value));
    }

    return BlocBuilder<TrapAlarmSoundBloc, TrapAlarmSoundState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.enableWarningAlarmSound != current.enableWarningAlarmSound,
      builder: (context, state) {
        return _buildTrapAlarmSoundSwitchTile(
          context: context,
          isEditing: state.isEditing,
          title: AppLocalizations.of(context)!.warningTrapAlarmSound,
          initValue: state.enableWarningAlarmSound,
          onChange: onChangeEnableWarningAlarmSound,
        );
      },
    );
  }
}

class _NormalAlarmSoundEnableSwitch extends StatelessWidget {
  const _NormalAlarmSoundEnableSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onChangeEnableNormalAlarmSound(bool value) {
      context.read<TrapAlarmSoundBloc>().add(NormalAlarmSoundEnabled(value));
    }

    return BlocBuilder<TrapAlarmSoundBloc, TrapAlarmSoundState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.enableNormalAlarmSound != current.enableNormalAlarmSound,
      builder: (context, state) {
        return _buildTrapAlarmSoundSwitchTile(
          context: context,
          isEditing: state.isEditing,
          title: AppLocalizations.of(context)!.normalTrapAlarmSound,
          initValue: state.enableNormalAlarmSound,
          onChange: onChangeEnableNormalAlarmSound,
        );
      },
    );
  }
}

class _NoticeAlarmSoundEnableSwitch extends StatelessWidget {
  const _NoticeAlarmSoundEnableSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onChangeEnableNoticeAlarmSound(bool value) {
      context.read<TrapAlarmSoundBloc>().add(NoticeAlarmSoundEnabled(value));
    }

    return BlocBuilder<TrapAlarmSoundBloc, TrapAlarmSoundState>(
      buildWhen: (previous, current) =>
          previous.isEditing != current.isEditing ||
          previous.enableNoticeAlarmSound != current.enableNoticeAlarmSound,
      builder: (context, state) {
        return _buildTrapAlarmSoundSwitchTile(
          context: context,
          isEditing: state.isEditing,
          title: AppLocalizations.of(context)!.noticeTrapAlarmSound,
          initValue: state.enableNoticeAlarmSound,
          onChange: onChangeEnableNoticeAlarmSound,
        );
      },
    );
  }
}

class _SoundSwitchEditFloatingActionButton extends StatelessWidget {
  const _SoundSwitchEditFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrapAlarmSoundBloc, TrapAlarmSoundState>(
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
                          .read<TrapAlarmSoundBloc>()
                          .add(const TrapAlarmSoundEnableSaved());
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
                            .read<TrapAlarmSoundBloc>()
                            .add(const EditModeDisabled());
                      },
                      child: const Icon(CustomIcons.cancel)),
                ],
              )
            : FloatingActionButton(
                elevation: 0.0,
                backgroundColor: const Color(0x742195F3),
                onPressed: () {
                  context
                      .read<TrapAlarmSoundBloc>()
                      .add(const EditModeEnabled());
                },
                child: const Icon(Icons.edit),
              );
      },
    );
  }
}
