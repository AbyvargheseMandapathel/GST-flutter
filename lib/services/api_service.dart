import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ApiService {
  final String _baseUrl = 'http://localhost:8000/api/products/';
  // Assuming your Django media files are served from the same domain
  static const String _baseMediaUrl = 'http://localhost:8000'; 
  static String get baseMediaUrl => _baseMediaUrl;

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body);
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  Future<void> updateStock(String id, int newStock) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'stock': newStock}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update stock: ${response.statusCode}');
    }
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productData),
    );
    if (response.statusCode != 201) {
      String errorBody = response.body.isNotEmpty ? response.body : 'No error message from server';
      throw Exception('Failed to add product: ${response.statusCode}. Details: $errorBody');
    }
  }

  Future<void> updateProduct(String id, Map<String, dynamic> productData) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productData),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update product: ${response.statusCode}');
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete product: ${response.statusCode}');
    }
  }
}