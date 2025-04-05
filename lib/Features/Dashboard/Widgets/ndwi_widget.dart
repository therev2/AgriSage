import 'package:flutter/material.dart';
import 'package:agrisage/Features/Dashboard/Widgets/dashboard_card.dart';

class NdwiWidget extends StatelessWidget {
  const NdwiWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'NDWI Analysis',
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
        height: 415, // Fixed height to match NDVI card
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Normalized Difference Water Index',
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
                'lib/assets/Dashboard/ndwi_range.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIndexIndicator('Very Dry', Colors.red),
                _buildIndexIndicator('Dry', Colors.orange),
                _buildIndexIndicator('Medium', Colors.lightBlue),
                _buildIndexIndicator('Wet', Colors.blue),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'NDWI measures water content in vegetation and soil. Higher values indicate more water content.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // View detailed NDWI report
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
