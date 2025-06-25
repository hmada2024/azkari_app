// lib/features/tasbih/widgets/active_tasbih_view.dart
import 'package:azkari_app/core/utils/size_config.dart';
import 'package:azkari_app/data/models/tasbih_model.dart';
import 'package:flutter/material.dart';

class ActiveTasbihView extends StatelessWidget {
  final TasbihModel activeTasbih;
  const ActiveTasbihView({super.key, required this.activeTasbih});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(SizeConfig.getResponsiveSize(16)),
      decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(SizeConfig.getResponsiveSize(12)),
          border: Border.all(color: theme.dividerColor)),
      child: Text(
        activeTasbih.text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Amiri',
          fontSize: SizeConfig.getResponsiveSize(20),
          color: theme.textTheme.bodyLarge?.color,
          height: 1.7,
        ),
      ),
    );
  }
}
