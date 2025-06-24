import 'package:azkari_app/core/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:azkari_app/data/models/adhkar_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// تم تحويل الويدجت إلى ConsumerStatefulWidget ليتمكن من إدارة حالته الخاصة (العداد)
// وفي نفس الوقت يقرأ من الـ providers (مثل إعدادات حجم الخط)
class AdhkarCard extends ConsumerStatefulWidget {
  final AdhkarModel adhkar;

  const AdhkarCard({super.key, required this.adhkar});

  @override
  ConsumerState<AdhkarCard> createState() => _AdhkarCardState();
}

class _AdhkarCardState extends ConsumerState<AdhkarCard> {
  late int _currentCount;
  late int _initialCount;

  @override
  void initState() {
    super.initState();
    _currentCount = widget.adhkar.count;
    _initialCount = widget.adhkar.count > 0 ? widget.adhkar.count : 1; // تجنب القسمة على صفر
  }

  void _decrementCount() {
    if (_currentCount > 0) {
      setState(() {
        _currentCount--;
      });
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFinished = _currentCount == 0;
    final theme = Theme.of(context);
    final double progress = (_initialCount - _currentCount) / _initialCount;
    
    // قراءة مقياس حجم الخط من provider الإعدادات
    final double fontScale = ref.watch(settingsProvider.select((s) => s.fontScale));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      clipBehavior: Clip.antiAlias, // لضمان تطبيق الزوايا الدائرية على المحتوى
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              widget.adhkar.text,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20 * fontScale, // تطبيق حجم الخط المعدل
                height: 1.8,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
          
          // استخدام ExpansionTile لعرض التفاصيل الإضافية عند الحاجة
          if ((widget.adhkar.virtue != null && widget.adhkar.virtue!.isNotEmpty) ||
              (widget.adhkar.note != null && widget.adhkar.note!.isNotEmpty))
            Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                title: Text(
                  "الفضل والملاحظات",
                  style: TextStyle(color: theme.primaryColor, fontSize: 14),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.adhkar.virtue != null && widget.adhkar.virtue!.isNotEmpty)
                          Text(widget.adhkar.virtue!, textAlign: TextAlign.right, style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic)),
                        if (widget.adhkar.note != null && widget.adhkar.note!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(widget.adhkar.note!, textAlign: TextAlign.right, style: TextStyle(color: Colors.grey[700])),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 8),

          // زر العداد الجديد مع مؤشر التقدم
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: _decrementCount,
              child: Container(
                height: 55,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: theme.scaffoldBackgroundColor,
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // شريط التقدم الذي يملأ الخلفية
                    Positioned.fill(
                      child: FractionallySizedBox(
                        alignment: Alignment.centerRight,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: isFinished ? Colors.green.withOpacity(0.7) : Colors.teal.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                    // نص العداد
                    Text(
                      _currentCount.toString(),
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}