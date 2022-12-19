import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/advanced/bloc/trap_alarm_color/trap_alarm_color_bloc.dart';
import 'package:ricoms_app/utils/common_style.dart';

class TrapAlarmColorForm extends StatelessWidget {
  const TrapAlarmColorForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              CriticalTrapColorCard(),
              WarningTrapColorCard(),
              NormalTrapColorCard(),
              NoticeTrapColorCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// int _getColorFromHex(String hexColor) {
//   hexColor = hexColor.replaceAll("#", "");
//   if (hexColor.length == 6) {
//     hexColor = "FF" + hexColor;
//     return int.parse("0x$hexColor");
//   }
//   if (hexColor.length == 8) {
//     return int.parse("0x$hexColor");
//   } else {
//     return 0xff000000;
//   }
// }

Future<int?> _showColorPickerDialog({
  required BuildContext context,
}) async {
  Color _pickerColor = Color(0xff443a49);
  return showDialog<int?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _pickerColor,
            onColorChanged: (Color color) {
              _pickerColor = color;
            },
          ),
          // Use Material color picker:
          //
          // child: MaterialPicker(
          //   pickerColor: pickerColor,
          //   onColorChanged: changeColor,
          //   showLabel: true, // only on portrait mode
          // ),
          //
          // Use Block color picker:
          //
          // child: BlockPicker(
          //   pickerColor: currentColor,
          //   onColorChanged: changeColor,
          // ),
          //
          // child: MultipleChoiceBlockPicker(
          //   pickerColors: currentColors,
          //   onColorsChanged: changeColors,
          // ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              // String hexStringColor = _pickerColor.value.toRadixString(16);
              // int hexColor = _getColorFromHex(hexStringColor);
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
  required String trapAlarmTitle,
  required int trapAlarmBackgroundColor,
  required int trapAlarmTextColor,
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
                  onPressed: () async {
                    int? pickedColor =
                        await _showColorPickerDialog(context: context);

                    if (pickedColor != null) {
                      context
                          .read<TrapAlarmColorBloc>()
                          .add(CriticalBackgroundColorChanged(pickedColor));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: Color(trapAlarmBackgroundColor),
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: Color(trapAlarmTextColor),
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

class CriticalTrapColorCard extends StatelessWidget {
  const CriticalTrapColorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrapAlarmColorBloc, TrapAlarmColorState>(
      builder: (context, state) {
        return _buildContent(
          context: context,
          trapAlarmTitle: AppLocalizations.of(context)!.critical,
          trapAlarmBackgroundColor: state.criticalBackgroundColor,
          trapAlarmTextColor: state.criticalTextColor,
        );
      },
    );
  }
}

class WarningTrapColorCard extends StatelessWidget {
  const WarningTrapColorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrapAlarmColorBloc, TrapAlarmColorState>(
      builder: (context, state) {
        return _buildContent(
          context: context,
          trapAlarmTitle: AppLocalizations.of(context)!.warning,
          trapAlarmBackgroundColor: state.warningBackgroundColor,
          trapAlarmTextColor: state.warningTextColor,
        );
      },
    );
  }
}

class NormalTrapColorCard extends StatelessWidget {
  const NormalTrapColorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrapAlarmColorBloc, TrapAlarmColorState>(
      builder: (context, state) {
        return _buildContent(
          context: context,
          trapAlarmTitle: AppLocalizations.of(context)!.normal,
          trapAlarmBackgroundColor: state.normalBackgroundColor,
          trapAlarmTextColor: state.normalTextColor,
        );
      },
    );
  }
}

class NoticeTrapColorCard extends StatelessWidget {
  const NoticeTrapColorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrapAlarmColorBloc, TrapAlarmColorState>(
      builder: (context, state) {
        return _buildContent(
          context: context,
          trapAlarmTitle: AppLocalizations.of(context)!.notice,
          trapAlarmBackgroundColor: state.noticeBackgroundColor,
          trapAlarmTextColor: state.noticeTextColor,
        );
      },
    );
  }
}

class TrapColorCard extends StatelessWidget {
  const TrapColorCard({
    Key? key,
    required this.trapAlarmTitle,
  }) : super(key: key);

  final String trapAlarmTitle;
  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      backgroundColor: Colors.red,
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      backgroundColor: Colors.red,
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
                      elevation: 0.0,
                      backgroundColor: Colors.red,
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(width: 1.0, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(1.0))),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: null,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
