import 'package:flutter_riverpod/flutter_riverpod.dart';

// Grocery item model
class GroceryItem {
  final String id;
  final String name;
  final String quantity;
  final String category;
  bool isChecked;

  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.isChecked = false,
  });

  GroceryItem copyWith({
    String? id,
    String? name,
    String? quantity,
    String? category,
    bool? isChecked,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

// Grocery list state
class GroceryListState {
  final List<GroceryItem> items;

  const GroceryListState({
    this.items = const [],
  });

  GroceryListState copyWith({
    List<GroceryItem>? items,
  }) {
    return GroceryListState(
      items: items ?? this.items,
    );
  }
}

// Grocery list notifier
class GroceryListNotifier extends StateNotifier<GroceryListState> {
  GroceryListNotifier() : super(const GroceryListState()) {
    _initializeDefaultItems();
  }

  void _initializeDefaultItems() {
    state = GroceryListState(
      items: [
        GroceryItem(
          id: '1',
          name: 'Chicken Breast',
          quantity: '2 lbs',
          category: 'Meat',
          isChecked: false,
        ),
        GroceryItem(
          id: '2',
          name: 'Brown Rice',
          quantity: '1 bag',
          category: 'Grains',
          isChecked: false,
        ),
        GroceryItem(
          id: '3',
          name: 'Broccoli',
          quantity: '1 head',
          category: 'Vegetables',
          isChecked: false,
        ),
        GroceryItem(
          id: '4',
          name: 'Olive Oil',
          quantity: '1 bottle',
          category: 'Pantry',
          isChecked: false,
        ),
        GroceryItem(
          id: '5',
          name: 'Greek Yogurt',
          quantity: '1 container',
          category: 'Dairy',
          isChecked: false,
        ),
      ],
    );
  }

  void addItem({
    required String name,
    String quantity = '1',
    String category = 'Pantry',
  }) {
    final newItem = GroceryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      quantity: quantity,
      category: category,
      isChecked: false,
    );

    final updatedItems = [...state.items, newItem];
    state = state.copyWith(items: updatedItems);
  }

  void removeItem(String id) {
    final updatedItems = state.items.where((item) => item.id != id).toList();
    state = state.copyWith(items: updatedItems);
  }

  void toggleItem(String id) {
    final updatedItems = state.items.map((item) {
      if (item.id == id) {
        return item.copyWith(isChecked: !item.isChecked);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void updateItem(String id, {String? name, String? quantity, String? category}) {
    final updatedItems = state.items.map((item) {
      if (item.id == id) {
        return item.copyWith(
          name: name ?? item.name,
          quantity: quantity ?? item.quantity,
          category: category ?? item.category,
        );
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }
}

// Grocery list provider
final groceryListProvider = StateNotifierProvider<GroceryListNotifier, GroceryListState>((ref) {
  return GroceryListNotifier();
});

