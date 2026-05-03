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
    final screenWidth = MediaQuery.of(context).size.width;

    // Yanlardan 16'şar (toplam 32) padding veriyoruz
    const double horizontalPadding = 16.0;
    final navWidth = screenWidth - (horizontalPadding * 2);
    final itemWidth = navWidth / 5;

    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: Container(
        // Yüksekliği 4px daha artırdık (68 -> 72)
        height: 72 + (bottomPadding > 0 ? bottomPadding * 0.5 : 12),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: horizontalPadding,
              ),
              child: Stack(
                children: [
                  Theme(
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
                      iconSize: 24, // 20'den 24'e çıkarıldı
                      selectedItemColor: colorScheme.primary,
                      unselectedItemColor: theme.hintColor,
                      selectedLabelStyle: AppTextStyles.navLabel.copyWith(
                        fontSize: 9.6,
                        height: 1.4, // Yazıyı biraz daha aşağı iter
                      ),
                      unselectedLabelStyle: AppTextStyles.navLabel.copyWith(
                        fontSize: 9.6,
                        height: 1.4,
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
                          Icons.flash_on,
                          Icons.flash_on_rounded,
                          "Kriz",
                        ),
                        _buildNavItem(
                          Icons.menu_book_outlined,
                          Icons.menu_book_rounded,
                          "Günlük",
                        ),
                        _buildNavItem(
                          Icons.settings_outlined,
                          Icons.settings_rounded,
                          "Ayarlar",
                        ),
                      ],
                    ),
                  ),

                  // ─── KAYAN NOKTA ANİMASYONU ───
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    // Noktanın yataydaki konumu: (index * parça_genişliği) + yarım_parça - yarım_nokta
                    left:
                        (navigationShell.currentIndex * itemWidth) +
                        (itemWidth / 2) -
                        2,
                    top:
                        32, // Navbar büyüdüğü için nokta 4px aşağı kaydırıldı (28 -> 32)
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
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
      activeIcon: Icon(activeIcon),
      label: label,
    );
  }
}
