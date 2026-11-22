import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_constants.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    (icon: Icons.home_outlined, selected: Icons.home, label: 'Trang chủ'),
    (icon: Icons.style_outlined, selected: Icons.style, label: 'Bộ từ'),
    (icon: Icons.search, selected: Icons.search, label: 'Tra từ'),
    (icon: Icons.bar_chart_outlined, selected: Icons.bar_chart, label: 'Thống kê'),
  ];

  void _go(int index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context) {
    final index = navigationShell.currentIndex;
    // Own messenger so a screen's SnackBar lands in that screen's Scaffold
    // and lifts its FAB, instead of in this outer Scaffold under the FAB.
    final body = ScaffoldMessenger(child: navigationShell);
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= kWideBreakpoint) {
        return Scaffold(
          body: Row(children: [
            NavigationRail(
              selectedIndex: index,
              onDestinationSelected: _go,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final t in _tabs)
                  NavigationRailDestination(
                    icon: Icon(t.icon),
                    selectedIcon: Icon(t.selected),
                    label: Text(t.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ]),
        );
      }
      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: _go,
          destinations: [
            for (final t in _tabs)
              NavigationDestination(
                icon: Icon(t.icon),
                selectedIcon: Icon(t.selected),
                label: t.label,
              ),
          ],
        ),
      );
    });
  }
}
