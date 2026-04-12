import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_button.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_progress_bar.dart';
import 'package:luno_quit_smoking_app/features/diary/application/history_provider.dart';
import 'package:luno_quit_smoking_app/features/diary/data/models/daily_log.dart';
import 'package:luno_quit_smoking_app/core/providers/firebase_providers.dart';
import 'package:uuid/uuid.dart';

// Steps
import '../widgets/craving_steps/smoked_check_step.dart';
import '../widgets/craving_steps/congratulations_step.dart';
import '../widgets/craving_steps/smoke_count_step.dart';
import '../widgets/craving_steps/intensity_step.dart';
import '../widgets/craving_steps/mood_step.dart';
import '../widgets/craving_steps/activity_step.dart';
import '../widgets/craving_steps/companion_step.dart';
import '../widgets/craving_steps/location_step.dart';
import '../widgets/craving_steps/notes_step.dart';

class CravingScreen extends ConsumerStatefulWidget {
  const CravingScreen({super.key});

  @override
  ConsumerState<CravingScreen> createState() => _CravingScreenState();
}

class _CravingScreenState extends ConsumerState<CravingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Form State
  bool? _hasSmoked;
  int _smokeCount = 1;
  double _intensity = 5;
  String? _location;
  final List<String> _selectedMoods = [];
  final List<String> _selectedContext = [];
  final List<String> _selectedCompanions = [];
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _otherMoodController = TextEditingController();
  final TextEditingController _otherActivityController = TextEditingController();

  // Adımları dinamik olarak oluşturuyoruz
  List<Widget> get _steps {
    final List<Widget> steps = [];

    // STEP 0: Sigara İçtin mi? (Ana Sorun)
    steps.add(SmokedCheckStep(
      hasSmoked: _hasSmoked,
      onStatusChanged: (val) {
        setState(() => _hasSmoked = val);
        _nextPage(); // Seçim yapınca otomatik bir sonrakine geç
      },
    ));

    if (_hasSmoked == null) return steps;

    if (_hasSmoked == false) {
      // --- İÇMEDİ (Kriz Akışı) ---
      steps.addAll([
        IntensityStep(
          value: _intensity,
          onValueChanged: (val) => setState(() => _intensity = val),
        ),
        MoodStep(
          selectedMoods: _selectedMoods,
          otherController: _otherMoodController,
          onMoodSelected: _toggleMood,
        ),
        ActivityStep(
          selectedActivities: _selectedContext,
          otherController: _otherActivityController,
          onActivitySelected: _toggleActivity,
        ),
        NotesStep(controller: _notesController),
        const CongratulationsStep(),
      ]);
    } else {
      // --- İÇTİ (Slip Akışı) ---
      steps.addAll([
        SmokeCountStep(
          count: _smokeCount,
          onValueChanged: (val) => setState(() => _smokeCount = val),
        ),
        LocationStep(
          location: _location,
          onLocationChanged: (val) => setState(() => _location = val),
        ),
        MoodStep(
          selectedMoods: _selectedMoods,
          otherController: _otherMoodController,
          onMoodSelected: _toggleMood,
        ),
        ActivityStep(
          selectedActivities: _selectedContext,
          otherController: _otherActivityController,
          onActivitySelected: _toggleActivity,
        ),
        CompanionStep(
          selectedCompanions: _selectedCompanions,
          onCompanionSelected: _toggleCompanion,
        ),
        NotesStep(controller: _notesController),
      ]);
    }

    return steps;
  }

  void _toggleMood(String val) {
    setState(() {
      if (_selectedMoods.contains(val)) {
        _selectedMoods.remove(val);
      } else {
        _selectedMoods.add(val);
      }
    });
  }

  void _toggleActivity(String val) {
    setState(() {
      if (_selectedContext.contains(val)) {
        _selectedContext.remove(val);
      } else {
        _selectedContext.add(val);
      }
    });
  }

  void _toggleCompanion(String val) {
    setState(() {
      _selectedCompanions.clear();
      _selectedCompanions.add(val);
    });
  }

  int get _totalSteps => _steps.length;

  @override
  void dispose() {
    _pageController.dispose();
    _notesController.dispose();
    _otherMoodController.dispose();
    _otherActivityController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _submit();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  void _submit() {
    final finalMoods = List<String>.from(_selectedMoods);
    if (_selectedMoods.contains('Diğer') && _otherMoodController.text.isNotEmpty) {
      finalMoods.add(_otherMoodController.text.trim());
    }

    final finalActivities = List<String>.from(_selectedContext);
    if (_selectedContext.contains('Diğer') && _otherActivityController.text.isNotEmpty) {
      finalActivities.add(_otherActivityController.text.trim());
    }

    final log = DailyLog(
      id: const Uuid().v4(),
      date: DateTime.now(),
      cravingIntensity: _hasSmoked == false ? _intensity.toInt() : 0,
      hasSmoked: _hasSmoked ?? false,
      smokeCount: _hasSmoked == true ? _smokeCount : 0,
      type: _hasSmoked == true ? 'slip' : 'craving',
      location: _location,
      moods: finalMoods,
      context: finalActivities,
      companions: _selectedCompanions,
      note: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    // Önce ekranı kapat, kayıt arkada devam etsin
    context.pop();
    ref.read(historyLogsProvider.notifier).addLog(log);

    // Analytics: Olayları logla
    final analytics = ref.read(analyticsServiceProvider);
    if (log.hasSmoked) {
      analytics.logSmokeLogged(count: log.smokeCount, reason: log.note);
    } else {
      analytics.logCravingResisted(intensity: log.cravingIntensity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() => _currentPage = page);
                },
                children: _steps,
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _currentPage == 0 ? Icons.close : Icons.arrow_back,
              color: isDark ? AppColors.darkForeground : AppColors.lightForeground,
            ),
            onPressed: _previousPage,
          ),
          Expanded(
            child: LunoProgressBar(value: (_currentPage + 1) / _totalSteps),
          ),
          const SizedBox(width: 16),
          Text(
            "${_currentPage + 1}/$_totalSteps",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    // İlk sayfada seçim yapana kadar butonu gizle (UX açısından daha temiz)
    if (_currentPage == 0 && _hasSmoked == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.p24, 0, AppSpacing.p24, AppSpacing.p24),
      child: LunoButton(
        text: _currentPage == _totalSteps - 1 ? "Kaydet" : "Devam Et",
        icon: _currentPage == _totalSteps - 1 ? Icons.check : Icons.arrow_forward,
        onPressed: _nextPage,
      ),
    );
  }
}
