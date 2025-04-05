import 'package:flutter/material.dart';
import 'package:agrisage/Features/Dashboard/Widgets/dashboard_card.dart';

class NdviWidget extends StatelessWidget {
  const NdviWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'NDVI Analysis',
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          // Handle selection
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'last7days',
            child: Text('Last 7 Days'),
          ),
          const PopupMenuItem<String>(
            value: 'last30days',
            child: Text('Last 30 Days'),
          ),
          const PopupMenuItem<String>(
            value: 'last90days',
            child: Text('Last 90 Days'),
          ),
        ],
      ),
      child: Container(
        height: 415, // Fixed height to match NDWI card
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Normalized Difference Vegetation Index',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.asset(
                'lib/assets/Dashboard/ndvi_range.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIndexIndicator('Low', Colors.red),
                _buildIndexIndicator('Moderate', Colors.yellow),
                _buildIndexIndicator('Good', Colors.lightGreen),
                _buildIndexIndicator('Excellent', Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'NDVI measures vegetation health by analyzing reflected light. Higher values indicate healthier vegetation.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // View detailed NDVI report
              },
              child: const Text('View Detailed Report'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndexIndicator(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
