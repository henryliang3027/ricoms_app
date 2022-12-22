import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/advanced/bloc/trap_alarm_sound/trap_alarm_sound_bloc.dart';
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

    return BlocListener<TrapAlarmSoundBloc, TrapAlarmSoundState>(
      listener: (context, state) {
        if (state.status.isRequestSuccess) {
          _showSuccessDialog();
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
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            const _TrapAlarmSoundEnableSwitch(),
            const _CriticalAlarmSoundEnableSwitch(),
            const _WarningAlarmSoundEnableSwitch(),
            const _NormalAlarmSoundEnableSwitch(),
            const _NoticeAlarmSoundEnableSwitch(),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 80.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _CancelButton(),
                  _SaveButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTrapAlarmSoundSwitchTile({
  required BuildContext context,
  required String title,
  required bool initValue,
  required Function onChange,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        vertical: CommonStyle.lineSpacing, horizontal: 30.0),
    child: Container(
      // width: 320,
      decoration: BoxDecoration(
          color: const Color(0xfffbfbfb),
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4.0)),
      child: SwitchListTile(
        title: Text(title),
        visualDensity: const VisualDensity(vertical: -4.0),
        value: initValue,
        onChanged: (bool value) {
          onChange(value);
        },
      ),
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
          previous.enableTrapAlarmSound != current.enableTrapAlarmSound,
      builder: (context, state) {
        return _buildTrapAlarmSoundSwitchTile(
          context: context,
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
          previous.enableCriticalAlarmSound != current.enableCriticalAlarmSound,
      builder: (context, state) {
        return _buildTrapAlarmSoundSwitchTile(
          context: context,
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
          previous.enableWarningAlarmSound != current.enableWarningAlarmSound,
      builder: (context, state) {
        return _buildTrapAlarmSoundSwitchTile(
          context: context,
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
          previous.enableNormalAlarmSound != current.enableNormalAlarmSound,
      builder: (context, state) {
        return _buildTrapAlarmSoundSwitchTile(
          context: context,
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
          previous.enableNoticeAlarmSound != current.enableNoticeAlarmSound,
      builder: (context, state) {
        return _buildTrapAlarmSoundSwitchTile(
          context: context,
          title: AppLocalizations.of(context)!.noticeTrapAlarmSound,
          initValue: state.enableNoticeAlarmSound,
          onChange: onChangeEnableNoticeAlarmSound,
        );
      },
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(CommonStyle.lineSpacing),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                side: BorderSide(width: 1.0, color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          key: const Key('trapAlarmSoundForm_cancel_raisedButton'),
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: const TextStyle(
              fontSize: CommonStyle.sizeM,
              color: Colors.black,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrapAlarmSoundBloc, TrapAlarmSoundState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(CommonStyle.lineSpacing),
          child: ElevatedButton(
              key: const Key('trapAlarmSoundForm_save_raisedButton'),
              child: Text(
                AppLocalizations.of(context)!.save,
                style: const TextStyle(
                  fontSize: CommonStyle.sizeM,
                ),
              ),
              onPressed: () {
                context
                    .read<TrapAlarmSoundBloc>()
                    .add(const TrapAlarmSoundEnableSaved());
              }),
        );
      },
    );
  }
}
