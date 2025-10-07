class FoodItem {
  final String id;
  final String name;
  final String category; // e.g., fruits, vegetables, protein
  final String imageUrl; // online picture URL
  final int calories;

  const FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.calories,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'imageUrl': imageUrl,
        'calories': calories,
      };

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        imageUrl: json['imageUrl'] as String,
        calories: json['calories'] as int,
      );
}
