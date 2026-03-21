import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';

class LocationStep extends StatelessWidget {
  final String? location;
  final ValueChanged<String?> onLocationChanged;

  const LocationStep({
    super.key,
    required this.location,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    final List<Map<String, dynamic>> quickLocations = [
      {'name': 'Ev', 'icon': Icons.home},
      {'name': 'İş', 'icon': Icons.work},
      {'name': 'Dışarıda', 'icon': Icons.directions_walk},
      {'name': 'Araçta', 'icon': Icons.directions_car},
      {'name': 'Kafe/Restoran', 'icon': Icons.local_cafe},
    ];

    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.p24),
            Text(
              'KONUM',
              style: AppTextStyles.label.copyWith(
                color: Theme.of(context).hintColor,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.p8),
            Text(
              'Neredeydin?',
              style: AppTextStyles.cardHeader,
            ),
            const SizedBox(height: AppSpacing.p24),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  // TODO: Implement location service
                  onLocationChanged('Yakınlarda bir yer...');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Konum hizmeti yakında eklenecek!')),
                  );
                },
                icon: Icon(Icons.my_location, color: primaryColor),
                label: Text(
                  'Konumumu Bul',
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.p24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: quickLocations.map((loc) {
                final isSelected = location == loc['name'];
                return InkWell(
                  onTap: () => onLocationChanged(loc['name']),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor.withValues(alpha: 0.1) : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? primaryColor : AppColors.lightBorder.withValues(alpha: isDark ? 0.1 : 0.08),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          loc['icon'],
                          size: 20,
                          color: isSelected ? primaryColor : Theme.of(context).hintColor,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          loc['name'],
                          style: AppTextStyles.bodySemibold.copyWith(
                            color: isSelected ? primaryColor : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.p24),
            Text(
              'Veya manuel gir:',
              style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: AppSpacing.p8),
            LunoCard(
              child: TextField(
                onChanged: onLocationChanged,
                decoration: InputDecoration(
                  hintText: 'Konum adı yazın...',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: InputBorder.none,
                ),
                controller: TextEditingController(text: location)
                  ..selection = TextSelection.collapsed(offset: location?.length ?? 0),
              ),
            ),
            const SizedBox(height: AppSpacing.p40),
          ],
        ),
      ),
    );
  }
}
