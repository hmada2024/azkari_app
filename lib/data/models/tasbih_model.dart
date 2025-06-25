// lib/data/models/tasbih_model.dart

class TasbihModel {
  final int id;
  final String text;
  final int sortOrder;

  TasbihModel({
    required this.id,
    required this.text,
    required this.sortOrder,
  });

  // Factory constructor لإنشاء نسخة من الخريطة (صف قاعدة البيانات)
  factory TasbihModel.fromMap(Map<String, dynamic> map) {
    return TasbihModel(
      id: map['id'],
      text: map['text'],
      sortOrder: map['sort_order'],
    );
  }
}