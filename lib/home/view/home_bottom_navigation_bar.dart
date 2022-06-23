import 'package:flutter/material.dart';
import 'package:ricoms_app/custom_icons/custom_icons_icons.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.pageController,
  }) : super(key: key);

  final int selectedIndex;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    void _onBottomItemTapped(int index) {
      pageController.jumpToPage(
        index,
      );
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.realtime_alarm),
          label: 'Real-Time Alarm',
        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.network),
          label: 'Network',
        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.bookmarks),
          label: 'Bookmarks',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).hintColor,
      onTap: _onBottomItemTapped,
    );
  }
}
