import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luno_quit_smoking_app/core/theme/app_colors.dart';
import 'package:luno_quit_smoking_app/core/theme/app_text_styles.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_card.dart';
import 'package:luno_quit_smoking_app/features/auth/presentation/controllers/auth_controller.dart';

/// Sign-out + delete-account actions card at the bottom of settings.
class AccountActionsCard extends ConsumerWidget {
  const AccountActionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LunoCard(
      child: Column(
        children: [
          ListTile(
            onTap: () => _confirmSignOut(context, ref),
            leading: Icon(
              Icons.logout_rounded,
              color: AppColors.lightDestructive.withValues(alpha: 0.8),
            ),
            title: Text(
              'Çıkış Yap',
              style: AppTextStyles.body.copyWith(
                color: AppColors.lightDestructive,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, size: 20),
            contentPadding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () => _confirmDeleteAccount(context, ref),
            leading: Icon(
              Icons.delete_forever_rounded,
              color: AppColors.lightDestructive.withValues(alpha: 0.8),
            ),
            title: Text(
              'Hesabı Sil',
              style: AppTextStyles.body.copyWith(
                color: AppColors.lightDestructive,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, size: 20),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış yap?'),
        content: const Text('Oturumu kapatmak istediğine emin misin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Çıkış Yap',
              style: TextStyle(color: AppColors.lightDestructive),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
  }

  Future<void> _confirmDeleteAccount(
      BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hesabı Kalıcı Olarak Sil?'),
        content: const Text(
          'Tüm verilerin ve hesabın kalıcı olarak silinecektir. Bu işlem geri alınamaz. Onaylıyor musun?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Hesabı Sil',
              style: TextStyle(color: AppColors.lightDestructive),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(authControllerProvider.notifier).deleteAccount();
      final authState = ref.read(authControllerProvider);
      if (authState.hasError && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Güvenlik için lütfen çıkış yapıp tekrar giriş yaptıktan sonra hesabı silmeyi deneyin.',
            ),
            backgroundColor: AppColors.lightDestructive,
          ),
        );
      }
    }
  }
}
