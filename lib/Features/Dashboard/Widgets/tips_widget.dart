import 'package:flutter/material.dart';
import 'package:agrisage/Features/Dashboard/Widgets/dashboard_card.dart';
import 'package:agrisage/ColorPage.dart';

class TipsWidget extends StatelessWidget {
  const TipsWidget({super.key});

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
              'Tips & Recommendations',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Categories
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip('All', true),
                _buildCategoryChip('Crop Management', false),
                _buildCategoryChip('Soil Health', false),
                _buildCategoryChip('Pest Control', false),
                _buildCategoryChip('Water Management', false),
                _buildCategoryChip('Sustainability', false),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Featured tip
          DashboardCard(
            title: 'Recommended For You',
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: Image.asset(
                        'lib/assets/Dashboard/farmland.jpg',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sustainable Farming Practices for Modern Agriculture',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Learn how implementing sustainable practices can improve soil health, increase yields, and reduce environmental impact.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: ColorPage.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Sustainability',
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorPage.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          // Read more action
                        },
                        icon: const Icon(Icons.article),
                        label: const Text('Read Full Article'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Tips list
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildTipCard(
                            'Optimal Planting Density for Wheat',
                            'Increase your wheat yield by optimizing plant density based on soil type and climate conditions.',
                            'Crop Management',
                            Icons.grass,
                            Colors.green,
                          ),
                          const SizedBox(height: 16),
                          _buildTipCard(
                            'Pest Control Without Chemicals',
                            'Learn about biological pest control methods that can reduce chemical use while maintaining crop protection.',
                            'Pest Control',
                            Icons.bug_report,
                            Colors.orange,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          _buildTipCard(
                            'Soil Testing Guide',
                            'Regular soil testing can help you adjust fertilization strategies and maximize nutrient efficiency.',
                            'Soil Health',
                            Icons.landscape,
                            Colors.brown,
                          ),
                          const SizedBox(height: 16),
                          _buildTipCard(
                            'Water Conservation Techniques',
                            'Implement these water-saving irrigation practices to reduce costs and environmental impact.',
                            'Water Management',
                            Icons.water_drop,
                            Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildTipCard(
                      'Optimal Planting Density for Wheat',
                      'Increase your wheat yield by optimizing plant density based on soil type and climate conditions.',
                      'Crop Management',
                      Icons.grass,
                      Colors.green,
                    ),
                    const SizedBox(height: 16),
                    _buildTipCard(
                      'Soil Testing Guide',
                      'Regular soil testing can help you adjust fertilization strategies and maximize nutrient efficiency.',
                      'Soil Health',
                      Icons.landscape,
                      Colors.brown,
                    ),
                    const SizedBox(height: 16),
                    _buildTipCard(
                      'Pest Control Without Chemicals',
                      'Learn about biological pest control methods that can reduce chemical use while maintaining crop protection.',
                      'Pest Control',
                      Icons.bug_report,
                      Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    _buildTipCard(
                      'Water Conservation Techniques',
                      'Implement these water-saving irrigation practices to reduce costs and environmental impact.',
                      'Water Management',
                      Icons.water_drop,
                      Colors.blue,
                    ),
                  ],
                ),

          const SizedBox(height: 24),

          // Ask AI section
          DashboardCard(
            title: 'Ask AI for Farming Advice',
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Get personalized recommendations by asking our AI assistant about any farming topic.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText:
                          'e.g., How can I improve soil fertility naturally?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          // Send query to AI
                        },
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Recent Questions:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRecentQuestion(
                      'What\'s the best time to plant corn in my region?'),
                  _buildRecentQuestion(
                      'How can I identify and treat common wheat diseases?'),
                  _buildRecentQuestion(
                      'What cover crops work well after rice harvest?'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
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

  Widget _buildTipCard(String title, String description, String category,
      IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // View details
                  },
                  child: const Text('Read More'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentQuestion(String question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.question_answer, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              question,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.replay, size: 16),
            onPressed: () {
              // Re-ask question
            },
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
