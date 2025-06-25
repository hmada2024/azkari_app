// lib/features/tasbih/tasbih_screen.dart

import 'package:azkari_app/features/tasbih/tasbih_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasbihScreen extends ConsumerWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. الوصول لبيانات الحالة والثيم وأبعاد الشاشة
    final count = ref.watch(tasbihProvider);
    final tasbihNotifier = ref.read(tasbihProvider.notifier);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // 2. تجميع منطق تحديد الألوان والنصوص في مكان واحد
    final Color counterTextColor, counterBorderColor;
    final Color buttonTextColor, buttonBgColor;
    final String buttonText;

    if (isDarkMode) {
      // إعدادات الوضع الليلي
      buttonText = 'اضغط للعد';
      buttonTextColor = Colors.black;
      buttonBgColor = Colors.white;
      counterTextColor = Colors.white;
      counterBorderColor = Colors.white.withOpacity(0.8);
    } else {
      // إعدادات الوضع الفاتح
      buttonText = 'سبّح';
      buttonTextColor = Colors.white;
      buttonBgColor = theme.primaryColor;
      counterTextColor = theme.primaryColor;
      counterBorderColor = theme.primaryColor;
    }

    // 3. تحديد المقاسات النسبية
    final double counterCircleSize = screenWidth * 0.45;
    final double buttonCircleSize = screenWidth * 0.48;
    final double counterFontSize = counterCircleSize * 0.4;
    final double buttonFontSize = buttonCircleSize * 0.15;

    return Scaffold(
      appBar: AppBar(
        title: const Text('السبحة الإلكترونية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'إعادة التعيين',
            onPressed: tasbihNotifier.reset,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // استخدام الدالة المساعدة لبناء دائرة العداد
            _buildCircleWidget(
              size: counterCircleSize,
              borderColor: counterBorderColor,
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: counterFontSize,
                  fontWeight: FontWeight.bold,
                  color: counterTextColor,
                ),
              ),
            ),

            // استخدام نفس الدالة المساعدة لبناء زر التسبيح
            GestureDetector(
              onTap: () {
                tasbihNotifier.increment();
                HapticFeedback.lightImpact();
              },
              child: _buildCircleWidget(
                size: buttonCircleSize,
                backgroundColor: buttonBgColor,
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: buttonTextColor,
                    fontSize: buttonFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة جديدة لإنشاء الويدجت الدائري ✨✨✨
  Widget _buildCircleWidget({
    required double size,
    required Widget child,
    Color? backgroundColor, // قد لا يكون له لون خلفية (مثل العداد)
    Color?
        borderColor, // قد لا يكون له إطار (على الرغم من أننا نستخدمه في كليهما)
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        // إضافة الإطار فقط إذا تم توفير لونه
        border: borderColor != null
            ? Border.all(color: borderColor, width: 3)
            : null,
        boxShadow: backgroundColor != null
            ? [
                // إضافة الظل فقط إذا كان هناك لون خلفية
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Center(child: child),
    );
  }
}
