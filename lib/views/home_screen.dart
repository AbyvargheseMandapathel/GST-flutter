import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false, // Hide back button for main tab
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Alerts Section ---
            Text('Alerts', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildAlertCard(
              context,
              'Low Stock: Organic Apples',
              '12 units remaining',
              'http://localhost:8000/media/products/apples.jpeg', // Example image URL
            ),
            const SizedBox(height: 12),
            _buildAlertCard(
              context,
              'Low Stock: Almond Milk',
              '8 units remaining',
              'http://localhost:8000/media/products/almond_milk.jpeg', // Example image URL
            ),
            const SizedBox(height: 24),

            // --- Recent Activity Section ---
            Text('Recent Activity', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildActivityCard(context, 'Received: Organic Apples', '10 units', '1h ago', Icons.add_circle_outline),
            const SizedBox(height: 12),
            _buildActivityCard(context, 'Sold: Almond Milk', '5 units', '3h ago', Icons.remove_circle_outline),
            const SizedBox(height: 24),

            // --- Inventory Summary ---
            Text('Inventory Summary', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(context, 'Total Items', '250', Icons.category_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(context, 'Total Value', '₹5,000', Icons.currency_rupee), // INR
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSummaryCard(context, 'Items Sold Today', '50', Icons.trending_up),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, String title, String subtitle, String imageUrl) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 40, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.7))),
                ],
              ),
            ),
            const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, String title, String units, String time, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.greenAccent, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(units, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.7))),
                ],
              ),
            ),
            Text(time, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.5))),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.greenAccent, size: 30),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}