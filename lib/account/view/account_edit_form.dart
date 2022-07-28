import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/account/bloc/edit_account/edit_account_bloc.dart';
import 'package:ricoms_app/utils/common_style.dart';

class AccountEditForm extends StatelessWidget {
  const AccountEditForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditAccountBloc, EditAccountState>(
      listener: (context, state) {},
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}

class _PermissionDropDownMenu extends StatelessWidget {
  const _PermissionDropDownMenu({Key? key}) : super(key: key);

  final Map<String, int> types = const {
    'Operator': 3,
    'Administrator': 2,
    'User': 4,
    'Disabled': 5,
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
        buildWhen: (previous, current) =>
            previous.permission != current.permission,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(CommonStyle.lineSpacing),
            child: DropdownButtonFormField2(
                alignment: AlignmentDirectional.centerEnd,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.all(5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                //isDense: true,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                value: state.permission,
                items: [
                  for (String k in types.keys)
                    DropdownMenuItem(
                      alignment: AlignmentDirectional.center,
                      value: types[k],
                      child: Text(
                        k,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: CommonStyle.sizeM,
                          color: Colors.black,
                        ),
                      ),
                    )
                ],
                onChanged: (int? value) {
                  if (value != null) {
                    context
                        .read<EditAccountBloc>()
                        .add(PermissionChanged(value));
                  }
                }),
          );
        });
  }
}
