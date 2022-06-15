import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ricoms_app/root/bloc/edit_device/edit_device_bloc.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';

class DeviceEditForm extends StatelessWidget {
  const DeviceEditForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showInProgressDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Connecting to the device...'),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              CircularProgressIndicator(),
            ],
          );
        },
      );
    }

    Future<void> _showSuccessDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Created',
              style: TextStyle(color: CustomStyle.severityColor[1]),
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

    Future<void> _showFailureDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error',
                style: TextStyle(color: CustomStyle.severityColor[3])),
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

    TextEditingController _nameController = TextEditingController();
    TextEditingController _deviceIPController = TextEditingController();
    TextEditingController _readController = TextEditingController();
    TextEditingController _writeController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();
    TextEditingController _locationController = TextEditingController();

    return BlocListener<EditDeviceBloc, EditDeviceState>(
      listener: ((context, state) async {
        if (state.status.isSubmissionInProgress) {
          await _showInProgressDialog();
        } else if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
          _showSuccessDialog(state.msg);
        } else if (state.status.isSubmissionFailure) {
          Navigator.of(context).pop();
          _showFailureDialog(state.msg);
        } else if (state.isInitController) {
          if (state.isEditing) {
            _nameController.text = state.name.value;
            _deviceIPController.text = state.deviceIP.value;
            _readController.text = state.read;
            _writeController.text = state.write;
            _descriptionController.text = state.description;
            _locationController.text = state.location;
          } else {
            _readController.text = state.read;
            _writeController.text = state.write;
          }
        }
      }),
      child: Align(
        alignment: const Alignment(0, -0.42),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 230,
              //padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: _ParentName(),
            ),
            const Padding(padding: EdgeInsets.all(6)),

            SizedBox(
              width: 230,
              //padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: _NameInput(
                nameController: _nameController,
              ),
            ),

            const Padding(padding: EdgeInsets.all(6)),
            SizedBox(
              width: 230,
              //padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: _DeviceIPInput(
                deviceIPController: _deviceIPController,
              ),
            ),

            const Padding(padding: EdgeInsets.all(6)),

            SizedBox(
              width: 230,
              //padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: _ReadInput(
                readController: _readController,
              ),
            ),

            const Padding(padding: EdgeInsets.all(6)),

            SizedBox(
              width: 230,
              //padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: _WriteInput(
                writeController: _writeController,
              ),
            ),

            const Padding(padding: EdgeInsets.all(6)),

            SizedBox(
              width: 230,
              //padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: _DescriptionInput(
                descriptionController: _descriptionController,
              ),
            ),

            const Padding(padding: EdgeInsets.all(6)),

            SizedBox(
              width: 230,
              //padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: _LocationInput(
                locationController: _locationController,
              ),
            ),

            const Padding(padding: EdgeInsets.all(6)),

            _SaveButton(),
            //const Padding(padding: EdgeInsets.all(50)),
          ],
        ),
      ),
    );
  }
}

class _ParentName extends StatelessWidget {
  const _ParentName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDeviceBloc, EditDeviceState>(
        buildWhen: (previous, current) =>
            previous.parentName != current.parentName,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Parent'),
              Text(
                state.parentName,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          );
        });
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({Key? key, required this.nameController}) : super(key: key);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDeviceBloc, EditDeviceState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextFormField(
          key: const Key('deviceEditForm_nameInput_textField'),
          // initialValue: state.isEditing && state.currentNode!.info != null
          //     ? state.currentNode!.name
          //     : null,
          controller: nameController,
          textInputAction: TextInputAction.done,
          style: const TextStyle(
            fontSize: CommonStyle.sizeL,
          ),
          onChanged: (name) {
            print(name);
            context.read<EditDeviceBloc>().add(NameChanged(name));
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border: const OutlineInputBorder(),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            hintText: 'Name',
            hintStyle: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            errorMaxLines: 2,
            errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
            errorText: state.name.invalid
                ? 'The name must be between 1-64 characters long.'
                : null,
          ),
        );
      },
    );
  }
}

class _DeviceIPInput extends StatelessWidget {
  const _DeviceIPInput({Key? key, required this.deviceIPController})
      : super(key: key);

