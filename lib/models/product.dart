class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final int stock;
  int selectedQuantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.stock,
    this.selectedQuantity = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id']?.toString() ?? '',
    name: json['name'] as String? ?? 'Unnamed Product',
    description: json['description'] as String? ?? 'No description available',
    imageUrl: json['imageUrl'] as String? ?? 'https://via.placeholder.com/150',
    price: (json['price'] as num? ?? 0.0).toDouble(),
    stock: (json['stock'] as num? ?? 0).toInt(),
    selectedQuantity: 0,
  );
}
}