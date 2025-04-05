import 'package:flutter/material.dart';
import 'package:agrisage/Features/Dashboard/Widgets/dashboard_card.dart';
import 'package:agrisage/ColorPage.dart';

class AnalyticsWidget extends StatelessWidget {
  const AnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Farm Analytics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Time period selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Text(
                  'Time Period:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: 'This Year',
                  items: const [
                    DropdownMenuItem(
                        value: 'This Month', child: Text('This Month')),
                    DropdownMenuItem(
                        value: 'This Quarter', child: Text('This Quarter')),
                    DropdownMenuItem(
                        value: 'This Year', child: Text('This Year')),
                    DropdownMenuItem(value: 'Custom', child: Text('Custom')),
                  ],
                  onChanged: (value) {
                    // Change time period
                  },
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () {
                    // Export analytics
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Export'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Yield analytics
          DashboardCard(
            title: 'Yield Analysis',
            child: Container(
              height: 350,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildAnalyticsStat(
                          'Total Production', '246 tons', Colors.blue),
                      const SizedBox(width: 16),
                      _buildAnalyticsStat(
                          'Avg. Yield', '4.2 tons/ha', Colors.green),
                      const SizedBox(width: 16),
                      _buildAnalyticsStat('YoY Change', '+8.5%', Colors.orange),
                    ],
                  ),
                  SizedBox(
                    height: 198,
                    width: double.infinity,
                    child: Image.asset(
                      'lib/assets/Dashboard/farm_analytics.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Financial analytics
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildCostAnalyticsCard(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildRevenueAnalyticsCard(),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildCostAnalyticsCard(),
                    const SizedBox(height: 16),
                    _buildRevenueAnalyticsCard(),
                  ],
                ),

          const SizedBox(height: 24),

          // Resource usage
          DashboardCard(
            title: 'Resource Usage Analytics',
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildResourceUsageItem('Water', '2450 m³', '−5%', true),
                      _buildResourceUsageItem(
                          'Fertilizer', '850 kg', '−2%', true),
                      _buildResourceUsageItem(
                          'Pesticides', '120 L', '−7%', true),
                      _buildResourceUsageItem('Fuel', '340 L', '+3%', false),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Placeholder(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Field performance
          DashboardCard(
            title: 'Field Performance Comparison',
            child: Container(
              height: 400,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildMetricChip('Yield', true),
                        _buildMetricChip('NDVI', false),
                        _buildMetricChip('Water Usage', false),
                        _buildMetricChip('Input Costs', false),
                        _buildMetricChip('Profitability', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(height: 300, child: Placeholder()),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Performance insights
          DashboardCard(
            title: 'Performance Insights',
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInsightItem(
                    'High Performance',
                    'North Field wheat crop showed 12% higher yield than average, likely due to optimal irrigation timing.',
                    Icons.trending_up,
                    Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildInsightItem(
                    'Improvement Area',
                    'South Field corn had 8% lower yield. Soil analysis suggests increasing potassium levels may help.',
                    Icons.trending_down,
                    Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  _buildInsightItem(
                    'Cost Efficiency',
                    'Precision fertilizer application reduced input costs by 9% while maintaining yield levels.',
                    Icons.savings,
                    Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      // View full report
                    },
                    child: const Text('View Full Analytics Report'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostAnalyticsCard() {
    return DashboardCard(
      title: 'Cost Analysis',
      child: Container(
        // height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildAnalyticsStat('Total Costs', '\$48,250', Colors.red),
                const SizedBox(width: 16),
                _buildAnalyticsStat('Cost/Hectare', '\$960', Colors.orange),
              ],
            ),
            // const SizedBox(height: 24),
            // const Text(
            //   'Cost Breakdown',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // SizedBox(height: 130, child: Placeholder()),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueAnalyticsCard() {
    return DashboardCard(
      title: 'Revenue Analysis',
      child: Container(
        // height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildAnalyticsStat('Total Revenue', '\$72,500', Colors.green),
                const SizedBox(width: 16),
                _buildAnalyticsStat('Net Profit', '\$24,250', Colors.blue),
              ],
            ),
            // const SizedBox(height: 24),
            // const Text(
            //   'Revenue by Crop',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // SizedBox(height: 130, child: Placeholder()),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceUsageItem(
      String resource, String amount, String change, bool isPositive) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resource,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                size: 12,
                color: isPositive ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          // Toggle selection
        },
        backgroundColor: Colors.grey[200],
        selectedColor: ColorPage.primaryColor.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? ColorPage.primaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildInsightItem(
      String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
