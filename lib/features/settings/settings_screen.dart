import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azkari_app/core/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // قسم المظهر
          Text(
            'المظهر',
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('فاتح'),
                  value: ThemeMode.light,
                  groupValue: settings.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      settingsNotifier.updateTheme(value);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('داكن'),
                  value: ThemeMode.dark,
                  groupValue: settings.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      settingsNotifier.updateTheme(value);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('حسب النظام'),
                  value: ThemeMode.system,
                  groupValue: settings.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      settingsNotifier.updateTheme(value);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // قسم حجم الخط
          Text(
            'حجم الخط',
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'سبحان الله وبحمده، سبحان الله العظيم',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 20 * settings.fontScale, // تطبيق حجم الخط
                    ),
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: settings.fontScale,
                    min: 0.8, // 80%
                    max: 1.5, // 150%
                    divisions: 7, // عدد النقاط على الشريط
                    label: '${(settings.fontScale * 100).toStringAsFixed(0)}%',
                    onChanged: (value) {
                      settingsNotifier.updateFontScale(value);
                    },
                    activeColor: theme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}