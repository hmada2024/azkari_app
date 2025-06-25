// lib/features/tasbih/tasbih_screen.dart

import 'package:azkari_app/features/tasbih/tasbih_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasbihScreen extends ConsumerWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. الوصول لبيانات الحالة والثيم
    final count = ref.watch(tasbihProvider);
    final tasbihNotifier = ref.read(tasbihProvider.notifier);
    final theme = Theme.of(context);
    // التحقق من وضع السطوع الحالي (فاتح أم داكن)
    final isDarkMode = theme.brightness == Brightness.dark;
    // الحصول على أبعاد الشاشة
    final screenWidth = MediaQuery.of(context).size.width;


    // 2. تحديد الألوان والنصوص بناءً على الثيم
    // الألوان في الوضع الليلي
    const Color darkButtonTextColor = Colors.black;
    const Color darkButtonBgColor = Colors.white;
    final Color darkCounterBorderColor = Colors.white.withOpacity(0.8);
    const Color darkCounterTextColor = Colors.white;

    // الألوان في الوضع الفاتح
    const Color lightButtonTextColor = Colors.white;
    final Color lightButtonBgColor = theme.primaryColor;
    final Color lightCounterBorderColor = theme.primaryColor;
    final Color lightCounterTextColor = theme.primaryColor;

    // تحديد النصوص
    final String buttonText = isDarkMode ? 'اضغط للعد' : 'سبّح';
    

    // 3. استخدام النسب المئوية للمقاسات
    // حجم دائرة العداد سيكون 40% من عرض الشاشة
    final double counterCircleSize = screenWidth * 0.45;
    // حجم زر التسبيح سيكون 45% من عرض الشاشة
    final double buttonCircleSize = screenWidth * 0.48;
    // حجم خط العداد سيكون 20% من حجم الدائرة نفسها
    final double counterFontSize = counterCircleSize * 0.4;
    // حجم خط زر التسبيح سيكون 15% من حجم الدائرة نفسها
    final double buttonFontSize = buttonCircleSize * 0.15;


    return Scaffold(
      appBar: AppBar(
        title: const Text('السبحة الإلكترونية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'إعادة التعيين',
            onPressed: () => tasbihNotifier.reset(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          // استخدام MainAxisAlignment.spaceEvenly لتوزيع المسافات بشكل أفضل
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // عرض العداد (بمقاسات نسبية وألوان متغيرة)
            Container(
              width: counterCircleSize,
              height: counterCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  // استخدام الألوان المحددة بناءً على الثيم
                  color: isDarkMode ? darkCounterBorderColor : lightCounterBorderColor,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: counterFontSize,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? darkCounterTextColor : lightCounterTextColor,
                  ),
                ),
              ),
            ),

            // زر التسبيح الرئيسي (بمقاسات نسبية وألوان متغيرة)
            GestureDetector(
              onTap: () {
                tasbihNotifier.increment();
                HapticFeedback.lightImpact();
              },
              child: Container(
                width: buttonCircleSize,
                height: buttonCircleSize,
                decoration: BoxDecoration(
                  // استخدام الألوان المحددة بناءً على الثيم
                  color: isDarkMode ? darkButtonBgColor : lightButtonBgColor,
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
                child: Center(
                  child: Text(
                    buttonText, // استخدام النص المحدد بناءً على الثيم
                    style: TextStyle(
                      color: isDarkMode ? darkButtonTextColor : lightButtonTextColor,
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}