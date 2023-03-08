import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';
import 'package:ricoms_app/utils/common_style.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late final ScrollController _scrollController;
  late final double _kExpandedHeight;
  late final String _customerServiceEmailAddress;

  @override
  void initState() {
    _kExpandedHeight = 160.0;
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _customerServiceEmailAddress = 'RDC-DEMO@twoway.com.tw';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _horizontalTitlePadding() {
      const kBasePadding = 40.0;
      const kMultiplier = 5;

      if (_scrollController.hasClients) {
        if (_scrollController.offset < (_kExpandedHeight / 2)) {
          // In case 50%-100% of the expanded height is viewed
          return kBasePadding;
        }

        if (_scrollController.offset > (_kExpandedHeight - kToolbarHeight)) {
          // In case 0% of the expanded height is viewed
          return (_kExpandedHeight / 2 - kToolbarHeight) * kMultiplier +
              kBasePadding;
        }

        // In case 0%-50% of the expanded height is viewed
        return (_scrollController.offset - (_kExpandedHeight / 2)) *
                kMultiplier +
            kBasePadding;
      }

      return kBasePadding;
    }

    double _getTitleFontSize() {
      const defaultSize = 30.0;

      if (_scrollController.hasClients) {
        if (_scrollController.offset < (_kExpandedHeight / 2)) {
          // In case 50%-100% of the expanded height is viewed
          return 30;
        }

        if (_scrollController.offset > (_kExpandedHeight - kToolbarHeight)) {
          // In case 0% of the expanded height is viewed
          return 22;
        }

        // In case 0%-50% of the expanded height is viewed
        return 30 - (_scrollController.offset - (_kExpandedHeight / 2)) * 0.3;
      }

      return defaultSize;
    }

    bool _isCenterTitle() {
      if (_scrollController.hasClients) {
        if (_scrollController.offset > (_kExpandedHeight - kToolbarHeight)) {
          // In case 0% of the expanded height is viewed
          return true;
        }

        return false;
      }

      return false;
    }

    Widget _buildParagraph(String paragraph) {
      return Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 0, left: 30, right: 30),
        child: Text(
          paragraph,
        ),
      );
    }

    return Scaffold(
      bottomNavigationBar: HomeBottomNavigationBar(
        pageController: widget.pageController,
        selectedIndex: 5, // No need to show button, set an useless index
      ),
      drawer: HomeDrawer(
        user: context.read<AuthenticationBloc>().state.user,
        pageController: widget.pageController,
        currentPageIndex: 8,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: _kExpandedHeight,
            flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: _horizontalTitlePadding(),
                ),
                centerTitle: _isCenterTitle(),
                title: Text(
                  AppLocalizations.of(context)!.about,
                  style: TextStyle(
                    fontSize: _getTitleFontSize(),
                  ),
                ),
                background: Stack(
                  children: [
                    Container(
                      color: Colors.black,
                    ),
                    Positioned(
                      top: 70.0,
                      right: 10.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.all(0.0),
                          visualDensity: const VisualDensity(
                            horizontal: -4.0,
                            vertical: -4.0,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.contactUs,
                          style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onPressed: () async {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: _customerServiceEmailAddress,
                          );

                          try {
                            await launchUrl(emailLaunchUri);
                          } on Exception catch (_) {
                            // ignore
                          }
                        },
                      ),
                    ),
                  ],
                )),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildParagraph(
                  AppLocalizations.of(context)!.aboutArticleParagraph1,
                ),
                _buildParagraph(
                  AppLocalizations.of(context)!.aboutArticleParagraph2,
                ),
                _buildParagraph(
                  AppLocalizations.of(context)!.aboutArticleParagraph3,
                ),
                _buildParagraph(
                  AppLocalizations.of(context)!.aboutArticleParagraph4,
                ),
                _buildParagraph(
                  AppLocalizations.of(context)!.aboutArticleParagraph5,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, bottom: 0, left: 30, right: 30),
                  child: Table(
                    children: [
                      TableRow(children: [
                        Container(
                          alignment: Alignment.center,
                          child: const Image(
                            image:
                                AssetImage('assets/about_project_manager.png'),
                            //fit: BoxFit.contain,
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.fill,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Colors.grey,
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.projectManager,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 0, left: 30, right: 30),
                  child: Table(
                    children: [
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.fill,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Colors.grey,
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.websiteDesigner,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: const Image(
                            image:
                                AssetImage('assets/about_web_ui_designer.png'),
                            //fit: BoxFit.contain,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 0, left: 30, right: 30),
                  child: Table(
                    children: [
                      TableRow(children: [
                        Container(
                          alignment: Alignment.center,
                          child: const Image(
                            image: AssetImage(
                                'assets/about_frontend_backend_engineer.png'),
                            //fit: BoxFit.contain,
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.fill,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Colors.grey,
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .frontendBackendEngineer,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 0, left: 30, right: 30),
                  child: Table(
                    children: [
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.fill,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Colors.grey,
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.systemEngineer,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: const Image(
                            image:
                                AssetImage('assets/about_system_engineer.png'),
                            //fit: BoxFit.contain,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
