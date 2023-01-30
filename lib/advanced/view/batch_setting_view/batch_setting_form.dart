import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/advanced/bloc/batch_setting/batch_setting_bloc.dart';
import 'package:ricoms_app/repository/module.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class BatchSettingForm extends StatelessWidget {
  const BatchSettingForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<BatchSettingBloc, BatchSettingState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(
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
    return BlocBuilder<BatchSettingBloc, BatchSettingState>(
        buildWhen: (previous, current) => previous.keyword != current.keyword,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (String? keyword) {
                if (keyword != null) {
                  context.read<BatchSettingBloc>().add(KeywordChanged(keyword));
                }
              },
              onFieldSubmitted: (String? keyword) {
                // context.read<SearchBloc>().add(CriteriaSaved(context));
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
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
                suffixIconConstraints: const BoxConstraints(
                    maxHeight: 36, maxWidth: 36, minHeight: 36, minWidth: 36),
                suffixIcon: Material(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4.0),
                    bottomRight: Radius.circular(4.0),
                  ),
                  color: Colors.grey,
                  child: IconButton(
                    color: Colors.white,
                    splashColor: Colors.blue.shade100,
                    iconSize: 22,
                    icon: const Icon(
                      Icons.search_outlined,
                    ),
                    onPressed: () {
                      // context.read<SearchBloc>().add(CriteriaSaved(context));
                      // context.read<SearchBloc>().add(const FilterAdded());
                      // _controller.clear();
                    },
                  ),
                ),
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
              onTap: () {},
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
    return BlocBuilder<BatchSettingBloc, BatchSettingState>(
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
          return Center(
            child: Text(getMessageLocalization(
              msg: state.requestErrorMsg,
              context: context,
            )),
          );
        }
      },
    );
  }
}
