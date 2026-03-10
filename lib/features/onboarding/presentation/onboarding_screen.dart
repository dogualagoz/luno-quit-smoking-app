import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luno_button.dart';
import '../../../core/widgets/luno_progress_bar.dart';
import 'widgets/intro_step.dart';
import 'widgets/legal_step.dart';
import 'widgets/smoking_years_step.dart';
import 'widgets/daily_cigarettes_step.dart';
import 'widgets/packet_price_step.dart';
import 'widgets/trying_count_step.dart';
import 'widgets/reasons_step.dart';
import 'widgets/trigger_moments_step.dart';
import 'widgets/final_legal_step.dart';
import 'widgets/summary_step.dart';
import '../application/onboarding_provider.dart';
import '../../../core/constants/app_constants.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalSteps = 10;

  // Form Verileri
  int _dailyCigarettes = 20;
  int _smokingYears = 5;
  double _packetPrice = 75.0;
  String? _tryingCount;
  List<String> _selectedReasons = [];
  String? _triggerMoment;
  String _userName = "";

  // Buton Durumu
  bool _isButtonEnabled = true;
  String _buttonLabel = "Devam";

  void _updateButtonState({required bool isEnabled, String? label}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isButtonEnabled = isEnabled;
          if (label != null) _buttonLabel = label;
        });
      }
    });
  }

  void _nextPage() {
    if (_currentPage < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _finishOnboarding() async {
    await ref
        .read(onboardingProvider.notifier)
        .completeOnboarding(
          nickname: _userName.trim().isEmpty ? AppMockData.userName : _userName,
          dailyCigarettes: _dailyCigarettes,
          smokingYears: _smokingYears,
          packPrice: _packetPrice,
          tryingToQuitCount: _tryingCount,
          quitReasons: _selectedReasons,
          triggerMoment: _triggerMoment,
          quitDate: DateTime.now(),
        );

    if (mounted) {
      context.go('/auth-selection', extra: _userName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() => _currentPage = page);
                },
                children: [
                  IntroStep(
                    onValidStateChanged: (isValid) => _updateButtonState(
                      isEnabled: isValid,
                      label: "Başlayalım",
                    ),
                  ),
                  LegalStep(
                    onValidStateChanged: (isValid) =>
                        _updateButtonState(isEnabled: isValid, label: "Devam"),
                  ),
                  SmokingYearsStep(
                    initialValue: _smokingYears,
                    onValueChanged: (val) => _smokingYears = val,
                  ),
                  DailyCigarettesStep(
                    initialValue: _dailyCigarettes,
                    onValueChanged: (val) => _dailyCigarettes = val,
                    onValidStateChanged: (isValid) =>
                        _updateButtonState(isEnabled: isValid),
                  ),
                  PacketPriceStep(
                    initialValue: _packetPrice,
                    dailyCigarettes: _dailyCigarettes,
                    onValueChanged: (val) => _packetPrice = val,
                  ),
                  TryingCountStep(
                    initialValue: _tryingCount,
                    onValueChanged: (val) {
                      _tryingCount = val;
                      _updateButtonState(isEnabled: true);
                    },
                    onValidStateChanged: (isValid) =>
                        _updateButtonState(isEnabled: isValid),
                  ),
                  ReasonsStep(
                    initialValues: _selectedReasons,
                    onValuesChanged: (val) {
                      _selectedReasons = val;
                      _updateButtonState(isEnabled: val.isNotEmpty);
                    },
                    onValidStateChanged: (isValid) =>
                        _updateButtonState(isEnabled: isValid),
                  ),
                  TriggerMomentsStep(
                    initialValue: _triggerMoment,
                    onValueChanged: (val) {
                      _triggerMoment = val;
                      _updateButtonState(isEnabled: true);
                    },
                    onValidStateChanged: (isValid) =>
                        _updateButtonState(isEnabled: isValid),
                  ),
                  FinalLegalStep(
                    onValidStateChanged: (isValid) => _updateButtonState(
                      isEnabled: isValid,
                      label: "Kabul ediyorum",
                    ),
                  ),
                  SummaryStep(
                    dailyCigarettes: _dailyCigarettes,
                    smokingYears: _smokingYears,
                    packetPrice: _packetPrice,
                    onNameChanged: (name) {
                      _userName = name;
                      _updateButtonState(isEnabled: name.trim().isNotEmpty);
                    },
                    onValidStateChanged: (isValid) => _updateButtonState(
                      isEnabled: isValid,
                      label: "Hazırım, başlayalım!",
                    ),
                  ),
                ],
              ),
            ),
            _buildFixedFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.lightForeground,
            ),
            onPressed: _currentPage > 0 ? _previousPage : null,
          ),
          Expanded(
            child: LunoProgressBar(value: (_currentPage + 1) / _totalSteps),
          ),
          const SizedBox(width: 16),
          Text(
            "${_currentPage + 1}/$_totalSteps",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.lightForeground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.p24,
        0,
        AppSpacing.p24,
        AppSpacing.p32,
      ),
      child: LunoButton(
        text: _buttonLabel,
        icon: _currentPage == _totalSteps - 1
            ? Icons.check
            : Icons.arrow_forward,
        onPressed: _isButtonEnabled ? _nextPage : () {},
      ),
    );
  }
}
