import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';

class NotesStep extends StatelessWidget {
  final TextEditingController controller;

  const NotesStep({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.p24),
          Text(
            'NOTLAR',
            style: AppTextStyles.label.copyWith(
              color: Theme.of(context).hintColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.p8),
          Text(
            'Neler olduğunu anlatmak ister misin?',
            style: AppTextStyles.cardHeader,
          ),
          const SizedBox(height: AppSpacing.p24),
          Expanded(
            child: LunoCard(
              child: TextField(
                controller: controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'O anki hislerini, tetikleyicileri buraya yazabilirsin...',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.p24),
        ],
      ),
    );
  }
}
