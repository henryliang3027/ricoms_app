import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ricoms_app/authentication/bloc/authentication_bloc.dart';
import 'package:ricoms_app/home/view/home_bottom_navigation_bar.dart';
import 'package:ricoms_app/home/view/home_drawer.dart';

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
  late final kExpandedHeight;

  double get _horizontalTitlePadding {
    const kBasePadding = 15.0;
    const kMultiplier = 2;

    if (_scrollController.hasClients) {
      if (_scrollController.offset < (kExpandedHeight / 2)) {
        // In case 50%-100% of the expanded height is viewed
        return kBasePadding;
      }

      if (_scrollController.offset > (kExpandedHeight - kToolbarHeight)) {
        // In case 0% of the expanded height is viewed
        return (kExpandedHeight / 2 - kToolbarHeight) * kMultiplier +
            kBasePadding;
      }

      // In case 0%-50% of the expanded height is viewed
      return (_scrollController.offset - (kExpandedHeight / 2)) * kMultiplier +
          kBasePadding;
    }

    return kBasePadding;
  }

  @override
  void initState() {
    kExpandedHeight = 160.0;
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            expandedHeight: kExpandedHeight,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: _horizontalTitlePadding,
              ),
              centerTitle: false,
              title: Text(
                AppLocalizations.of(context)!.about,
              ),
              background: Container(
                color: Colors.black,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
              child: Center(
                child: Text('Scroll to see the SliverAppBar in effect.'),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  color: index.isOdd ? Colors.white : Colors.black12,
                  height: 100.0,
                  child: Center(
                    child: Text('$index', textScaleFactor: 5),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}





// class AboutPage extends StatelessWidget {
//   const AboutPage({
//     Key? key,
//     required this.pageController,
//   }) : super(key: key);

//   final PageController pageController;

//   @override
//   Widget build(BuildContext context) {
//     Widget _buildParagraph(String paragraph) {
//       return Padding(
//         padding:
//             const EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
//         child: Text(
//           paragraph,
//         ),
//       );
//     }
// 
//     return Scaffold(
//       // appBar: AppBar(
//       //   centerTitle: true,
//       //   title: Text(
//       //     AppLocalizations.of(context)!.about,
//       //   ),
//       //   leading: HomeDrawerToolTip.setToolTip(context),
//       //   elevation: 0.0,
//       // ),
//       bottomNavigationBar: HomeBottomNavigationBar(
//         pageController: pageController,
//         selectedIndex: 5, // No need to show button, set an useless index
//       ),
//       drawer: HomeDrawer(
//         user: context.read<AuthenticationBloc>().state.user,
//         pageController: pageController,
//         currentPageIndex: 8,
//       ),
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             pinned: true,
//             snap: false,
//             floating: false,
//             expandedHeight: 160.0,
//             flexibleSpace: FlexibleSpaceBar(
//               centerTitle: true,
//               title: Text(
//                 AppLocalizations.of(context)!.about,
//               ),
//               background: Container(
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           const SliverToBoxAdapter(
//             child: SizedBox(
//               height: 20,
//               child: Center(
//                 child: Text('Scroll to see the SliverAppBar in effect.'),
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (BuildContext context, int index) {
//                 return Container(
//                   color: index.isOdd ? Colors.white : Colors.black12,
//                   height: 100.0,
//                   child: Center(
//                     child: Text('$index', textScaleFactor: 5),
//                   ),
//                 );
//               },
//               childCount: 20,
//             ),
//           ),
//         ],
//         // Column(
//         //   children: [
//         //     _buildParagraph(
//         //       AppLocalizations.of(context)!.aboutArticleParagraph1,
//         //     ),
//         //     _buildParagraph(
//         //       AppLocalizations.of(context)!.aboutArticleParagraph2,
//         //     ),
//         //     _buildParagraph(
//         //       AppLocalizations.of(context)!.aboutArticleParagraph3,
//         //     ),
//         //     _buildParagraph(
//         //       AppLocalizations.of(context)!.aboutArticleParagraph4,
//         //     ),
//         //     _buildParagraph(
//         //       AppLocalizations.of(context)!.aboutArticleParagraph5,
//         //     ),
//         //   ],
//         // ),
//       ),
//     );
//   }
// }
