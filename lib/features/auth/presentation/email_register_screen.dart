import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/cigerito_mascot.dart';
import '../../../core/widgets/speech_bubble.dart';

class EmailRegisterScreen extends StatefulWidget {
  const EmailRegisterScreen({super.key});

  @override
  State<EmailRegisterScreen> createState() => _EmailRegisterScreenState();
}

class _EmailRegisterScreenState extends State<EmailRegisterScreen> {
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.lightForeground),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.pageHorizontal,
          child: Column(
            children: [
              // Maskot ve Konuşma Balonu
              const Center(
                child: CigeritoMascot(mode: MascotMode.happy, size: 100),
              ),
              const SizedBox(height: AppSpacing.p12),
              const SpeechBubble(text: "Yeni hesap oluştur, ben seni unutmam!"),
              const SizedBox(height: AppSpacing.p24),

              // Başlıklar
              Text(
                'Hesap Oluştur',
                style: AppTextStyles.pageHeader.copyWith(
                  color: AppColors.lightForeground,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Hemen ücretsiz hesabını oluştur',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.lightMutedForeground,
                ),
              ),
              const SizedBox(height: AppSpacing.p32),

              // Form Kutusu
              Container(
                padding: AppSpacing.cardPaddingLarge,
                decoration: BoxDecoration(
                  color: AppColors.lightCard,
                  borderRadius: AppRadius.mainCard,
                  border: Border.all(color: AppColors.lightBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('E-posta', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _emailController,
                      hint: 'ornek@mail.com',
                      icon: Icons.mail_outline,
                    ),
                    const SizedBox(height: 20),
                    Text('Şifre', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _passwordController,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      isPasswordVisible: _isPasswordVisible,
                      onToggleVisibility: () {
                        setState(
                          () => _isPasswordVisible = !_isPasswordVisible,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildRegisterButton(),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.p24),

              // Giriş Yap Linki
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Zaten hesabın var mı? ',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.lightMutedForeground,
                    ),
                  ),
                  InkWell(
                    onTap: () => context.pop(),
                    child: Text(
                      'Giriş yap',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.lightPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.p32),

              // Sosyal Giriş Bölümü
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.lightBorder)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'veya hızlı giriş',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.lightMutedForeground,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.lightBorder)),
                ],
              ),
              const SizedBox(height: AppSpacing.p24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.apple),
                  const SizedBox(width: 20),
                  _buildSocialIcon(Icons.g_mobiledata, isGoogle: true),
                  const SizedBox(width: 20),
                  _buildSocialIcon(
                    Icons.face_retouching_natural_outlined,
                    isAnonym: true,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.p40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightInputBg,
        borderRadius: AppRadius.input,
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.lightMutedForeground.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            icon,
            color: AppColors.lightMutedForeground,
            size: 20,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.lightMutedForeground,
                    size: 20,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return InkWell(
      onTap: () => context.go('/'),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.lightMuted.withValues(alpha: 0.3),
          borderRadius: AppRadius.button,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hesap Oluştur',
              style: AppTextStyles.label.copyWith(
                color: AppColors.lightMutedForeground.withValues(alpha: 0.5),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward,
              color: AppColors.lightMutedForeground.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(
    IconData icon, {
    bool isGoogle = false,
    bool isAnonym = false,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.mainCard,
        border: Border.all(color: AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: AppColors.lightForeground,
        size: isGoogle ? 32 : 24,
      ),
    );
  }
}
