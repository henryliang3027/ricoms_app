import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';
import 'package:ricoms_app/repository/root_repository.dart';
import 'package:ricoms_app/root/bloc/search/search_bloc.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/utils/message_localization.dart';

class SearchForm extends StatelessWidget {
  const SearchForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.search,
        ),
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.all(CommonStyle.lineSpacing),
          ),
          _TypeDropDownMenu(),
          _KeywordInput(),
          _DeviceListView(),
        ],
      ),
    );
  }
}

class _TypeDropDownMenu extends StatelessWidget {
  const _TypeDropDownMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, int> types = {
      AppLocalizations.of(context)!.name: 1,
      AppLocalizations.of(context)!.description: 2,
      AppLocalizations.of(context)!.ip: 3,
      AppLocalizations.of(context)!.location: 4,
    };

    return BlocBuilder<SearchBloc, SearchState>(
        buildWhen: (previous, current) => previous.type != current.type,
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
                value: state.type,
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
                    context.read<SearchBloc>().add(SearchTypeChanged(value));
                  }
                }),
          );
        });
  }
}

class _KeywordInput extends StatelessWidget {
  const _KeywordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
        buildWhen: (previous, current) => previous.keyword != current.keyword,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(CommonStyle.lineSpacing),
            child: SizedBox(
              child: TextFormField(
                textInputAction: TextInputAction.done,
                style: const TextStyle(
                  fontSize: CommonStyle.sizeL,
                ),
                onChanged: (String? keyword) {
                  if (keyword != null) {
                    context.read<SearchBloc>().add(KeywordChanged(keyword));
                  }
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
                  suffixIconConstraints: const BoxConstraints(
                      maxHeight: 36, maxWidth: 36, minHeight: 36, minWidth: 36),
                  suffixIcon: Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                      splashColor: Colors.blue.shade100,
                      iconSize: 22,
                      //padding: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
                      icon: const Icon(
                        Icons.search_outlined,
                      ),
                      onPressed: () {
                        context
                            .read<SearchBloc>()
                            .add(const SearchDataSubmitted());
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _DeviceListView extends StatelessWidget {
  const _DeviceListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _getDisplayName(SearchData searchData) {
      if (searchData.type == 5) {
        //a8k slot
        if (searchData.shelf == 0 && searchData.slot == 1) {
          return Text(
              '${searchData.name} [ ${searchData.deviceName} / PCM2 (L) ]');
        } else {
          return Text(
              '${searchData.name} [ ${searchData.deviceName} / Shelf ${searchData.shelf} / Slot ${searchData.slot} ]');
        }
      } else {
        return Text(
          searchData.name,
        );
      }
    }

    _deviceSliverChildBuilderDelegate(List data) {
      return SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (kDebugMode) {
            print('build _deviceSliverChildBuilderDelegate : $index');
          }
          SearchData searchData = data[index];
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: Material(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context, searchData.path);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(CustomIcons.device),
                          )
                        ],
                      ),
                      Flexible(
                        child: _getDisplayName(searchData),
                      ),
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

    return BlocBuilder<SearchBloc, SearchState>(
        buildWhen: (previous, current) =>
            previous.searchResult != current.searchResult,
        builder: (context, state) {
          if (state.status.isSubmissionInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (kDebugMode) {
              print('state.searchResult.runtimeType ' +
                  state.searchResult.runtimeType.toString());
            }
            return state.searchResult.runtimeType == List
                ? Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                            delegate: _deviceSliverChildBuilderDelegate(
                                state.searchResult))
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      getMessageLocalization(
                        msg: state.searchResult,
                        context: context,
                      ),
                    ),
                  );
          }
        });
  }
}
