import 'package:flutter/material.dart';
import 'package:agrisage/Features/Dashboard/Widgets/dashboard_card.dart';
import 'package:agrisage/ColorPage.dart';

class PredictionWidget extends StatelessWidget {
  const PredictionWidget({super.key});

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
              'AI Predictions & Insights',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildYieldPredictionCard(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDiseasePredictionCard(),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildYieldPredictionCard(),
                    const SizedBox(height: 16),
                    _buildDiseasePredictionCard(),
                  ],
                ),
          const SizedBox(height: 16),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildDroughtPredictionCard(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildWeatherRiskCard(),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildDroughtPredictionCard(),
                    const SizedBox(height: 16),
                    _buildWeatherRiskCard(),
                  ],
                ),
          const SizedBox(height: 16),
          _buildLLMInsightsCard(),
        ],
      ),
    );
  }

  Widget _buildYieldPredictionCard() {
    return DashboardCard(
      title: 'Yield Prediction',
      trailing: IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          // Refresh predictions
        },
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Predicted yields for current growing season',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildYieldItem('Wheat', 4.7, 'tons/ha', 0.05, true),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildYieldItem('Rice', 3.8, 'tons/ha', -0.02, false),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildYieldItem('Corn', 6.2, 'tons/ha', 0.08, true),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildYieldItem('Soybean', 2.8, 'tons/ha', 0.03, true),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'These predictions are based on current growing conditions, historical data, and weather forecasts.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYieldItem(
      String crop, double yield, String unit, double change, bool isPositive) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            crop,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            children: [
              Text(
                '$yield $unit',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${(change * 100).abs().toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: isPositive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiseasePredictionCard() {
    return DashboardCard(
      title: 'Plant Disease Risk',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current risk assessment for common diseases',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            _buildDiseaseRiskItem('Wheat Rust', 0.75, 'High', 'North Field'),
            const SizedBox(height: 12),
            _buildDiseaseRiskItem('Rice Blast', 0.35, 'Low', 'East Field'),
            const SizedBox(height: 12),
            _buildDiseaseRiskItem('Corn Blight', 0.55, 'Medium', 'South Field'),
            const SizedBox(height: 12),
            _buildDiseaseRiskItem(
                'Soybean Mosaic', 0.2, 'Very Low', 'West Field'),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                // View detailed report
              },
              icon: const Icon(Icons.visibility),
              label: const Text('View Detailed Report'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseRiskItem(
      String disease, double riskLevel, String riskText, String location) {
    Color riskColor;
    if (riskLevel < 0.3) {
      riskColor = Colors.green;
    } else if (riskLevel < 0.6) {
      riskColor = Colors.orange;
    } else {
      riskColor = Colors.red;
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                disease,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: riskLevel,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(riskColor),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      riskText,
                      style: TextStyle(
                        fontSize: 12,
                        color: riskColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${(riskLevel * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: riskColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDroughtPredictionCard() {
    return DashboardCard(
      title: 'Drought Prediction',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Soil moisture forecast for next 30 days',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
                child: Placeholder(),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Drought Risk Assessment',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Low risk of drought conditions in the next 30 days. Current soil moisture levels are adequate, with predicted rainfall sufficient to maintain crop requirements.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherRiskCard() {
    return DashboardCard(
      title: 'Weather Risk Analysis',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildWeatherRiskItem(
                    'Fog & Dew',
                    Icons.cloud,
                    Colors.lightBlue,
                    'Moderate likelihood in early mornings next week.',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildWeatherRiskItem(
                    'Heatwave',
                    Icons.thermostat,
                    Colors.orange,
                    'Low risk for the next 10 days.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildWeatherRiskItem(
                    'Frost',
                    Icons.ac_unit,
                    Colors.blue,
                    'No risk in the current season.',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildWeatherRiskItem(
                    'Heavy Rain',
                    Icons.water_drop,
                    Colors.indigo,
                    'Moderate chance in 5-7 days.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Weather Alert',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: const Text(
                'Potential thunderstorms with strong winds expected in 3 days. Consider delaying any planned spraying operations.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherRiskItem(
      String title, IconData icon, Color color, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildLLMInsightsCard() {
    return DashboardCard(
      title: 'AI Assistant Insights',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorPage.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: ColorPage.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Gemini AI Analysis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInsightItem(
              'Crop Rotation Recommendation',
              'Based on soil tests and crop history, consider rotating to legumes next season in the North field to improve nitrogen fixation.',
            ),
            const SizedBox(height: 12),
            _buildInsightItem(
              'Market Trend Analysis',
              'Wheat prices are projected to increase by 5-8% in the next quarter due to global supply constraints.',
            ),
            const SizedBox(height: 12),
            _buildInsightItem(
              'Resource Optimization',
              'Current irrigation efficiency is 72%. Implementing drip irrigation could improve efficiency by 15% and reduce water costs.',
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: 'Ask AI for farming insights...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Submit question to AI
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
