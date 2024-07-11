class Cafe {
  final int id;
  final String name;

  Cafe({
    required this.id,
    required this.name,
  });

  factory Cafe.fromJson(Map<String, dynamic> json) {
    return Cafe(
      id: json['id'],
      name: json['name'],
    );
  }
}
