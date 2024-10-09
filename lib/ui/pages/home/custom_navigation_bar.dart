import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:cookia/utils/router/app_route_name.dart';

class CustomNavigationBar extends StatefulWidget {
  final Widget child;

  const CustomNavigationBar({super.key, required this.child});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int currentIndex = 0;
  final Connectivity _connectivity = Connectivity();
  final routesNames = [
    AppRouteName.home.name,
    AppRouteName.menu.name,
    AppRouteName.book.name,
    AppRouteName.setting.name,
  ];

  void _iniListenConnectivity() {
    _connectivity.onConnectivityChanged.listen((event) {
      if (event.contains(ConnectivityResult.wifi) ||
          event.contains(ConnectivityResult.mobile) ||
          event.contains(ConnectivityResult.other)) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedHotspotOffline,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.youOffLine,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            duration: const Duration(days: 365),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _iniListenConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [widget.child],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: const Icon(HugeIcons.strokeRoundedHome03),
            activeIcon: _activeIcon(HugeIcons.strokeRoundedHome03),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(HugeIcons.strokeRoundedMenu03),
            activeIcon: _activeIcon(HugeIcons.strokeRoundedMenu03),
            label: AppLocalizations.of(context)!.menu,
          ),
          BottomNavigationBarItem(
            icon: const Icon(HugeIcons.strokeRoundedSearch01),
            activeIcon: _activeIcon(HugeIcons.strokeRoundedSearch01),
            label: AppLocalizations.of(context)!.searchW,
          ),
          BottomNavigationBarItem(
            icon: const Icon(HugeIcons.strokeRoundedSettings01),
            activeIcon: _activeIcon(HugeIcons.strokeRoundedSettings01),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
      context.goNamed(routesNames[index]);
    });
  }

  Widget _activeIcon(IconData iconData) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
