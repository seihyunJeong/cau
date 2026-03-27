import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../activity/screens/activity_list_screen.dart';
import '../dev_check/screens/dev_check_main_screen.dart';
import '../home/screens/home_screen.dart';
import '../my/screens/my_screen.dart';
import '../record/screens/record_main_screen.dart';

/// 메인 쉘 -- 5탭 IndexedStack 기반.
/// 개발기획서 5-2 기준.
/// 홈 탭(index 0)은 HomeScreen, 나머지 탭은 플레이스홀더.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _tabLabels = [
    AppStrings.home,
    AppStrings.record,
    AppStrings.activity,
    AppStrings.devCheck,
    AppStrings.my,
  ];

  static const _tabIcons = [
    Icons.home_outlined,
    Icons.edit_note,
    Icons.star_outline,
    Icons.insights_outlined,
    Icons.person_outline,
  ];

  static const _tabSelectedIcons = [
    Icons.home,
    Icons.edit_note,
    Icons.star,
    Icons.insights,
    Icons.person,
  ];

  static const _tabKeys = [
    ValueKey('nav_tab_home'),
    ValueKey('nav_tab_record'),
    ValueKey('nav_tab_activity'),
    ValueKey('nav_tab_dev_check'),
    ValueKey('nav_tab_my'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('main_shell'),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomeScreen(),
          const RecordMainScreen(),
          const ActivityListScreen(),
          const DevCheckMainScreen(),
          const MyScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        key: const ValueKey('bottom_nav_bar'),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: List.generate(
          _tabLabels.length,
          (i) => NavigationDestination(
            key: _tabKeys[i],
            icon: Icon(_tabIcons[i]),
            selectedIcon: Icon(_tabSelectedIcons[i]),
            label: _tabLabels[i],
          ),
        ),
      ),
    );
  }
}

