import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricoms_app/account/bloc/account/account_bloc.dart';
import 'package:ricoms_app/account/view/account_edit_page.dart';
import 'package:ricoms_app/repository/account_outline.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/utils/common_style.dart';

class AccountForm extends StatelessWidget {
  const AccountForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: _KeywordInput(),
            ),
            Expanded(
              child: _AccountSliverList(),
            ),
          ],
        ),
      ),
      floatingActionButton: const _AccountFloatingActionButton(),
    );
  }
}

class _AccountFloatingActionButton extends StatelessWidget {
  const _AccountFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        return FloatingActionButton(
          elevation: 0.0,
          backgroundColor: const Color(0x742195F3),
          onPressed: () {
            Navigator.push(context, AccountEditPage.route(isEditing: false));
          },
          child: const Icon(Icons.add),
        );
      },
    );
  }
}

class _KeywordInput extends StatelessWidget {
  const _KeywordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
        buildWhen: (previous, current) => previous.keyword != current.keyword,
        builder: (context, state) {
          return SizedBox(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontSize: CommonStyle.sizeL,
              ),
              onChanged: (String? keyword) {
                if (keyword != null) {
                  context.read<AccountBloc>().add(KeywordChanged(keyword));
                }
              },
              onFieldSubmitted: (String? keyword) {
                context.read<AccountBloc>().add(const AccountSearched());
                // context.read<SearchBloc>().add(const FilterAdded());
                // _controller.clear();
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0),
                ),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                labelText: 'Search here...',
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
                    icon: const Icon(
                      Icons.search_outlined,
                    ),
                    onPressed: () {
                      state.keyword.isNotEmpty
                          ? context
                              .read<AccountBloc>()
                              .add(const AccountSearched())
                          : context
                              .read<AccountBloc>()
                              .add(const AccountRequested());
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

class _AccountSliverList extends StatelessWidget {
  const _AccountSliverList({
    Key? key,
  }) : super(key: key);

  SliverChildBuilderDelegate _accountSliverChildBuilderDelegate({
    required List data,
  }) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        AccountOutline accountOutline = data[index];
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 0.0, 6.0, 4.0),
                                child: Text(
                                  accountOutline.account,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                    fontSize: CommonStyle.sizeL,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 0.0, 6.0, 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      accountOutline.permission,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                        fontSize: CommonStyle.sizeS,
                                        //fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 0.0, 6.0, 4.0),
                                child: Text(
                                  accountOutline.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                    fontSize: CommonStyle.sizeS,
                                    color: Colors.grey,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 0.0, 6.0, 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      accountOutline.department ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                        fontSize: CommonStyle.sizeS,
                                        //fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state.formStatus.isRequestInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.formStatus.isRequestSuccess) {
          return Container(
            color: Colors.grey.shade300,
            child: CustomScrollView(
              //shrinkWrap: true,
              slivers: [
                SliverList(
                  delegate: _accountSliverChildBuilderDelegate(
                    data: state.accounts,
                  ),
                )
              ],
            ),
          );
        } else if (state.formStatus.isRequestFailure) {
          return Center(
            child: Text(state.requestErrorMsg),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
