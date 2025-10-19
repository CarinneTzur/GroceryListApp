import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  
  String _selectedGoal = 'maintain';
  String _selectedActivityLevel = 'moderate';
  List<String> _selectedDietTags = [];
  List<String> _selectedAllergies = [];
  int _budgetPerWeek = 100;
  int _maxCookTime = 30;
  int _defaultServings = 2;

  final List<String> _goals = [
    'lose_weight',
    'maintain',
    'gain_weight',
    'build_muscle',
  ];

  final List<String> _activityLevels = [
    'sedentary',
    'light',
    'moderate',
    'active',
    'very_active',
  ];

  final List<String> _dietTags = [
    'vegetarian',
    'vegan',
    'keto',
    'paleo',
    'mediterranean',
    'low_carb',
    'high_protein',
    'gluten_free',
    'dairy_free',
  ];

  final List<String> _allergies = [
    'nuts',
    'dairy',
    'eggs',
    'soy',
    'wheat',
    'fish',
    'shellfish',
    'sesame',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (!_formKey.currentState!.validate()) return;
    
    // TODO: Save profile data to backend
    // For now, just navigate to home
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Your Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  'Let\'s personalize your experience',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tell us about your goals and preferences',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Basic Info Section
                _buildSection(
                  title: 'Basic Information',
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _ageController,
                            decoration: const InputDecoration(
                              labelText: 'Age',
                              hintText: '25',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              final age = int.tryParse(value);
                              if (age == null || age < 13 || age > 120) {
                                return 'Invalid age';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _weightController,
                            decoration: const InputDecoration(
                              labelText: 'Weight (kg)',
                              hintText: '70',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              final weight = double.tryParse(value);
                              if (weight == null || weight < 30 || weight > 300) {
                                return 'Invalid weight';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _heightController,
                            decoration: const InputDecoration(
                              labelText: 'Height (cm)',
                              hintText: '170',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              final height = double.tryParse(value);
                              if (height == null || height < 100 || height > 250) {
                                return 'Invalid height';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Goals Section
                _buildSection(
                  title: 'Health Goals',
                  children: [
                    _buildGoalSelector(),
                    const SizedBox(height: 16),
                    _buildActivityLevelSelector(),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Diet Preferences Section
                _buildSection(
                  title: 'Diet Preferences',
                  children: [
                    _buildMultiSelectChips(
                      'Diet Tags',
                      _dietTags,
                      _selectedDietTags,
                      (tags) => setState(() => _selectedDietTags = tags),
                    ),
                    const SizedBox(height: 16),
                    _buildMultiSelectChips(
                      'Allergies & Intolerances',
                      _allergies,
                      _selectedAllergies,
                      (allergies) => setState(() => _selectedAllergies = allergies),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Preferences Section
                _buildSection(
                  title: 'Cooking Preferences',
                  children: [
                    _buildSliderPreference(
                      'Budget per week (\$)',
                      _budgetPerWeek.toDouble(),
                      50,
                      500,
                      (value) => setState(() => _budgetPerWeek = value.round()),
                    ),
                    const SizedBox(height: 16),
                    _buildSliderPreference(
                      'Max cook time (minutes)',
                      _maxCookTime.toDouble(),
                      10,
                      120,
                      (value) => setState(() => _maxCookTime = value.round()),
                    ),
                    const SizedBox(height: 16),
                    _buildSliderPreference(
                      'Default servings',
                      _defaultServings.toDouble(),
                      1,
                      8,
                      (value) => setState(() => _defaultServings = value.round()),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Continue Button
                ElevatedButton(
                  onPressed: _handleContinue,
                  child: const Text('Complete Setup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildGoalSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Primary Goal',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _goals.map((goal) {
            final isSelected = _selectedGoal == goal;
            return FilterChip(
              label: Text(_getGoalDisplayName(goal)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedGoal = goal;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActivityLevelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Level',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _activityLevels.map((level) {
            final isSelected = _selectedActivityLevel == level;
            return FilterChip(
              label: Text(_getActivityLevelDisplayName(level)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedActivityLevel = level;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMultiSelectChips(
    String title,
    List<String> options,
    List<String> selected,
    Function(List<String>) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return FilterChip(
              label: Text(_getDisplayName(option)),
              selected: isSelected,
              onSelected: (isSelected) {
                final newSelection = List<String>.from(selected);
                if (isSelected) {
                  newSelection.add(option);
                } else {
                  newSelection.remove(option);
                }
                onChanged(newSelection);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSliderPreference(
    String title,
    double value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              value.round().toString(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  String _getGoalDisplayName(String goal) {
    switch (goal) {
      case 'lose_weight': return 'Lose Weight';
      case 'maintain': return 'Maintain Weight';
      case 'gain_weight': return 'Gain Weight';
      case 'build_muscle': return 'Build Muscle';
      default: return goal;
    }
  }

  String _getActivityLevelDisplayName(String level) {
    switch (level) {
      case 'sedentary': return 'Sedentary';
      case 'light': return 'Light Activity';
      case 'moderate': return 'Moderate Activity';
      case 'active': return 'Active';
      case 'very_active': return 'Very Active';
      default: return level;
    }
  }

  String _getDisplayName(String value) {
    return value.split('_').map((word) => 
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }
}
