class CompanieModel {
  final String id;
  final String name;

  CompanieModel({
    required this.id,
    required this.name,
  });

  CompanieModel copyWith({
    String? id,
    String? name,
  }) {
    return CompanieModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory CompanieModel.fromJson(Map<String, dynamic> json) {
    return CompanieModel(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
    );
  }
}
