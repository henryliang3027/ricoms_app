import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/root/bloc/device/form_status.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/device/device_bloc.dart';
import 'package:ricoms_app/root/view/custom_style.dart';

class DeviceSettingForm extends StatefulWidget {
  DeviceSettingForm(
      {Key? key, required this.rootRepository, required this.pageName})
      : super(key: key);

  final RootRepository rootRepository;
  final String pageName;
  final Map<String, bool> checkBoxValues = <String, bool>{};
  final Map<String, TextEditingController> textFieldControllers =
      <String, TextEditingController>{};
  final Map<String, String> radioButtonValues = <String, String>{};
  final Map<String, double> sliderValues = <String, double>{};
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
          title: Text('Setting UP...'),
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
      create: (context) => DeviceBloc(rootRepository: widget.rootRepository)
        ..add(DeviceDataRequested(widget.pageName)),
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

            // fetch new values and reset the values in all controllers and init value map
            // ex: set the value from 1 to 2
            // if you don't update init value map, the value is still 1
            // when you set to 1 again, the value will be consider as not change and will not be write to the device
            widget.controllerInitValues.clear();
            widget.sliderValues.clear();
            widget.textFieldControllers.clear();
            widget.radioButtonValues.clear();
            widget.checkBoxValues.clear();
            context
                .read<DeviceBloc>()
                .add(DeviceDataRequested(widget.pageName));
          }
        },
        child: BlocBuilder<DeviceBloc, DeviceState>(
          builder: (BuildContext context, state) {
            if (state.formStatus.isRequestInProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.formStatus.isRequestSuccess) {
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
                              checkBoxValues: widget.checkBoxValues,
                              textFieldControllers: widget.textFieldControllers,
                              radioButtonValues: widget.radioButtonValues,
                              sliderValues: widget.sliderValues,
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
    required this.checkBoxValues,
    required this.textFieldControllers,
    required this.radioButtonValues,
    required this.sliderValues,
    required this.controllerInitValues,
  }) : super(key: key);

  final bool isEditing;

  final Map<String, bool> checkBoxValues;
  final Map<String, TextEditingController> textFieldControllers;
  final Map<String, String> radioButtonValues;
  final Map<String, double> sliderValues;
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
                        if (controllerInitValues[key] != value) {
                          dataList
                              .add({'oid_id': key, 'value': value ? '1' : '0'});
                        }
                      });
                    }

                    if (textFieldControllers.isNotEmpty) {
                      textFieldControllers.forEach((key, value) {
                        if (controllerInitValues[key] != value) {
                          dataList.add({'oid_id': key, 'value': value.text});
                        }
                      });
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
                        if (controllerInitValues[key] != value.toString()) {
                          dataList
                              .add({'oid_id': key, 'value': value.toString()});
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
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: ElevatedButton(
                  onPressed: () {
                    // textFieldControllers
                    //     .forEach((key, value) {
                    //   print('${key} : ${value.text}');
                    // });
                    // radioButtonValues
                    //     .forEach((key, value) {
                    //   print('${key} : ${value.toString()}');
                    // });
                  },
                  child: const Text('show data'),
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
