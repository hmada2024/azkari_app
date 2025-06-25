import 'package:azkari_app/features/adhkar_list/widgets/adhkar_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteAdhkarAsync = ref.watch(favoriteAdhkarProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'),
      ),
      body: favoriteAdhkarAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('خطأ: $error')),
        data: (adhkarList) {
          if (adhkarList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'لم تقم بإضافة أي ذكر إلى المفضلة بعد',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: adhkarList.length,
            itemBuilder: (context, index) {
              final adhkar = adhkarList[index];
              return AdhkarCard(adhkar: adhkar);
            },
          );
        },
      ),
    );
  }
}
