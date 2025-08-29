import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'product_form_screen.dart'; // For editing product details

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product _currentProduct; // Make it mutable for stock changes
  bool _isUpdatingStock = false;

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product; // Initialize with the passed product
  }

  Future<void> _handleStockUpdate() async {
    setState(() {
      _isUpdatingStock = true;
    });
    try {
      await ApiService().updateStock(_currentProduct.id, _currentProduct.newStockLevel);
      _showSnackBar('${_currentProduct.name} stock updated successfully!');
      // Update the 'stock' property to reflect the saved 'newStockLevel'
      // This is crucial to keep the UI consistent if we don't refetch
      setState(() {
        _currentProduct = Product(
          id: _currentProduct.id,
          name: _currentProduct.name,
          description: _currentProduct.description,
          imageUrl: _currentProduct.imageUrl,
          price: _currentProduct.price,
          stock: _currentProduct.newStockLevel, // Update actual stock
          newStockLevel: _currentProduct.newStockLevel, // Keep newStockLevel consistent
        );
      });
      Navigator.of(context).pop(true); // Pop with true to indicate a change
    } catch (e) {
      _showSnackBar('Error updating stock: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingStock = false;
        });
      }
    }
  }

  Future<void> _deleteProduct() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${_currentProduct.name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await ApiService().deleteProduct(_currentProduct.id);
        _showSnackBar('${_currentProduct.name} deleted successfully!');
        Navigator.of(context).pop(true); // Pop with true to indicate a change
      } catch (e) {
        _showSnackBar('Error deleting product: $e', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String fullImageUrl = ApiService.baseMediaUrl + (_currentProduct.imageUrl ?? '');
    final bool hasStockChanged = _currentProduct.stock != _currentProduct.newStockLevel;

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentProduct.name),
        actions: [
          // Edit Product Button
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProductFormScreen(product: _currentProduct)),
              );
              if (result == true) {
                // If product was updated in form, refetch it or update state
                // For simplicity, we'll pop and let the inventory screen refetch.
                Navigator.of(context).pop(true); 
              }
            },
            tooltip: 'Edit Product',
          ),
          // Delete Product Button
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteProduct,
            tooltip: 'Delete Product',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: (_currentProduct.imageUrl != null && _currentProduct.imageUrl!.isNotEmpty)
                    ? Image.network(
                        fullImageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          width: double.infinity,
                          color: Theme.of(context).cardColor,
                          child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                        ),
                      )
                    : Container(
                        height: 200,
                        width: double.infinity,
                        color: Theme.of(context).cardColor,
                        child: const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Product Name
            Text(
              _currentProduct.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Product Description
            Text(
              _currentProduct.description ?? 'No description available.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(0.8)),
            ),
            const SizedBox(height: 24),

            // Price and Current Stock
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoChip(context, Icons.currency_rupee, 'Price', '₹${_currentProduct.price.toStringAsFixed(2)}'),
                _buildInfoChip(context, Icons.storage, 'Current Stock', '${_currentProduct.stock} units', highlight: hasStockChanged),
              ],
            ),
            const SizedBox(height: 24),

            // Stock Level Controls
            Text('Adjust Stock Level', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 30),
                      onPressed: _currentProduct.newStockLevel > 0
                          ? () => setState(() => _currentProduct.newStockLevel--)
                          : null,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      '${_currentProduct.newStockLevel}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: hasStockChanged ? Colors.greenAccent : Colors.white,
                          ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.add_circle, size: 30),
                      onPressed: () => setState(() => _currentProduct.newStockLevel++),
                      color: Colors.greenAccent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Update Stock Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: hasStockChanged && !_isUpdatingStock ? _handleStockUpdate : null,
                icon: _isUpdatingStock ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                ) : const Icon(Icons.save),
                label: Text(_isUpdatingStock ? 'Saving...' : 'Update Stock'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasStockChanged ? Colors.orange : Colors.grey, // Orange when changed, grey when not
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label, String value, {bool highlight = false}) {
    return Card(
      margin: EdgeInsets.zero,
      color: Theme.of(context).cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.grey.shade400, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.6))),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: highlight ? Colors.amberAccent : null, // Highlight if stock changed
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}