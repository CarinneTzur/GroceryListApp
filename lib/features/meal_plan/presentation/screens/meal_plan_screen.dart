import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  int _selectedDays = 3;
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final List<String> _meals = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _generateMealPlan,
          ),
        ],
      ),
      body: Column(
        children: [
          // Plan Duration Selector
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Plan Duration: '),
                Expanded(
                  child: Slider(
                    value: _selectedDays.toDouble(),
                    min: 3,
                    max: 7,
                    divisions: 4,
                    label: '$_selectedDays days',
                    onChanged: (value) {
                      setState(() {
                        _selectedDays = value.round();
                      });
                    },
                  ),
                ),
                Text('$_selectedDays days'),
              ],
            ),
          ),
          
          // Meal Plan Grid
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _selectedDays,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _days[index],
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        ..._meals.map((meal) => _buildMealSlot(meal, index)).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Generate Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generateMealPlan,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generate Meal Plan'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSlot(String meal, int dayIndex) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap to add recipe',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _addRecipe(meal, dayIndex),
          ),
        ],
      ),
    );
  }

  void _addRecipe(String meal, int dayIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Recipe for $meal'),
        content: const Text('This would open recipe search. For MVP, we\'ll add a placeholder.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added recipe to $meal on ${_days[dayIndex]}')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _generateMealPlan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Meal Plan'),
        content: Text('Generate a $_selectedDays-day meal plan based on your preferences?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Meal plan generated! Check your plan above.')),
              );
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }
}
