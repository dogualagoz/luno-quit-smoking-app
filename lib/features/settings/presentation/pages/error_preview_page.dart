import 'package:flutter/material.dart';
import 'package:luno_quit_smoking_app/core/widgets/luno_error_widget.dart';

class ErrorPreviewPage extends StatefulWidget {
  const ErrorPreviewPage({super.key});

  @override
  State<ErrorPreviewPage> createState() => _ErrorPreviewPageState();
}

class _ErrorPreviewPageState extends State<ErrorPreviewPage> {
  bool _isLoading = false;

  void _simulateRetry() async {
    setState(() => _isLoading = true);
    
    // 1.5 saniye yükleme simüle et
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hata Ekranı Simülasyonu")),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Veriler tazeleniyor..."),
                ],
              ),
            )
          : LunoErrorWidget(
              onRetry: _simulateRetry,
            ),
    );
  }
}

