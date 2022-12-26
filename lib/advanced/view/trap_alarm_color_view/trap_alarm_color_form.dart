import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/advanced/bloc/trap_alarm_color/trap_alarm_color_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/custom_style.dart';

class TrapAlarmColorForm extends StatelessWidget {
  const TrapAlarmColorForm({Key? key}) : super(key: key);

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

    return BlocListener<TrapAlarmColorBloc, TrapAlarmColorState>(
      listener: (context, state) {
        if (state.status.isRequestSuccess) {
          _showSuccessDialog();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.colorOfTrapAlarm,
          ),
        ),
        body: Scrollbar(
          thickness: 8.0,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                _CriticalTrapColorCard(),
                _WarningTrapColorCard(),
                _NormalTrapColorCard(),
                _NoticeTrapColorCard(),
                _ResetButton(),
                SizedBox(
                  height: 140.0,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: const _ColorEditFloatingActionButton(),
      ),
    );
  }
}

Future<int?> _showColorPickerDialog({
  required BuildContext context,
  required int currentColor,
}) async {
  Color _pickerColor = Color(currentColor);
  return showDialog<int?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _pickerColor,
            onColorChanged: (Color color) {
              _pickerColor = color;
            },
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(_pickerColor.value);
            },
          ),
        ],
      );
    },
  );
}

Widget _buildContent({
  required BuildContext context,
  required bool isEditing,
  required String trapAlarmTitle,
  required int trapAlarmBackgroundColor,
  required int trapAlarmTextColor,
  required Function onChangeBackgroundColor,
  required Function onChangeTextColor,
}) {
  return Padding(
    padding:
        const EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 0.0),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  trapAlarmTitle,
                  style: const TextStyle(
                    fontSize: CommonStyle.sizeXL,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.trapAlarmBackgroundColor,
                  style: const TextStyle(
                    fontSize: CommonStyle.sizeL,
                  ),
                ),
                ElevatedButton(
                  onPressed: isEditing
                      ? () {
                          onChangeBackgroundColor();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: Color(trapAlarmBackgroundColor),
                    disabledBackgroundColor: Color(trapAlarmBackgroundColor),
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(1.0))),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: null,
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.trapAlarmTextColor,
                  style: const TextStyle(
                    fontSize: CommonStyle.sizeL,
                  ),
                ),
                ElevatedButton(
                  onPressed: isEditing
                      ? () {
                          onChangeTextColor();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: Color(trapAlarmTextColor),
                    disabledBackgroundColor: Color(trapAlarmTextColor),
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(1.0))),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: null,
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.trapAlarmColorPreview,
                  style: const TextStyle(
                    fontSize: CommonStyle.sizeL,
                  ),
                ),
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80.0, 40.0),
                    elevation: 0.0,
                    disabledBackgroundColor: Color(trapAlarmBackgroundColor),
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(1.0))),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    trapAlarmTitle,
                    style: TextStyle(
                      color: Color(trapAlarmTextColor),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

class _CriticalTrapColorCard extends StatelessWidget {
  const _CriticalTrapColorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrapAlarmColorBloc, TrapAlarmColorState>(
      builder: (context, state) {
        void changeBackgroundColor() async {
          int? pickedColor = await _showColorPickerDialog(
            context: context,
            currentColor: state.criticalBackgroundColor,
          );

          if (pickedColor != null) {
            context
                .read<TrapAlarmColorBloc>()
                .add(CriticalBackgroundColorChanged(pickedColor));
          }
        }

        void changeTextColor() async {
          int? pickedColor = await _showColorPickerDialog(
            context: context,
            currentColor: state.criticalTextColor,
          );

          if (pickedColor != null) {
            context
                .read<TrapAlarmColorBloc>()
                .add(CriticalTextColorChanged(pickedColor));
          }
        }

        return _buildContent(
          context: context,
          isEditing: state.isEditing,
          trapAlarmTitle: AppLocalizations.of(context)!.critical,
          trapAlarmBackgroundColor: state.criticalBackgroundColor,
          trapAlarmTextColor: state.criticalTextColor,
          onChangeBackgroundColor: changeBackgroundColor,
          onChangeTextColor: changeTextColor,
        );
      },
    );
  }
}

