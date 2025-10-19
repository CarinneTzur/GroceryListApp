import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';

class RecipeSearchScreen extends ConsumerStatefulWidget {
  const RecipeSearchScreen({super.key});

  @override
  ConsumerState<RecipeSearchScreen> createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends ConsumerState<RecipeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedDiet = 'All';
  String _selectedCookingTime = 'All';

  final List<String> _categories = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
    'Desserts',
    'Soups',
    'Salads',
  ];

  final List<String> _dietTypes = [
    'All',
    'Vegetarian',
    'Vegan',
    'Keto',
    'Paleo',
    'Gluten-Free',
    'Dairy-Free',
    'Low-Carb',
    'High-Protein',
  ];

  final List<String> _cookingTimes = [
    'All',
    'Under 15 min',
    '15-30 min',
    '30-60 min',
    'Over 1 hour',
  ];

  final List<Recipe> _recipes = [
    Recipe(
      id: '1',
      title: 'Mediterranean Quinoa Bowl',
      description: 'A healthy and delicious bowl with quinoa, vegetables, and tahini dressing',
      imageUrl: null,
      prepTime: 15,
      cookTime: 20,
      servings: 2,
      difficulty: 'Easy',
      rating: 4.5,
      tags: ['Vegetarian', 'Healthy', 'Mediterranean'],
      calories: 420,
      protein: 18,
      carbs: 52,
      fat: 12,
    ),
    Recipe(
      id: '2',
      title: 'Grilled Salmon with Roasted Vegetables',
      description: 'Perfectly grilled salmon with seasonal roasted vegetables',
      imageUrl: null,
      prepTime: 10,
      cookTime: 25,
      servings: 4,
      difficulty: 'Medium',
      rating: 4.8,
      tags: ['High-Protein', 'Healthy', 'Gluten-Free'],
      calories: 380,
      protein: 35,
      carbs: 15,
      fat: 22,
    ),
    Recipe(
      id: '3',
      title: 'Vegetarian Buddha Bowl',
      description: 'Colorful bowl packed with nutrients and plant-based protein',
      imageUrl: null,
      prepTime: 20,
      cookTime: 15,
      servings: 2,
      difficulty: 'Easy',
      rating: 4.3,
      tags: ['Vegan', 'Healthy', 'Colorful'],
      calories: 450,
      protein: 16,
      carbs: 65,
      fat: 14,
    ),
    Recipe(
      id: '4',
      title: 'Chicken Stir-Fry with Brown Rice',
      description: 'Quick and easy stir-fry with fresh vegetables and lean chicken',
      imageUrl: null,
      prepTime: 15,
      cookTime: 15,
      servings: 3,
      difficulty: 'Easy',
      rating: 4.6,
      tags: ['High-Protein', 'Quick', 'Asian'],
      calories: 320,
      protein: 28,
      carbs: 35,
      fat: 8,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Recipe> get _filteredRecipes {
    return _recipes.where((recipe) {
      final searchQuery = _searchController.text.toLowerCase();
      final matchesSearch = searchQuery.isEmpty || 
        recipe.title.toLowerCase().contains(searchQuery) ||
        recipe.description.toLowerCase().contains(searchQuery) ||
        recipe.tags.any((tag) => tag.toLowerCase().contains(searchQuery));
      
      final matchesCategory = _selectedCategory == 'All' || 
        recipe.tags.contains(_selectedCategory);
      
      final matchesDiet = _selectedDiet == 'All' || 
        recipe.tags.contains(_selectedDiet);
      
      final matchesTime = _selectedCookingTime == 'All' || 
        _matchesCookingTime(recipe);
      
      return matchesSearch && matchesCategory && matchesDiet && matchesTime;
    }).toList();
  }

  bool _matchesCookingTime(Recipe recipe) {
    final totalTime = recipe.prepTime + recipe.cookTime;
    switch (_selectedCookingTime) {
      case 'Under 15 min':
        return totalTime < 15;
      case '15-30 min':
        return totalTime >= 15 && totalTime <= 30;
      case '30-60 min':
        return totalTime > 30 && totalTime <= 60;
      case 'Over 1 hour':
        return totalTime > 60;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          
          // Active Filters
          if (_selectedCategory != 'All' || _selectedDiet != 'All' || _selectedCookingTime != 'All')
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (_selectedCategory != 'All')
                    _buildFilterChip('Category: $_selectedCategory', () {
                      setState(() => _selectedCategory = 'All');
                    }),
                  if (_selectedDiet != 'All')
                    _buildFilterChip('Diet: $_selectedDiet', () {
                      setState(() => _selectedDiet = 'All');
                    }),
                  if (_selectedCookingTime != 'All')
                    _buildFilterChip('Time: $_selectedCookingTime', () {
                      setState(() => _selectedCookingTime = 'All');
                    }),
                ],
              ),
            ),
          
          // Recipe List
          Expanded(
            child: _filteredRecipes.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _filteredRecipes[index];
                    return _buildRecipeCard(recipe);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: onRemove,
        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
        labelStyle: TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No recipes found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showRecipeDetails(recipe),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          recipe.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            recipe.rating.toString(),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(recipe.difficulty).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          recipe.difficulty,
                          style: TextStyle(
                            color: _getDifficultyColor(recipe.difficulty),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Recipe Info
              Row(
                children: [
                  _buildInfoChip(Icons.access_time, '${recipe.prepTime + recipe.cookTime} min'),
                  const SizedBox(width: 8),
                  _buildInfoChip(Icons.people, '${recipe.servings} servings'),
                  const SizedBox(width: 8),
                  _buildInfoChip(Icons.local_fire_department, '${recipe.calories} cal'),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Tags
              Wrap(
                spacing: 8,
                children: recipe.tags.take(3).map((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.textSecondary),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppTheme.successColor;
      case 'medium':
        return AppTheme.warningColor;
      case 'hard':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Recipes',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              
              // Category Filter
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setModalState(() {
                        _selectedCategory = selected ? category : 'All';
                      });
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 16),
              
              // Diet Filter
              Text(
                'Diet Type',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _dietTypes.map((diet) {
                  final isSelected = _selectedDiet == diet;
                  return FilterChip(
                    label: Text(diet),
                    selected: isSelected,
                    onSelected: (selected) {
                      setModalState(() {
                        _selectedDiet = selected ? diet : 'All';
                      });
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 16),
              
              // Cooking Time Filter
              Text(
                'Cooking Time',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _cookingTimes.map((time) {
                  final isSelected = _selectedCookingTime == time;
                  return FilterChip(
                    label: Text(time),
                    selected: isSelected,
                    onSelected: (selected) {
                      setModalState(() {
                        _selectedCookingTime = selected ? time : 'All';
                      });
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRecipeDetails(Recipe recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Recipe Title
              Text(
                recipe.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                recipe.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Recipe Details
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nutrition Info
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nutrition (per serving)',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildNutritionItem('Calories', '${recipe.calories}'),
                                  _buildNutritionItem('Protein', '${recipe.protein}g'),
                                  _buildNutritionItem('Carbs', '${recipe.carbs}g'),
                                  _buildNutritionItem('Fat', '${recipe.fat}g'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Recipe Info
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recipe Info',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoItem('Prep Time', '${recipe.prepTime} min'),
                                  ),
                                  Expanded(
                                    child: _buildInfoItem('Cook Time', '${recipe.cookTime} min'),
                                  ),
                                  Expanded(
                                    child: _buildInfoItem('Servings', '${recipe.servings}'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Tags
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tags',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                children: recipe.tags.map((tag) => Chip(
                                  label: Text(tag),
                                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                                  labelStyle: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 12,
                                  ),
                                )).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Add to meal plan
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to meal plan')),
                        );
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Add to Meal Plan'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Add to grocery list
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to grocery list')),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Add to Grocery'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

class Recipe {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final int prepTime;
  final int cookTime;
  final int servings;
  final String difficulty;
  final double rating;
  final List<String> tags;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.difficulty,
    required this.rating,
    required this.tags,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}
