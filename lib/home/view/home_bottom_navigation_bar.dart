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
          icon: Icon(CustomIcons.realTimeAlarm),
          label: 'Real-Time Alarm',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.network),
          label: 'Network',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.dashboard),
          label: 'Dashboard',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.history),
          label: 'History',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.bookmarks),
          label: 'Bookmarks',
          tooltip: '',
        ),
      ],
      //if current page is account which is not list in bottom navigation bar, make all items grey color
      //assign a useless 0 as currentIndex for account page
      currentIndex: selectedIndex >= 5 ? 0 : selectedIndex,
      selectedItemColor: selectedIndex >= 5
          ? Theme.of(context).hintColor
          : Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).hintColor,
      onTap: _onBottomItemTapped,
    );
  }
}
