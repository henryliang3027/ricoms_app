import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricoms_app/account/bloc/account/account_bloc.dart';
import 'package:ricoms_app/account/view/account_edit_page.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/repository/account_outline.dart';
import 'package:ricoms_app/root/bloc/form_status.dart';
import 'package:ricoms_app/root/view/custom_style.dart';
import 'package:ricoms_app/utils/common_style.dart';

class AccountForm extends StatelessWidget {
  const AccountForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showSuccessDialog(String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Deleted',
              style: TextStyle(
                color: CustomStyle.severityColor[1],
              ),
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
            title: Text(
              'Error',
              style: TextStyle(
                color: CustomStyle.severityColor[3],
              ),
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

    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.deleteStatus.isSubmissionSuccess) {
          _showSuccessDialog(state.deleteMsg);
        } else if (state.deleteStatus.isSubmissionFailure) {
          _showFailureDialog(state.deleteMsg);
        }
      },
      child: Scaffold(
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
      ),
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
          onPressed: () async {
            bool? isModify = await Navigator.push(
                context, AccountEditPage.route(isEditing: false));

            if (isModify != null) {
              if (isModify) {
                context.read<AccountBloc>().add(const AccountRequested());
              }
            }
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
                context.read<AccountBloc>().add(const AccountRequested());
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
                      context.read<AccountBloc>().add(const AccountRequested());
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
        int currentUserId =
            int.parse(context.read<AuthenticationBloc>().state.user.id);
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Material(
            color: currentUserId == accountOutline.id
                ? const Color(0xffb8daff)
                : index.isEven
                    ? Colors.grey.shade100
                    : Colors.white,
            child: InkWell(
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => _AccountEditBottomMenu(
                    superContext:
                        context, //pass this context contain AccountBloc so that BottomMenu can use it to call AccountDeleted event
                    accountOutline: accountOutline,
                  ),
                );
              },
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
          return Container(
            color: Colors.grey.shade300,
            child: Center(
              child: Text(state.requestErrorMsg),
            ),
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

class _AccountEditBottomMenu extends StatelessWidget {
  const _AccountEditBottomMenu({
    Key? key,
    required this.superContext,
    required this.accountOutline,
  }) : super(key: key);

  final BuildContext superContext;
  final AccountOutline accountOutline;

  @override
  Widget build(BuildContext context) {
    int currentUserId =
        int.parse(superContext.read<AuthenticationBloc>().state.user.id);

    Future<bool?> _showConfirmDeleteDialog(
        AccountOutline accountOutline) async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Account'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Are you sure you want to delete ',
                          style: TextStyle(
                            fontSize: CommonStyle.sizeXL,
                          ),
                        ),
                        TextSpan(
                          text: accountOutline.account,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: CommonStyle.sizeXL,
                          ),
                        ),
                        const TextSpan(
                          text: ' ?',
                          style: TextStyle(
                            fontSize: CommonStyle.sizeXL,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                },
              ),
              TextButton(
                child: Text(
                  'Yes, delete it!',
                  style: TextStyle(
                    color: CustomStyle.severityColor[3],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true); // pop dialog
                },
              ),
            ],
          );
        },
      );
    }

    return Wrap(
      children: [
        ListTile(
          dense: true,
          leading: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300, shape: BoxShape.circle),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: Icon(
                  Icons.edit,
                ),
              ),
            ),
          ),
          title: const Text(
            'Edit',
            style: TextStyle(fontSize: CommonStyle.sizeM),
          ),
          onTap: () async {
            Navigator.pop(context);
            bool? isModify = await Navigator.push(
                context,
                AccountEditPage.route(
                  isEditing: true,
                  accountOutline: accountOutline,
                ));

            if (isModify != null) {
              if (isModify) {
                superContext.read<AccountBloc>().add(const AccountRequested());
              }
            }
          },
        ),
        currentUserId == accountOutline.id
            ? Container()
            : ListTile(
                dense: true,
                leading: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300, shape: BoxShape.circle),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: Icon(
                        Icons.delete,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
                title: const Text(
                  'Delete',
                  style: TextStyle(fontSize: CommonStyle.sizeM),
                ),
                onTap: () async {
                  Navigator.pop(context);

                  bool? result = await _showConfirmDeleteDialog(accountOutline);
                  if (result != null) {
                    result
                        ? superContext
                            .read<AccountBloc>()
                            .add(AccountDeleted(accountOutline.id))
                        : null;
                  }
                },
              ),
      ],
    );
  }
}
