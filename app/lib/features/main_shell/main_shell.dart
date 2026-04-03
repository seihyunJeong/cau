import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../activity/screens/activity_list_screen.dart';
import '../dev_check/screens/dev_check_main_screen.dart';
import '../home/screens/home_screen.dart';
import '../my/screens/my_screen.dart';
import '../record/screens/record_main_screen.dart';

/// 메인 쉘 -- 5탭 기반.
/// 개발기획서 5-2 기준.
/// IndexedStack 유지하되, 탭 전환 시 AnimatedOpacity + AnimatedSlide로
/// 부드러운 크로스페이드 효과를 적용한다.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _previousIndex = 0;

  late AnimationController _tabAnimController;
  late Animation<double> _fadeAnimation;

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

  static const _screens = [
    HomeScreen(),
    RecordMainScreen(),
    ActivityListScreen(),
    DevCheckMainScreen(),
    MyScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _tabAnimController,
        curve: Curves.easeOut,
      ),
    );
    _tabAnimController.value = 1.0;
  }

  @override
  void dispose() {
    _tabAnimController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });
    _tabAnimController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('main_shell'),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              // Previous tab (fading out)
              if (_previousIndex != _currentIndex)
                Opacity(
                  opacity: (1.0 - _fadeAnimation.value).clamp(0.0, 1.0),
                  child: IgnorePointer(
                    ignoring: true,
                    child: _screens[_previousIndex],
                  ),
                ),
              // Current tab (fading in)
              Opacity(
                opacity: _fadeAnimation.value.clamp(0.0, 1.0),
                child: _screens[_currentIndex],
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        key: const ValueKey('bottom_nav_bar'),
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
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