  final TextEditingController deviceIPController;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDeviceBloc, EditDeviceState>(
      buildWhen: (previous, current) => previous.deviceIP != current.deviceIP,
      builder: (context, state) {
        return TextFormField(
          key: const Key('deviceEditForm_deviceIPInput_textField'),
          // initialValue: state.isEditing && state.currentNode!.info != null
          //     ? state.currentNode!.info!.ip
          //     : null,
          controller: deviceIPController,
          textInputAction: TextInputAction.done,
          style: const TextStyle(
            fontSize: CommonStyle.sizeL,
          ),
          onChanged: (deviceIP) =>
              context.read<EditDeviceBloc>().add(DeviceIPChanged(deviceIP)),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border: const OutlineInputBorder(),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            hintText: 'IP',
            hintStyle: const TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
            errorMaxLines: 2,
            errorStyle: const TextStyle(fontSize: CommonStyle.sizeS),
            errorText: state.deviceIP.invalid ? 'Invalid IP address.' : null,
          ),
        );
      },
    );
  }
}

class _ReadInput extends StatelessWidget {
  const _ReadInput({Key? key, required this.readController}) : super(key: key);

  final TextEditingController readController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDeviceBloc, EditDeviceState>(
      buildWhen: (previous, current) => previous.read != current.read,
      builder: (context, state) {
        return TextFormField(
          key: const Key('deviceEditForm_readPInput_textField'),
          // initialValue: state.isEditing && state.currentNode!.info != null
          //     ? state.currentNode!.info!.read
          //     : state.read,
          controller: readController,
          textInputAction: TextInputAction.done,
          style: const TextStyle(
            fontSize: CommonStyle.sizeL,
          ),
          onChanged: (read) =>
              context.read<EditDeviceBloc>().add(ReadChanged(read)),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            labelText: 'Read',
            labelStyle: TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
          ),
        );
      },
    );
  }
}

class _WriteInput extends StatelessWidget {
  const _WriteInput({Key? key, required this.writeController})
      : super(key: key);

  final TextEditingController writeController;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDeviceBloc, EditDeviceState>(
      buildWhen: (previous, current) => previous.write != current.write,
      builder: (context, state) {
        return TextFormField(
          key: const Key('deviceEditForm_writePInput_textField'),
          // initialValue: state.isEditing && state.currentNode!.info != null
          //     ? state.currentNode!.info!.write
          //     : state.write,
          controller: writeController,
          textInputAction: TextInputAction.done,
          style: const TextStyle(
            fontSize: CommonStyle.sizeL,
          ),
          onChanged: (write) =>
              context.read<EditDeviceBloc>().add(WriteChanged(write)),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            labelText: 'Write',
            labelStyle: TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
          ),
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput({Key? key, required this.descriptionController})
      : super(key: key);

  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDeviceBloc, EditDeviceState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return TextFormField(
          key: const Key('deviceEditForm_descriptionInput_textField'),
          // initialValue: state.isEditing && state.currentNode!.info != null
          //     ? state.currentNode!.info!.description
          //     : state.description,
          controller: descriptionController,
          textInputAction: TextInputAction.done,
          style: const TextStyle(
            fontSize: CommonStyle.sizeL,
          ),
          onChanged: (description) => context
              .read<EditDeviceBloc>()
              .add(DescriptionChanged(description)),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            hintText: 'Description',
            hintStyle: TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
          ),
        );
      },
    );
  }
}

class _LocationInput extends StatelessWidget {
  const _LocationInput({Key? key, required this.locationController})
      : super(key: key);

  final TextEditingController locationController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDeviceBloc, EditDeviceState>(
      buildWhen: (previous, current) => previous.location != current.location,
      builder: (context, state) {
        return TextFormField(
          key: const Key('deviceEditForm_locationInput_textField'),
          controller: locationController,
          textInputAction: TextInputAction.done,
          style: const TextStyle(
            fontSize: CommonStyle.sizeL,
          ),
          onChanged: (location) =>
              context.read<EditDeviceBloc>().add(LocationChanged(location)),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            hintText: 'Location',
            hintStyle: TextStyle(
              fontSize: CommonStyle.sizeL,
            ),
          ),
        );
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDeviceBloc, EditDeviceState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.blue;
                } else if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return null; // Use the component's default.
              },
            ),
          ),
          key: const Key('changePasswordForm_save_raisedButton'),
          child: const Text(
            'Create',
            style: TextStyle(
              fontSize: CommonStyle.sizeM,
            ),
          ),
          onPressed: state.status.isValidated
              ? () {
                  context.read<EditDeviceBloc>().add(const FormSubmitted());
                }
              : null,
        );
      },
    );
  }
}
