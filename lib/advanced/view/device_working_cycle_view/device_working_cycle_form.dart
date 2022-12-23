import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/advanced/bloc/device_working_cycle/device_working_cycle_bloc.dart';
import 'package:ricoms_app/repository/device_working_cycle_repository.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/custom_style.dart';

class DeviceWorkingCycleForm extends StatelessWidget {
  const DeviceWorkingCycleForm({Key? key}) : super(key: key);

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

    return BlocListener<DeviceWorkingCycleBloc, DeviceWorkingCycleState>(
      listener: (context, state) {
        if (state.submissionStatus.isSubmissionSuccess) {
          _showSuccessDialog();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.trapAlarmSound,
          ),
          elevation: 0.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
            ),
            const _DeviceWorkingCycleDropDownMenu(),
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

class _DeviceWorkingCycleDropDownMenu extends StatelessWidget {
  const _DeviceWorkingCycleDropDownMenu({
    Key? key,
  }) : super(key: key);

  final Map<String, int> types = const {
    'Administrator': 2,
    'Operator': 3,
    'User': 4,
    'Disabled': 5,
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceWorkingCycleBloc, DeviceWorkingCycleState>(
        buildWhen: (previous, current) =>
            previous.deviceWorkingCycleIndex != current.deviceWorkingCycleIndex,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SizedBox(
              //width: 230,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  alignment: AlignmentDirectional.centerEnd,
                  buttonPadding: const EdgeInsets.only(left: 5, right: 5),
                  buttonHeight: 32,
                  buttonDecoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade700,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.white,
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconDisabledColor: Colors.grey.shade700,
                  value: state.deviceWorkingCycleIndex,
                  items: [
                    for (DeviceWorkingCycle deviceWorkingCycle
                        in state.deviceWorkingCycleList)
                      DropdownMenuItem(
                        value: deviceWorkingCycle.index,
                        child: Text(
                          deviceWorkingCycle.name,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: CommonStyle.sizeL,
                            color: Colors.black,
                          ),
                        ),
                      )
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      context
                          .read<DeviceWorkingCycleBloc>()
                          .add(DeviceWorkingCycleChanged(value));
                    }
                  },
                ),
              ),
            ),
          );
        });
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
          key: const Key('deviceWorkingCycleForm_cancel_raisedButton'),
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
    return BlocBuilder<DeviceWorkingCycleBloc, DeviceWorkingCycleState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(CommonStyle.lineSpacing),
          child: ElevatedButton(
              key: const Key('deviceWorkingCycleForm_save_raisedButton'),
              child: Text(
                AppLocalizations.of(context)!.save,
                style: const TextStyle(
                  fontSize: CommonStyle.sizeM,
                ),
              ),
              onPressed: () {
                context
                    .read<DeviceWorkingCycleBloc>()
                    .add(const DeviceWorkingCycleSaved());
              }),
        );
      },
    );
  }
}
