import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/advanced/bloc/batch_setting/select_module/select_module_bloc.dart';
import 'package:ricoms_app/advanced/view/batch_setting_view/select_device_page.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/repository/module.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class SelectModuleForm extends StatelessWidget {
  const SelectModuleForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectModuleBloc, SelectModuleState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.batchSetting,
          ),
          elevation: 0.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _KeywordInput(),
            const Expanded(
              child: _ModuleListView(),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeywordInput extends StatelessWidget {
  _KeywordInput({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectModuleBloc, SelectModuleState>(
        buildWhen: (previous, current) => previous.keyword != current.keyword,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _controller,
              textInputAction: TextInputAction.done,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (String? keyword) {
                if (keyword != null) {
                  context
                      .read<SelectModuleBloc>()
                      .add(KeywordSearched(keyword));
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(6),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0),
                ),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                labelText: AppLocalizations.of(context)!.searchHint,
                labelStyle: const TextStyle(
                  fontSize: CommonStyle.sizeL,
                ),
                floatingLabelStyle: const TextStyle(
                  color: Colors.black,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                suffixIconConstraints: state.keyword.isNotEmpty
                    ? const BoxConstraints(
                        maxHeight: 34,
                        maxWidth: 34,
                        minHeight: 34,
                        minWidth: 34)
                    : null,
                suffixIcon: state.keyword.isNotEmpty
                    ? Material(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(4.0),
                          bottomRight: Radius.circular(4.0),
                        ),
                        color: Colors.grey,
                        child: IconButton(
                          color: Colors.white,
                          splashColor: Colors.blue.shade100,
                          icon: const Icon(
                            CustomIcons.cancel,
                          ),
                          onPressed: () {
                            _controller.clear();
                            context
                                .read<SelectModuleBloc>()
                                .add(const KeywordCleared());
                          },
                        ),
                      )
                    : null,
              ),
            ),
          );
        });
  }
}

class _ModuleListView extends StatelessWidget {
  const _ModuleListView({Key? key}) : super(key: key);

  SliverChildBuilderDelegate _moduleSliverChildBuilderDelegate({
    required List<Module> data,
  }) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        Module module = data[index];
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Material(
            color: index.isEven ? Colors.grey.shade100 : Colors.white,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context, SelectDevicePage.route(moduleId: module.id));
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 6.0, 10.0),
                            child: Text(
                              module.name,
                              //maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: CommonStyle.sizeXL,
                                // fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_right_outlined)
                  ],
                ),
              ),
            ),
          ),
        );
      },
      childCount: data.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectModuleBloc, SelectModuleState>(
      builder: (context, state) {
        if (state.status.isRequestSuccess) {
          return Container(
            color: Colors.grey.shade300,
            child: Scrollbar(
              thickness: 8.0,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: _moduleSliverChildBuilderDelegate(
                    data: state.modules,
                  )),
                ],
              ),
            ),
          );
        } else if (state.status.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
            width: double.maxFinite,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_rounded,
                  size: 200,
                  color: Color(0xffffc107),
                ),
                Text(
                  getMessageLocalization(
                    msg: state.requestErrorMsg,
                    context: context,
                  ),
                ),
                const SizedBox(height: 40.0),
              ],
            ),
          );
        }
      },
    );
  }
}
