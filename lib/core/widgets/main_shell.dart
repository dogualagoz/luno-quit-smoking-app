// lib/core/widgets/main_shell.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: Container(
        // Yüksekliği güvenli bir sınıra (64px + alt pay) çekiyoruz
        height: 64 + (bottomPadding > 0 ? bottomPadding * 0.5 : 12),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.92),
          border: Border(
            top: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Theme(
              data: theme.copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                currentIndex: navigationShell.currentIndex,
                onTap: (index) => navigationShell.goBranch(index),
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconSize: 20,
                selectedItemColor: colorScheme.primary,
                unselectedItemColor: theme.hintColor,
                selectedLabelStyle: AppTextStyles.navLabel.copyWith(
                  fontSize: 9.6,
                  height: 1.0, // Yazının dikeyde yer kaplamasını önlüyoruz
                ),
                unselectedLabelStyle: AppTextStyles.navLabel.copyWith(
                  fontSize: 9.6,
                  height: 1.0,
                ),
                items: [
                  _buildNavItem(
                    Icons.home_outlined,
                    Icons.home_rounded,
                    "Ana Sayfa",
                  ),
                  _buildNavItem(
                    Icons.warning_amber_rounded,
                    Icons.warning_rounded,
                    "Zararlar",
                  ),
                  _buildNavItem(
                    Icons.show_chart_rounded,
                    Icons.insert_chart_rounded,
                    "İyileşme",
                  ),
                  _buildNavItem(
                    Icons.flash_on_outlined,
                    Icons.flash_on_rounded,
                    "Kriz",
                  ),
                  _buildNavItem(
                    Icons.history_rounded,
                    Icons.history_toggle_off_rounded,
                    "Geçmiş",
                  ),
                  _buildNavItem(
                    Icons.settings_outlined,
                    Icons.settings_rounded,
                    "Ayarlar",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(activeIcon),
          const SizedBox(height: 1),
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xFFE8A0BF),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
      label: label,
    );
  }
}
