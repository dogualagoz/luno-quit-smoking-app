import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/theme/app_spacing.dart';

class CigeritoCustomizationPage extends StatelessWidget {
  const CigeritoCustomizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ciğerito Özelleştirme'),
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.pageHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.face_retouching_natural_rounded, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Ciğerito yakında kendi tarzını yansıtacak!\nBu alan yapım aşamasında.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
