// lib/features/tasbih/tasbih_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. مفتاح لحفظ قيمة العداد في الذاكرة الدائمة
const String _tasbihCounterKey = 'tasbih_counter';

// 2. إنشاء StateNotifier لإدارة حالة العداد (وهو مجرد رقم)
class TasbihNotifier extends StateNotifier<int> {
  TasbihNotifier() : super(0) {
    _loadCount(); // تحميل القيمة المحفوظة عند بدء التشغيل
  }

  // دالة خاصة لتحميل العداد من SharedPreferences
  Future<void> _loadCount() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt(_tasbihCounterKey) ?? 0;
  }

  // دالة خاصة لحفظ العداد في SharedPreferences
  Future<void> _saveCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tasbihCounterKey, state);
  }

  // دالة لزيادة العداد بمقدار واحد
  void increment() {
    state++;
    _saveCount(); // حفظ القيمة الجديدة بعد كل زيادة
  }

  // دالة لإعادة تصفير العداد
  void reset() {
    state = 0;
    _saveCount(); // حفظ القيمة الجديدة (صفر)
  }
}

// 3. إنشاء الـ Provider الذي سيتيح لنا الوصول للـ Notifier من أي مكان في التطبيق
final tasbihProvider = StateNotifierProvider<TasbihNotifier, int>((ref) {
  return TasbihNotifier();
});
