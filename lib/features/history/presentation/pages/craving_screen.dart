import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:luno_quit_smoking_app/core/constants/craving_options.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/core/widgets/selection_chip_grid.dart';
import 'package:luno_quit_smoking_app/features/history/application/history_provider.dart';
import 'package:luno_quit_smoking_app/features/history/data/models/daily_log.dart';
import 'package:uuid/uuid.dart';

class CravingScreen extends ConsumerStatefulWidget {
  const CravingScreen({super.key});

  @override
  ConsumerState<CravingScreen> createState() => _CravingScreenState();
}

class _CravingScreenState extends ConsumerState<CravingScreen> {
  final DateTime _selectedDate = DateTime.now();
  double _intensity = 0;
  bool _hasSmoked = false;
  int _smokeCount = 1; // Başlangıç 1 olarak ayarlandı
  String? _location;
  final List<String> _selectedMoods = [];
  final List<String> _selectedContext = [];
  final List<String> _selectedCompanions = [];
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    int count = 0;
    if (_hasSmoked && _smokeCount > 0) {
      count = _smokeCount;
    }

    final log = DailyLog(
      id: const Uuid().v4(),
      date: _selectedDate,
      cravingIntensity: _intensity.toInt(),
      hasSmoked: _hasSmoked,
      smokeCount: count,
      location: _location,
      moods: _selectedMoods,
      context: _selectedContext,
      companions: _selectedCompanions,
      note: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    ref.read(historyLogsProvider.notifier).addLog(log);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Kriz Kaydı',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: TextButton(
          onPressed: () => context.pop(),
          child: Text('İptal', style: TextStyle(color: primaryColor)),
        ),
        leadingWidth: 80,
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              'Kaydet',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacing.pageHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('NE ZAMANDI?'),
              LunoCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat('dd MMMM yyyy HH:mm').format(_selectedDate),
                    style: AppTextStyles.bodySemibold,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.p24),
              _buildSectionTitle('SİGARA İÇME İSTEĞİN NE KADAR GÜÇLÜYDÜ?'),
              LunoCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hiç',
                          style: AppTextStyles.caption.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        Text(
                          'Çıldırtıcı!',
                          style: AppTextStyles.caption.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _intensity,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      activeColor: primaryColor,
                      label: _intensity.round().toString(),
                      onChanged: (val) {
                        setState(() => _intensity = val);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.p24),
              _buildSectionTitle('SİGARA İÇİP İÇMEDİĞİNİ BELİRT LÜTFEN'),
              LunoCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Evet'),
                      trailing: _hasSmoked
                          ? Icon(Icons.check, color: primaryColor)
                          : null,
                      onTap: () => setState(() => _hasSmoked = true),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Hayır'),
                      trailing: !_hasSmoked
                          ? Icon(Icons.check, color: primaryColor)
                          : null,
                      onTap: () {
                        setState(() {
                          _hasSmoked = false;
                          _smokeCount = 1; // Sıfırla
                        });
                      },
                    ),
                  ],
                ),
              ),

              if (_hasSmoked) ...[
                const SizedBox(height: AppSpacing.p24),
                _buildSectionTitle('KAÇ TANE İÇTİN?'),
                LunoCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_smokeCount > 1) {
                            setState(() {
                              _smokeCount--;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.remove,
                            color: primaryColor,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Column(
                        children: [
                          Text(
                            _smokeCount.toString(),
                            style: AppTextStyles.largeNumber.copyWith(
                              fontSize: 48,
                              color: Theme.of(context).colorScheme.onSurface,
                              height: 1,
                            ),
                          ),
                          Text(
                            "sigara",
                            style: AppTextStyles.body.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.5),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 32),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _smokeCount++;
                          });
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.add, color: primaryColor, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.p24),
              _buildSectionTitle('NEREDEYDİN?'),
              LunoCard(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _location = "Ev (Örnek Konum)";
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      _location ?? 'Konum ekle',
                      style: TextStyle(
                        color: _location == null
                            ? primaryColor
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.p24),
              _buildSectionTitle('NASIL HİSSEDİYORSUN?'),
              SelectionChipGrid(
                options: CravingOptions.moods,
                selectedOptions: _selectedMoods,
                onSelected: (val) {
                  setState(() {
                    if (_selectedMoods.contains(val))
                      _selectedMoods.remove(val);
                    else
                      _selectedMoods.add(val);
                  });
                },
              ),

              const SizedBox(height: AppSpacing.p24),
              _buildSectionTitle('NE YAPIYORDUN?'),
              SelectionChipGrid(
                options: CravingOptions.activities,
                selectedOptions: _selectedContext,
                onSelected: (val) {
                  setState(() {
                    if (_selectedContext.contains(val))
                      _selectedContext.remove(val);
                    else
                      _selectedContext.add(val);
                  });
                },
              ),

              const SizedBox(height: AppSpacing.p24),
              _buildSectionTitle('KİMİNLEYDİN?'),
              SelectionChipGrid(
                options: CravingOptions.companions,
                selectedOptions: _selectedCompanions,
                onSelected: (val) {
                  setState(() {
                    if (_selectedCompanions.contains(val))
                      _selectedCompanions.remove(val);
                    else
                      _selectedCompanions.add(val);
                  });
                },
              ),

              const SizedBox(height: AppSpacing.p24),
              _buildSectionTitle('NELER OLDU?'),
              LunoCard(
                child: TextField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Notlarını buraya kaydedebilirsin',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.p40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).hintColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
