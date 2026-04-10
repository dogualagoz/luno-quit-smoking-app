import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/speech_bubble.dart';
import 'controllers/auth_controller.dart';
import '../../../core/utils/error_translator.dart';

class EmailLoginScreen extends ConsumerStatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  ConsumerState<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends ConsumerState<EmailLoginScreen> {
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
    final authState = ref.watch(authControllerProvider);

    // Hataları dinleyip kullanıcıya gösteriyoruz
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorTranslator.translate(next.error)),
            backgroundColor: AppColors.lightDestructive,
          ),
        );
      }
    });
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
              Center(
                child: SvgPicture.asset(
                  AssetConstants.cigeritoDefault,
                  height: 100,
                ),
              ),
              const SizedBox(height: AppSpacing.p12),
              const SpeechBubble(
                text: "E-posta ile giriş yap, verilerini her yerden takip et!",
              ),
              const SizedBox(height: AppSpacing.p24),

              // Başlıklar
              Text(
                'Giriş Yap',
                style: AppTextStyles.pageHeader.copyWith(
                  color: AppColors.lightForeground,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'E-posta ve şifreni gir',
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
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Şifremi unuttum',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.lightPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildLoginButton(authState.isLoading),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.p24),

              // Kayıt Ol Linki
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hesabın yok mu? ',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.lightMutedForeground,
                    ),
                  ),
                  InkWell(
                    onTap: () => context.push('/register'),
                    child: Text(
                      'Kayıt ol',
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
                  _buildSocialIcon(Icons.apple, onTap: () {}),
                  const SizedBox(width: 20),
                  _buildSocialIcon(
                    Icons.g_mobiledata,
                    isGoogle: true,
                    onTap: () => ref
                        .read(authControllerProvider.notifier)
                        .signInWithGoogle(),
                  ),
                  const SizedBox(width: 20),
                  _buildSocialIcon(
                    Icons.face_retouching_natural_outlined,
                    isAnonym: true,
                    onTap: () => context.go('/'),
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

  Widget _buildLoginButton(bool isLoading) {
    return InkWell(
      onTap: isLoading
          ? null
          : () {
              if (_emailController.text.isNotEmpty &&
                  _passwordController.text.isNotEmpty) {
                ref
                    .read(authControllerProvider.notifier)
                    .signInWithEmailAndPassword(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
              }
            },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: isLoading
              ? AppColors.lightMuted.withValues(alpha: 0.1)
              : AppColors.lightPrimary,
          borderRadius: AppRadius.button,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else ...[
              Text(
                'Giriş Yap',
                style: AppTextStyles.label.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(
    IconData icon, {
    bool isGoogle = false,
    bool isAnonym = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
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
      ),
    );
  }
}
