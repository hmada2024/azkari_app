import 'package:azkari_app/data/models/adhkar_model.dart';
import 'package:azkari_app/data/repositories/adhkar_repository.dart';
import 'package:azkari_app/data/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider 1: يوفر نسخة واحدة من DatabaseHelper
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

// Provider 2: يوفر نسخة واحدة من المستودع (Repository) ويعتمد على Provider 1
final adhkarRepositoryProvider = Provider<AdhkarRepository>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return AdhkarRepository(dbHelper);
});

// Provider 3: يجلب الأذكار حسب التصنيف (يعتمد الآن على المستودع)
final adhkarByCategoryProvider = FutureProvider.family<List<AdhkarModel>, String>((ref, category) async {
  final repository = ref.read(adhkarRepositoryProvider);
  return repository.getAdhkarByCategory(category);
});

// Provider 4: يجلب قائمة الفئات (يعتمد الآن على المستودع)
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.read(adhkarRepositoryProvider);
  return repository.getCategories();
});