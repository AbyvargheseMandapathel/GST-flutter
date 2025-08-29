class Product {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl; // full image URL or null
  final double price;
  final int stock;
  int newStockLevel;

  Product({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price,
    required this.stock,
    required this.newStockLevel,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final currentStock = int.tryParse(json['stock'].toString()) ?? 0;
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'],
      // ✅ handle nulls properly
      imageUrl: (json['image'] != null && json['image'].toString().isNotEmpty)
          ? json['image'].toString()
          : null,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      stock: currentStock,
      newStockLevel: currentStock,
    );
  }
}
