import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/configuration/configuration_bloc.dart';
import 'package:ricoms_app/root/view/custom_style.dart';

class ConfigurationForm extends StatefulWidget {
  ConfigurationForm({Key? key, required this.rootRepository}) : super(key: key);

  final RootRepository rootRepository;
  final Map<String, bool> checkBoxValues = <String, bool>{};
  final Map<String, TextEditingController> textFieldControllers =
      <String, TextEditingController>{};

  final Map<String, String> radioButtonValues = <String, String>{};

  late bool isEditing = false;

  @override
  State<ConfigurationForm> createState() => _ConfigurationFormState();
}

class _ConfigurationFormState extends State<ConfigurationForm>
    with AutomaticKeepAliveClientMixin {
  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Setup completed!'),
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
    print('build Threshold');

    return BlocProvider(
      create: (context) =>
          ConfigurationBloc(rootRepository: widget.rootRepository)
            ..add(ConfigurationDataRequested()),
      child: BlocBuilder<ConfigurationBloc, ConfigurationState>(
        builder: (BuildContext context, state) {
          if (state.status.isSubmissionInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status.isSubmissionSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.isEditing
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: ElevatedButton(
                                onPressed: () => setState(() {
                                  widget.isEditing = false;
                                }),
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
                                  Map<String, String> data = <String, String>{};

                                  widget.checkBoxValues.forEach((key, value) {
                                    data[key] = value ? '1' : '0';
                                  });

                                  widget.textFieldControllers
                                      .forEach((key, value) {
                                    data[key] = value.text;
                                  });

                                  data.forEach((key, value) {
                                    print('${key} : ${value}');
                                  });

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
                                  widget.textFieldControllers
                                      .forEach((key, value) {
                                    print('${key} : ${value.text}');
                                  });
                                  widget.radioButtonValues
                                      .forEach((key, value) {
                                    print('${key} : ${value.toString()}');
                                  });
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
                                onPressed: () => setState(() {
                                  widget.isEditing = true;
                                }),
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
                        ),
                  for (var item in state.data) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var e in item) ...[
                          CustomStyle.getBox(e['style'], e,
                              isEditing: widget.isEditing,
                              checkBoxValues: widget.checkBoxValues,
                              textFieldControllers: widget.textFieldControllers,
                              radioButtonValues: widget.radioButtonValues),
                        ]
                      ],
                    )
                  ],
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
