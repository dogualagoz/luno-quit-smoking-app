import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luno_quit_smoking_app/core/constants/asset_constants.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/features/diary/application/history_provider.dart';
import 'package:luno_quit_smoking_app/features/diary/data/models/daily_log.dart';
import 'package:luno_quit_smoking_app/core/providers/firebase_providers.dart';
import 'package:uuid/uuid.dart';

/// Ana sayfada gösterilen günlük check-in kartı.
/// Kullanıcıya yumuşak bir şekilde bugünkü durumunu sorar.
class DailyCheckinCard extends ConsumerStatefulWidget {
  final VoidCallback? onFewSmokes;
  final VoidCallback? onToughDay;

  const DailyCheckinCard({
    super.key,
    this.onFewSmokes,
    this.onToughDay,
  });

  @override
  ConsumerState<DailyCheckinCard> createState() => _DailyCheckinCardState();
}

class _DailyCheckinCardState extends ConsumerState<DailyCheckinCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _staggerController;
  int _pressedIndex = -1;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  // Temiz gün kaydı oluştur
  void _saveCleanDay() {
    HapticFeedback.mediumImpact();
    final log = DailyLog(
      id: const Uuid().v4(),
      date: DateTime.now(),
      cravingIntensity: 0,
      hasSmoked: false,
      smokeCount: 0,
      type: 'craving',
      moods: const [],
      context: const [],
      companions: const [],
      note: 'Temiz Gün ✨',
    );
    ref.read(historyLogsProvider.notifier).addLog(log);
    ref.read(analyticsServiceProvider).logCravingResisted(intensity: 0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor =
        isDark ? AppColors.darkChartSuccess : AppColors.lightChartSuccess;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final warningColor =
        isDark ? AppColors.darkChartWarning : AppColors.lightChartWarning;

    final options = [
      _CheckinOptionData(
        icon: Icons.shield_outlined,
        title: 'Temiz\nGün!',
        subtitle: 'İçmedim',
        color: successColor,
        onTap: _saveCleanDay,
      ),
      _CheckinOptionData(
        icon: Icons.smoking_rooms_outlined,
        title: 'Birkaç\nDal',
        subtitle: 'Kaydet',
        color: primary,
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onFewSmokes?.call();
        },
      ),
      _CheckinOptionData(
        icon: Icons.thunderstorm_outlined,
        title: 'Zor\nGün',
        subtitle: 'Detaylı',
        color: warningColor,
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onToughDay?.call();
        },
      ),
    ];

    return LunoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık satırı — maskot ile
          Row(
            children: [
              SvgPicture.asset(AssetConstants.cigeritoDefault, height: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bugün nasıl geçti?', style: AppTextStyles.cardHeader),
                    const SizedBox(height: 2),
                    Text(
                      'Ciğerito merak ediyor...',
                      style: AppTextStyles.caption.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.p20),

          // Seçenek kartları
          Row(
            children: List.generate(options.length, (index) {
              final staggerStart = index * 0.15;
              final staggerEnd = (staggerStart + 0.6).clamp(0.0, 1.0);
              final animation = CurvedAnimation(
                parent: _staggerController,
                curve: Interval(staggerStart, staggerEnd, curve: Curves.easeOutBack),
              );

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 6,
                    right: index == options.length - 1 ? 0 : 6,
                  ),
                  child: FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(animation),
                      child: _buildOptionTile(context, options[index], index),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    _CheckinOptionData option,
    int index,
  ) {
    final isPressed = _pressedIndex == index;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedIndex = index),
      onTapUp: (_) {
        setState(() => _pressedIndex = -1);
        option.onTap();
      },
      onTapCancel: () => setState(() => _pressedIndex = -1),
      child: AnimatedScale(
        scale: isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: isPressed
                ? option.color.withValues(alpha: 0.15)
                : option.color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPressed
                  ? option.color.withValues(alpha: 0.4)
                  : option.color.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: option.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(option.icon, color: option.color, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                option.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySemibold.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 13,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                option.subtitle,
                style: AppTextStyles.micro.copyWith(
                  color: option.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckinOptionData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CheckinOptionData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}
