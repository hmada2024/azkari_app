// lib/features/tasbih/tasbih_screen.dart

import 'package:azkari_app/features/tasbih/tasbih_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasbihScreen extends ConsumerWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // مشاهدة قيمة العداد الحالية من الـ Provider
    final count = ref.watch(tasbihProvider);
    // الوصول إلى دوال الـ Notifier (increment, reset)
    final tasbihNotifier = ref.read(tasbihProvider.notifier);
    
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('السبحة الإلكترونية'),
        actions: [
          // زر إعادة التعيين في الشريط العلوي
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'إعادة التعيين',
            onPressed: () => tasbihNotifier.reset(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // عرض العداد
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.primaryColor, width: 3),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),

            // زر التسبيح الرئيسي
            GestureDetector(
              onTap: () {
                tasbihNotifier.increment();
                HapticFeedback.lightImpact(); // إضافة اهتزاز عند الضغط
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'اضغط',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50), // مسافة فارغة في الأسفل
          ],
        ),
      ),
    );
  }
}