import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/repository/device_repository.dart';
import 'package:ricoms_app/root/bloc/device/device_bloc.dart';
import 'package:ricoms_app/root/view/custom_style.dart';

class DeviceSettingForm extends StatefulWidget {
  DeviceSettingForm(
      {Key? key, required this.deviceRepository, required this.pageName})
      : super(key: key);

  final DeviceRepository deviceRepository;
  final String pageName;
  final Map<String, bool> checkBoxValues = <String, bool>{};
  final Map<String, TextEditingController> textFieldControllers =
      <String, TextEditingController>{};
  final Map<String, String> radioButtonValues = <String, String>{};
  final Map<String, String> sliderValues = <String, String>{};
  final Map<String, String> dropDownMenuValues = <String, String>{};
  final Map<String, String> controllerInitValues = <String, String>{};

  late bool isEditing = false;

  @override
  State<DeviceSettingForm> createState() => _DeviceSettingFormState();
}

class _DeviceSettingFormState extends State<DeviceSettingForm>
    with AutomaticKeepAliveClientMixin {
  Future<void> _showInProgressDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Setting up...'),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            CircularProgressIndicator(),
          ],
        );
      },
    );
  }

  Future<void> _showCompleteDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg),
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

  @override
  Widget build(BuildContext context) {
    print('build ${widget.pageName}');

    return BlocProvider(
      create: (context) => DeviceBloc(
          deviceRepository: widget.deviceRepository, pageName: widget.pageName),
      child: BlocListener<DeviceBloc, DeviceState>(
        listener: (context, state) async {
          if (state.submissionStatus.isSubmissionInProgress) {
            // ScaffoldMessenger.of(context)
            //   ..hideCurrentSnackBar()
            //   ..showSnackBar(
            //     const SnackBar(content: Text('Update, Please login again')),
            //   );
            await _showInProgressDialog();
          } else if (state.submissionStatus.isSubmissionFailure ||
              state.submissionStatus.isSubmissionSuccess) {
            Navigator.of(context).pop();
            _showCompleteDialog(state.saveResultMsg);
            context.read<DeviceBloc>().add(const DeviceDataRequested());
          }
        },
        child: BlocBuilder<DeviceBloc, DeviceState>(
          builder: (BuildContext context, state) {
            print('trigger');
            if (state.formStatus.isRequestInProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.formStatus.isRequestSuccess ||
                state.formStatus.isUpdating) {
              // fetch new values and reset the values in all controllers and init value map
              // ex: set the value from 1 to 2
              // if you don't update init value map, the value is still 1
              // when you set to 1 again, the value will be consider as not change and will not be write to the device
              if (state.formStatus.isUpdating) {
                widget.controllerInitValues.clear();
                widget.sliderValues.clear();
                widget.textFieldControllers.clear();
                widget.radioButtonValues.clear();
                widget.checkBoxValues.clear();
                widget.dropDownMenuValues.clear();
              }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    state.editable
                        ? SizedBox(
                            height: 40.0,
                            child: CreateEditingTool(
                              isEditing: state.isEditing,
                              pageName: widget.pageName,
                              checkBoxValues: widget.checkBoxValues,
                              textFieldControllers: widget.textFieldControllers,
                              radioButtonValues: widget.radioButtonValues,
                              sliderValues: widget.sliderValues,
                              dropDownMenuValues: widget.dropDownMenuValues,
                              controllerInitValues: widget.controllerInitValues,
                            ))
                        : const SizedBox(
                            height: 40.0,
                          ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (var item in state.data) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (var e in item) ...[
                                    CustomStyle.getBox(
                                      e['style'],
                                      e,
                                      isEditing: state.isEditing,
                                      checkBoxValues: widget.checkBoxValues,
                                      textFieldControllers:
                                          widget.textFieldControllers,
                                      radioButtonValues:
                                          widget.radioButtonValues,
                                      sliderValues: widget.sliderValues,
                                      dropDownMenuValues:
                                          widget.dropDownMenuValues,
                                      controllerInitValues:
                                          widget.controllerInitValues,
                                    ),
                                  ]
                                ],
                              )
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              //FormStatus.requestFailure
              String errnsg = state.data[0];
              return Center(
                child: Text(errnsg),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  bool get wantKeepAlive => false;
}

class CreateEditingTool extends StatelessWidget {
  const CreateEditingTool({
    Key? key,
    required this.isEditing,
    required this.pageName,
    required this.checkBoxValues,
    required this.textFieldControllers,
    required this.radioButtonValues,
    required this.sliderValues,
    required this.dropDownMenuValues,
    required this.controllerInitValues,
  }) : super(key: key);

  final bool isEditing;
  final String pageName;
  final Map<String, bool> checkBoxValues;
  final Map<String, TextEditingController> textFieldControllers;
  final Map<String, String> radioButtonValues;
  final Map<String, String> sliderValues;
  final Map<String, String> dropDownMenuValues;
  final Map<String, String> controllerInitValues;

  @override
  Widget build(BuildContext context) {
    return isEditing
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<DeviceBloc>()
                        .add(const FormStatusChanged(false));
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white70,
                    elevation: 0,
                    side: const BorderSide(
                      width: 1.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: ElevatedButton(
                  onPressed: () {
                    List<Map<String, String>> dataList = [];

                    if (checkBoxValues.isNotEmpty) {
                      checkBoxValues.forEach((key, value) {
                        String _binValue = value ? '1' : '0';
                        if (controllerInitValues[key] != _binValue) {
                          dataList.add({'oid_id': key, 'value': _binValue});
                        }
                      });
                    }

                    if (textFieldControllers.isNotEmpty) {
                      if (pageName == 'Description') {
                        String nameId = '9998';
                        String descriptionId = '9999';
                        dataList.add({
                          'oid_id': nameId,
                          'value': textFieldControllers[nameId]!.text
                        });
                        dataList.add({
                          'oid_id': descriptionId,
                          'value': textFieldControllers[descriptionId]!.text
                        });
                      } else {
                        textFieldControllers.forEach((key, value) {
                          if (controllerInitValues[key] != value.text) {
                            dataList.add({'oid_id': key, 'value': value.text});
                          }
                        });
                      }
                    }

                    if (radioButtonValues.isNotEmpty) {
                      radioButtonValues.forEach((key, value) {
                        if (controllerInitValues[key] != value) {
                          dataList.add({'oid_id': key, 'value': value});
                        }
                      });
                    }

                    if (sliderValues.isNotEmpty) {
                      sliderValues.forEach((key, value) {
                        if (controllerInitValues[key] != value) {
                          dataList
                              .add({'oid_id': key, 'value': value.toString()});
                        }
                      });
                    }

                    if (dropDownMenuValues.isNotEmpty) {
                      dropDownMenuValues.forEach((key, value) {
                        if (controllerInitValues[key] != value) {
                          dataList.add({'oid_id': key, 'value': value});
                        }
                      });
                    }

                    print('--------------');
                    dataList.forEach((element) {
                      element
                          .forEach((key, value) => print('${key} : ${value}'));
                    });
                    print('--------------');
                    context.read<DeviceBloc>().add(DeviceParamSaved(dataList));

                    //widget.isEditing = false;
                    //_showSuccessDialog();},
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<DeviceBloc>()
                        .add(const FormStatusChanged(true));
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white70,
                    elevation: 0,
                    side: const BorderSide(
                      width: 1.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
