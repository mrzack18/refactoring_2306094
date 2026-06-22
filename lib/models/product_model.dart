import 'dart:convert';

class ProductModel {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  ProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'].toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  String toJson() => jsonEncode(toMap());
  factory ProductModel.fromJson(String source) {
    return ProductModel.fromMap(jsonDecode(source));
  }

  @override
  String toString() {
    return 'ProductModel{name: $name, description: $description, price: $price, imageUrl: $imageUrl}';
  }
}
