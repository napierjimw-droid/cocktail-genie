import 'dart:convert';

enum BarItemType { favorite, ingredient }

class BarItem {
  final String id;
  final BarItemType type;

  // For favorites — cocktail data
  final String? drinkId;
  final String? drinkName;
  final String? drinkThumb;
  final String? category;
  final String? alcoholic;

  // For ingredients — from camera analysis
  final String? ingredientName;
  final String? brandName;

  final DateTime addedAt;

  BarItem({
    required this.id,
    required this.type,
    required this.addedAt,
    this.drinkId,
    this.drinkName,
    this.drinkThumb,
    this.category,
    this.alcoholic,
    this.ingredientName,
    this.brandName,
  });

  /// Create a favorite from a CocktailDB drink map
  factory BarItem.favorite({
    required String id,
    required String drinkId,
    required String drinkName,
    required String drinkThumb,
    String? category,
    String? alcoholic,
  }) {
    return BarItem(
      id: id,
      type: BarItemType.favorite,
      addedAt: DateTime.now(),
      drinkId: drinkId,
      drinkName: drinkName,
      drinkThumb: drinkThumb,
      category: category,
      alcoholic: alcoholic,
    );
  }

  /// Create an ingredient from camera analysis
  factory BarItem.ingredient({
    required String id,
    required String ingredientName,
    String? brandName,
  }) {
    return BarItem(
      id: id,
      type: BarItemType.ingredient,
      addedAt: DateTime.now(),
      ingredientName: ingredientName,
      brandName: brandName,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'addedAt': addedAt.toIso8601String(),
        'drinkId': drinkId,
        'drinkName': drinkName,
        'drinkThumb': drinkThumb,
        'category': category,
        'alcoholic': alcoholic,
        'ingredientName': ingredientName,
        'brandName': brandName,
      };

  factory BarItem.fromJson(Map<String, dynamic> json) => BarItem(
        id: json['id'] as String,
        type: BarItemType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => BarItemType.favorite,
        ),
        addedAt: DateTime.parse(json['addedAt'] as String),
        drinkId: json['drinkId'] as String?,
        drinkName: json['drinkName'] as String?,
        drinkThumb: json['drinkThumb'] as String?,
        category: json['category'] as String?,
        alcoholic: json['alcoholic'] as String?,
        ingredientName: json['ingredientName'] as String?,
        brandName: json['brandName'] as String?,
      );

  String toJsonString() => jsonEncode(toJson());

  factory BarItem.fromJsonString(String s) =>
      BarItem.fromJson(jsonDecode(s) as Map<String, dynamic>);
}