import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final List<GroceryItem> _items = [
    GroceryItem(name: 'Chicken Breast', quantity: '2 lbs', category: 'Meat', isChecked: false),
    GroceryItem(name: 'Brown Rice', quantity: '1 bag', category: 'Grains', isChecked: false),
    GroceryItem(name: 'Broccoli', quantity: '1 head', category: 'Vegetables', isChecked: false),
    GroceryItem(name: 'Olive Oil', quantity: '1 bottle', category: 'Pantry', isChecked: false),
    GroceryItem(name: 'Greek Yogurt', quantity: '1 container', category: 'Dairy', isChecked: false),
  ];

  final List<String> _categories = ['All', 'Meat', 'Vegetables', 'Dairy', 'Grains', 'Pantry'];
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredItems = _selectedCategory == 'All' 
      ? _items 
      : _items.where((item) => item.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addItem,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareList,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Items List
          Expanded(
            child: filteredItems.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return _buildGroceryItem(item);
                  },
                ),
          ),
          
          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.2)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Items: ${_items.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Checked: ${_items.where((item) => item.isChecked).length}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.successColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No items in this category',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items from your meal plan or manually',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroceryItem(GroceryItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: item.isChecked,
          onChanged: (value) {
            setState(() {
              item.isChecked = value ?? false;
            });
          },
        ),
        title: Text(
          item.name,
          style: TextStyle(
            decoration: item.isChecked ? TextDecoration.lineThrough : null,
            color: item.isChecked ? AppTheme.textTertiary : null,
          ),
        ),
        subtitle: Text(item.quantity),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getCategoryColor(item.category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item.category,
                style: TextStyle(
                  color: _getCategoryColor(item.category),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _removeItem(item),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'meat':
        return Colors.red;
      case 'vegetables':
        return Colors.green;
      case 'dairy':
        return Colors.blue;
      case 'grains':
        return Colors.orange;
      case 'pantry':
        return Colors.brown;
      default:
        return AppTheme.primaryColor;
    }
  }

  void _addItem() {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    String selectedCategory = 'Pantry';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'e.g., Chicken Breast',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'e.g., 2 lbs',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
                items: _categories.skip(1).map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setModalState(() {
                    selectedCategory = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _items.add(GroceryItem(
                      name: nameController.text,
                      quantity: quantityController.text.isNotEmpty 
                        ? quantityController.text 
                        : '1',
                      category: selectedCategory,
                      isChecked: false,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _items.remove(item);
    });
  }

  void _shareList() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grocery list shared!')),
    );
  }
}

class GroceryItem {
  final String name;
  final String quantity;
  final String category;
  bool isChecked;

  GroceryItem({
    required this.name,
    required this.quantity,
    required this.category,
    required this.isChecked,
  });
}
