class Drink {
  final int id;
  final String name;
  final double volume;
  final double sugarContent;
  final double calories;
  final double sodiumContent;
  final String imageUrl;
  final int cafeId;

  Drink({
    required this.id,
    required this.name,
    required this.volume,
    required this.sugarContent,
    required this.calories,
    required this.sodiumContent,
    required this.imageUrl,
    required this.cafeId,
  });

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      id: json['id'],
      name: json['name'],
      volume: json['volume'],
      sugarContent: json['sugar_content'],
      calories: json['calories'],
      sodiumContent: json['sodium_content'],
      imageUrl: json['image_url'],
      cafeId: json['cafe_id'],
    );
  }
}
