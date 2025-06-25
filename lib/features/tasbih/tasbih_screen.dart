// lib/features/tasbih/tasbih_screen.dart

import 'package:azkari_app/core/utils/size_config.dart'; // ✨ استيراد جديد
import 'package:azkari_app/data/models/tasbih_model.dart';
import 'package:azkari_app/features/tasbih/tasbih_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasbihScreen extends ConsumerWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✨ تهيئة أبعاد الشاشة في بداية البناء
    SizeConfig().init(context);

    final tasbihState = ref.watch(tasbihStateProvider);
    final tasbihNotifier = ref.read(tasbihStateProvider.notifier);
    final tasbihListAsync = ref.watch(tasbihListProvider);

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: tasbihListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (tasbihList) {
          final activeTasbih = tasbihList.firstWhere(
            (t) => t.id == tasbihState.activeTasbihId,
            orElse: () => tasbihList.isNotEmpty
                ? tasbihList.first
                : TasbihModel(
                    id: -1,
                    text: 'اختر ذكرًا للبدء من القائمة',
                    sortOrder: 0,
                    isDeletable: false),
          );

          return SafeArea(
            // ✨ إضافة SafeArea لتجنب التداخل مع عناصر النظام
            child: Padding(
              // ✨ استخدام قيم متجاوبة للهوامش
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 0.05),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround, // ✨ تعديل التوزيع
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- منطقة التحكم والأزرار ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildControlButton(
                        context: context,
                        icon: Icons.list_alt_rounded,
                        tooltip: 'اختيار الذكر',
                        onPressed: () {
                          _showTasbihSelectionSheet(context, ref, tasbihList,
                              tasbihState.usedTodayIds);
                        },
                      ),
                      Text(
                        'السبحة',
                        style: TextStyle(
                          fontSize: SizeConfig.getResponsiveSize(22),
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      _buildControlButton(
                        context: context,
                        icon: Icons.refresh,
                        tooltip: 'تصفير العداد',
                        onPressed: tasbihNotifier.resetCount,
                      ),
                    ],
                  ),

                  // --- منطقة عرض الذكر ---
                  Container(
                    padding:
                        EdgeInsets.all(SizeConfig.getResponsiveSize(16)), // ✨
                    decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(
                            SizeConfig.getResponsiveSize(12)), // ✨
                        border: Border.all(color: theme.dividerColor)),
                    child: Text(
                      activeTasbih.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: SizeConfig.getResponsiveSize(20), // ✨
                        color: theme.textTheme.bodyLarge?.color,
                        height: 1.7,
                      ),
                    ),
                  ),

                  // --- منطقة العداد وزر التسبيح مدمجة ---
                  GestureDetector(
                    onTap: () {
                      if (tasbihState.activeTasbihId == null &&
                          tasbihList.isNotEmpty) {
                        tasbihNotifier.setActiveTasbih(tasbihList.first.id);
                      }
                      tasbihNotifier.increment();
                      HapticFeedback.lightImpact();
                    },
                    child: Container(
                      // ✨ استخدام نسبة من عرض الشاشة للحجم
                      width: SizeConfig.screenWidth * 0.6,
                      height: SizeConfig.screenWidth * 0.6,
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: theme.primaryColor.withOpacity(0.5),
                            width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          tasbihState.count.toString(),
                          style: TextStyle(
                            // ✨ استخدام getResponsiveSize
                            fontSize: SizeConfig.getResponsiveSize(75),
                            fontWeight: FontWeight.bold,
                            color:
                                isDarkMode ? Colors.white : theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox.shrink(), // لإدارة المسافات
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ✨ ويدجت مساعد لإنشاء الأزرار العلوية
  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: EdgeInsets.all(SizeConfig.getResponsiveSize(10)),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.cardColor,
              border: Border.all(color: theme.dividerColor.withOpacity(0.5))),
          child: Icon(
            icon,
            color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
            size: SizeConfig.getResponsiveSize(24),
          ),
        ),
      ),
    );
  }

  // دالة عرض القائمة المنبثقة (لم تتغير وظيفتها الأساسية)
  void _showTasbihSelectionSheet(BuildContext context, WidgetRef ref,
      List<TasbihModel> tasbihList, Set<int> usedTodayIds) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            expand: false,
            builder: (_, scrollController) {
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
                            Navigator.pop(context);
                            _showAddTasbihDialog(context, ref);
                          },
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: tasbihList.length,
                      itemBuilder: (context, index) {
                        final tasbih = tasbihList[index];
                        final wasUsedToday = usedTodayIds.contains(tasbih.id);
                        return ListTile(
                          title: Text(tasbih.text,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (wasUsedToday)
                                const Icon(Icons.check_circle,
                                    color: Colors.green, size: 20),
                              if (wasUsedToday && tasbih.isDeletable)
                                const SizedBox(width: 8),
                              if (tasbih.isDeletable)
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(Icons.delete_outline,
                                      color: Colors.red.shade400),
                                  tooltip: 'حذف الذكر',
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _showDeleteConfirmationDialog(
                                        context, ref, tasbih);
                                  },
                                ),
                            ],
                          ),
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
            });
      },
    );
  }

  // الدوال المساعدة للحذف والإضافة (تبقى كما هي)
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

  void _showDeleteConfirmationDialog(
      BuildContext context, WidgetRef ref, TasbihModel tasbih) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content:
              Text('هل أنت متأكد من رغبتك في حذف "${tasbih.text}" بشكل نهائي؟'),
          actions: [
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () => Navigator.pop(context),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('حذف'),
              onPressed: () {
                ref.read(tasbihStateProvider.notifier).deleteTasbih(tasbih.id);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