class _WarningTrapColorCard extends StatelessWidget {
  const _WarningTrapColorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrapAlarmColorBloc, TrapAlarmColorState>(
      builder: (context, state) {
        void changeBackgroundColor() async {
          int? pickedColor = await _showColorPickerDialog(
            context: context,
            currentColor: state.warningBackgroundColor,
          );

          if (pickedColor != null) {
            context
                .read<TrapAlarmColorBloc>()
                .add(WarningBackgroundColorChanged(pickedColor));
          }
        }

        void changeTextColor() async {
          int? pickedColor = await _showColorPickerDialog(
            context: context,
            currentColor: state.warningTextColor,
          );

          if (pickedColor != null) {
            context
                .read<TrapAlarmColorBloc>()
                .add(WarningTextColorChanged(pickedColor));
          }
        }

        return _buildContent(
          context: context,
          isEditing: state.isEditing,
          trapAlarmTitle: AppLocalizations.of(context)!.warning,
          trapAlarmBackgroundColor: state.warningBackgroundColor,
          trapAlarmTextColor: state.warningTextColor,
          onChangeBackgroundColor: changeBackgroundColor,
          onChangeTextColor: changeTextColor,
        );
      },
    );
  }
}

class _NormalTrapColorCard extends StatelessWidget {
  const _NormalTrapColorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrapAlarmColorBloc, TrapAlarmColorState>(
      builder: (context, state) {
        void changeBackgroundColor() async {
          int? pickedColor = await _showColorPickerDialog(
            context: context,
            currentColor: state.normalBackgroundColor,
          );

          if (pickedColor != null) {
            context
                .read<TrapAlarmColorBloc>()
                .add(NormalBackgroundColorChanged(pickedColor));
          }
        }

        void changeTextColor() async {
          int? pickedColor = await _showColorPickerDialog(
            context: context,
            currentColor: state.normalTextColor,
          );

          if (pickedColor != null) {
            context
                .read<TrapAlarmColorBloc>()
                .add(NormalTextColorChanged(pickedColor));
          }
        }

        return _buildContent(
          context: context,
          isEditing: state.isEditing,
          trapAlarmTitle: AppLocalizations.of(context)!.normal,
          trapAlarmBackgroundColor: state.normalBackgroundColor,
          trapAlarmTextColor: state.normalTextColor,
          onChangeBackgroundColor: changeBackgroundColor,
          onChangeTextColor: changeTextColor,
        );
      },
    );
  }
}

class _NoticeTrapColorCard extends StatelessWidget {
  const _NoticeTrapColorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrapAlarmColorBloc, TrapAlarmColorState>(
      builder: (context, state) {
        void changeBackgroundColor() async {
          int? pickedColor = await _showColorPickerDialog(
            context: context,
            currentColor: state.noticeBackgroundColor,
          );

          if (pickedColor != null) {
            context
                .read<TrapAlarmColorBloc>()
                .add(NoticeBackgroundColorChanged(pickedColor));
          }
        }

        void changeTextColor() async {
          int? pickedColor = await _showColorPickerDialog(
            context: context,
            currentColor: state.noticeTextColor,
          );

          if (pickedColor != null) {
            context
                .read<TrapAlarmColorBloc>()
                .add(NoticeTextColorChanged(pickedColor));
          }
        }

        return _buildContent(
          context: context,
          isEditing: state.isEditing,
          trapAlarmTitle: AppLocalizations.of(context)!.notice,
          trapAlarmBackgroundColor: state.noticeBackgroundColor,
          trapAlarmTextColor: state.noticeTextColor,
          onChangeBackgroundColor: changeBackgroundColor,
          onChangeTextColor: changeTextColor,
        );
      },
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool?> _showConfirmResetDialog() async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!
                .dialogMessage_resetToRICOMSDefault),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .dialogMessage_resetToRICOMSDefault,
                          style: const TextStyle(
                            fontSize: CommonStyle.sizeXL,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.yes,
                  style: const TextStyle(
                    color: CustomStyle.customRed,
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

    return BlocBuilder<TrapAlarmColorBloc, TrapAlarmColorState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
              left: 12.0, right: 12.0, top: 6.0, bottom: 0.0),
          child: Card(
            child: ListTile(
              //dense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              trailing: const Image(
                image: AssetImage('assets/menu_logo.png'),
                width: 24.0,
                height: 24.0,
              ),
              title: Text(
                AppLocalizations.of(context)!.resetToDefaultSettings,
                style: const TextStyle(fontSize: CommonStyle.sizeL),
              ),
              onTap: state.isEditing
                  ? () async {
                      bool? result = await _showConfirmResetDialog();
                      if (result != null) {
                        result
                            ? context
                                .read<TrapAlarmColorBloc>()
                                .add(const TrapAlarmColorReseted())
                            : null;
                      }
                    }
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _ColorEditFloatingActionButton extends StatelessWidget {
  const _ColorEditFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrapAlarmColorBloc, TrapAlarmColorState>(
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
                          .read<TrapAlarmColorBloc>()
                          .add(const TrapAlarmColorSaved());
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
                            .read<TrapAlarmColorBloc>()
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
                      .read<TrapAlarmColorBloc>()
                      .add(const EditModeEnabled());
                },
                child: const Icon(Icons.edit),
              );
      },
    );
  }
}
