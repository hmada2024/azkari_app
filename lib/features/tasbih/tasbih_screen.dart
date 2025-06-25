// lib/features/tasbih/tasbih_screen.dart

import 'package:azkari_app/data/models/tasbih_model.dart';
import 'package:azkari_app/features/tasbih/tasbih_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasbihScreen extends ConsumerWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // مراقبة الحالة الكاملة للسبحة
    final tasbihState = ref.watch(tasbihStateProvider);
    final tasbihNotifier = ref.read(tasbihStateProvider.notifier);

    // جلب قائمة التسابيح
    final tasbihListAsync = ref.watch(tasbihListProvider);

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('السبحة الإلكترونية'),
        actions: [
          // زر إعادة تعيين العداد
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تصفير العداد',
            onPressed: tasbihNotifier.resetCount,
          ),
          // زر اختيار الذكر
          IconButton(
            icon: const Icon(Icons.list_alt_rounded),
            tooltip: 'اختيار الذكر',
            onPressed: () {
              tasbihListAsync.whenData((tasbihList) {
                _showTasbihSelectionSheet(
                    context, ref, tasbihList, tasbihState.usedTodayIds);
              });
            },
          ),
        ],
      ),
      body: tasbihListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (tasbihList) {
          // العثور على نص الذكر النشط
          final activeTasbih = tasbihList.firstWhere(
            (t) => t.id == tasbihState.activeTasbihId,
            orElse: () => tasbihList.isNotEmpty
                ? tasbihList.first
                : TasbihModel(id: -1, text: 'اختر ذكرًا للبدء', sortOrder: 0),
          );

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- منطقة عرض الذكر ---
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor)),
                  child: Text(
                    activeTasbih.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 20,
                      color: theme.textTheme.bodyLarge?.color,
                      height: 1.7,
                    ),
                  ),
                ),

                // --- منطقة العداد ---
                Center(
                  child: Text(
                    tasbihState.count.toString(),
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : theme.primaryColor,
                    ),
                  ),
                ),

                // --- زر التسبيح ---
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (tasbihState.activeTasbihId == null &&
                          tasbihList.isNotEmpty) {
                        // تحديد الذكر الأول تلقائيًا إذا لم يتم تحديد أي ذكر
                        tasbihNotifier.setActiveTasbih(tasbihList.first.id);
                      }
                      tasbihNotifier.increment();
                      HapticFeedback.lightImpact();
                    },
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white : theme.primaryColor,
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
                          'سبّح',
                          style: TextStyle(
                            color: isDarkMode ? Colors.black : Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // دالة لعرض القائمة المنبثقة لاختيار الذكر
  void _showTasbihSelectionSheet(BuildContext context, WidgetRef ref,
      List<TasbihModel> tasbihList, Set<int> usedTodayIds) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('اختر من قائمة التسابيح',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        tooltip: 'إضافة ذكر جديد',
                        onPressed: () {
                          Navigator.pop(context); // أغلق الـ bottom sheet أولاً
                          _showAddTasbihDialog(context, ref);
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasbihList.length,
                    itemBuilder: (context, index) {
                      final tasbih = tasbihList[index];
                      final bool wasUsedToday =
                          usedTodayIds.contains(tasbih.id);
                      return ListTile(
                        title: Text(tasbih.text,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: wasUsedToday
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                        onTap: () {
                          ref
                              .read(tasbihStateProvider.notifier)
                              .setActiveTasbih(tasbih.id);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // دالة لعرض نافذة إضافة ذكر جديد
  void _showAddTasbihDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إضافة ذكر جديد'),
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(hintText: 'الصق أو اكتب الذكر هنا...'),
            maxLines: 5,
            minLines: 3,
          ),
          actions: [
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () => Navigator.pop(context),
            ),
            FilledButton(
              child: const Text('إضافة'),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  ref
                      .read(tasbihStateProvider.notifier)
                      .addTasbih(controller.text.trim());
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
