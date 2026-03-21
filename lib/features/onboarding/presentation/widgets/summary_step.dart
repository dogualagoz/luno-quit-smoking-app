import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/speech_bubble.dart';
import 'package:luno_quit_smoking_app/core/theme/app_mascot_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/asset_constants.dart';

class SummaryStep extends StatefulWidget {
  final int dailyCigarettes;
  final int smokingYears;
  final double packetPrice;
  final Function(String) onNameChanged;
  final Function(bool) onValidStateChanged;

  const SummaryStep({
    super.key,
    required this.dailyCigarettes,
    required this.smokingYears,
    required this.packetPrice,
    required this.onNameChanged,
    required this.onValidStateChanged,
  });

  @override
  State<SummaryStep> createState() => _SummaryStepState();
}

class _SummaryStepState extends State<SummaryStep> {
  final TextEditingController _nameController = TextEditingController();
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 0,
  );
  final NumberFormat _numberFormat = NumberFormat.decimalPattern('tr_TR');

  @override
  void initState() {
    super.initState();
    widget.onValidStateChanged(_nameController.text.trim().isNotEmpty);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalCigarettes = widget.dailyCigarettes * 365 * widget.smokingYears;
    final totalMoneySpent = (totalCigarettes / 20) * widget.packetPrice;
    final minutesStolen = totalCigarettes * 11;
    final daysLost = (minutesStolen / (60 * 24)).round();

    return SingleChildScrollView(
      padding: AppSpacing.pageHorizontal,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.p12),
          SvgPicture.asset(
            AssetConstants.cigeritoDefault,
            height: AppMascotSizes.medium,
          ),
          const SizedBox(height: AppSpacing.p8),
          const SpeechBubble(
            text: "İşte gerçekler... Ama birlikte değiştireceğiz, söz.",
          ),
          const SizedBox(height: AppSpacing.p20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.45,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _buildStatCard(
                "sigara içtin",
                _numberFormat.format(totalCigarettes),
                Icons.smoke_free,
              ),
              _buildStatCard(
                "harcadın",
                _currencyFormat.format(totalMoneySpent),
                Icons.money_off,
              ),
              _buildStatCard(
                "gün kaybettin",
                daysLost.toString(),
                Icons.access_time,
              ),
              _buildStatCard(
                "dk ömür çalındı",
                _numberFormat.format(minutesStolen),
                Icons.person_remove_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.05),
              borderRadius: AppRadius.mainCard,
            ),
            child: Text(
              "${_currencyFormat.format(totalMoneySpent)} ile sıfırdan bir araba alabilirdin.",
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.lightForeground.withValues(alpha: 0.7),
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SvgPicture.asset(
                AssetConstants.cigeritoDefault,
                height: AppMascotSizes.small,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: SpeechBubble(
                  text:
                      "Son bir şey! Sana ne diyelim? Takma ad da olur, gerçek ad da.",
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            onChanged: (val) {
              widget.onNameChanged(val);
              widget.onValidStateChanged(val.trim().isNotEmpty);
            },
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: "Adın veya takma adın...",
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              filled: true,
              fillColor: AppColors.lightCard,
              border: OutlineInputBorder(
                borderRadius: AppRadius.mainCard,
                borderSide: const BorderSide(color: AppColors.lightBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.mainCard,
                borderSide: const BorderSide(color: AppColors.lightBorder),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: AppRadius.mainCard,
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.lightPrimary, size: 26),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.label.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.lightForeground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.lightForeground.withValues(alpha: 0.5),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
