import 'package:azkari_app/data/models/adhkar_model.dart';
import 'package:azkari_app/features/adhkar_list/adhkar_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. Provider لإدارة قائمة IDs المفضلة
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<int>>((ref) {
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<List<int>> {
  FavoritesNotifier() : super([]) {
    _loadFavorites();
  }

  static const _favoritesKey = 'favorite_adhkar_ids';

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_favoritesKey) ?? [];
    state = favoriteIds.map(int.parse).toList();
  }

  Future<void> toggleFavorite(int adhkarId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentFavorites = List<int>.from(state);

    if (currentFavorites.contains(adhkarId)) {
      currentFavorites.remove(adhkarId);
    } else {
      currentFavorites.add(adhkarId);
    }

    state = currentFavorites;
    await prefs.setStringList(
        _favoritesKey, currentFavorites.map((id) => id.toString()).toList());
  }
}

// 2. Provider لجلب بيانات الأذكار المفضلة كاملة
final favoriteAdhkarProvider = FutureProvider<List<AdhkarModel>>((ref) async {
  final favoriteIds = ref.watch(favoritesProvider);
  final repository = ref.watch(adhkarRepositoryProvider);

  if (favoriteIds.isEmpty) {
    return [];
  }

  return repository.getAdhkarByIds(favoriteIds);
});
