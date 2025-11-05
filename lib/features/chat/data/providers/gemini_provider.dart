import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/providers/shared_preferences_provider.dart';
import '../../domain/services/gemini_api_service.dart';
import '../../../grocery/data/providers/grocery_provider.dart';

// Provider for Gemini API service
final geminiApiServiceProvider = Provider<GeminiApiService>((ref) {
  // Get API key from shared preferences or use default
  final prefs = ref.watch(sharedPreferencesProvider);
  const defaultApiKey = 'AIzaSyA3qSfgPiklZjh2zxq9qDI9vpB4aqiMT4Q';
  final apiKey = prefs.getString('gemini_api_key') ?? defaultApiKey;
  
  return GeminiApiService(apiKey: apiKey);
});

// Chat message model
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'role': isUser ? 'user' : 'assistant',
      'content': text,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['content'] ?? '',
      isUser: map['role'] == 'user',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());
  factory ChatMessage.fromJson(String json) => ChatMessage.fromMap(jsonDecode(json));
}

// Chat state
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Chat notifier
class ChatNotifier extends StateNotifier<ChatState> {
  final GeminiApiService _geminiService;
  final SharedPreferences _prefs;
  final Ref _ref;

  ChatNotifier(this._geminiService, this._prefs, this._ref) : super(const ChatState()) {
    _loadChatHistory();
    // Note: _prefs is kept for future chat history persistence
  }

  void _loadChatHistory() {
    // Load saved chat history if needed
    // For now, add welcome message
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      text: "Hi! I'm your Meal Planner AI assistant 🤖. I can help you plan meals, answer nutrition questions, and even add items to your grocery list! Just say things like 'add chicken to my grocery list' or 'I need eggs and milk'. How can I help you today?",
      isUser: false,
      timestamp: DateTime.now(),
    );
    
    state = state.copyWith(messages: [welcomeMessage]);
  }

  List<String> _extractGroceryItems(String message) {
    // Simple keyword detection for grocery items
    final groceryKeywords = ['add', 'put', 'need', 'buy', 'get', 'grocery', 'shopping'];
    final lowerMessage = message.toLowerCase();
    
    List<String> items = [];
    
    // Check if message contains grocery-related keywords
    bool isGroceryRequest = groceryKeywords.any((keyword) => lowerMessage.contains(keyword)) &&
                            (lowerMessage.contains('list') || lowerMessage.contains('grocery') || 
                             lowerMessage.contains('shopping') || lowerMessage.contains('to my'));
    
    if (isGroceryRequest || lowerMessage.contains('add') && lowerMessage.contains('to')) {
      // Extract items from phrases like "add chicken and eggs to my grocery list"
      // or "I need milk, bread, and butter"
      final patterns = [
        RegExp(r'add\s+(.+?)\s+to', caseSensitive: false),
        RegExp(r'need\s+(.+?)(?:,|\sand|\.|$)', caseSensitive: false),
        RegExp(r'buy\s+(.+?)(?:,|\sand|\.|$)', caseSensitive: false),
        RegExp(r'get\s+(.+?)(?:,|\sand|\.|$)', caseSensitive: false),
      ];
      
      for (var pattern in patterns) {
        final matches = pattern.allMatches(message);
        for (var match in matches) {
          if (match.groupCount >= 1) {
            var itemText = match.group(1) ?? '';
            // Split by comma, and, or or
            var parts = itemText.split(RegExp(r',\s*|\s+and\s+|\s+or\s+', caseSensitive: false));
            for (var part in parts) {
              var cleaned = part.trim();
              if (cleaned.isNotEmpty && !cleaned.toLowerCase().contains('list')) {
                // Remove common stop words
                cleaned = cleaned.replaceAll(RegExp(r'\b(my|the|a|an|to|for)\b', caseSensitive: false), '').trim();
                if (cleaned.isNotEmpty) {
                  items.add(cleaned);
                }
              }
            }
          }
        }
      }
      
      // If no items found with patterns, try to extract after "add" or "need"
      if (items.isEmpty) {
        final simplePattern = RegExp(r'(?:add|need|buy|get)\s+([^,]+?)(?:\s+to|\s+on|\s+for|,|$)', caseSensitive: false);
        final matches = simplePattern.allMatches(message);
        for (var match in matches) {
          var item = match.group(1)?.trim() ?? '';
          if (item.isNotEmpty && !item.toLowerCase().contains('list')) {
            items.add(item);
          }
        }
      }
    }
    
    return items;
  }
  
  String _determineCategory(String itemName) {
    final lower = itemName.toLowerCase();
    
    if (lower.contains('chicken') || lower.contains('beef') || lower.contains('pork') || 
        lower.contains('turkey') || lower.contains('fish') || lower.contains('meat') ||
        lower.contains('sausage') || lower.contains('bacon')) {
      return 'Meat';
    } else if (lower.contains('broccoli') || lower.contains('carrot') || lower.contains('lettuce') ||
               lower.contains('tomato') || lower.contains('pepper') || lower.contains('onion') ||
               lower.contains('potato') || lower.contains('vegetable') || lower.contains('spinach') ||
               lower.contains('cucumber') || lower.contains('mushroom')) {
      return 'Vegetables';
    } else if (lower.contains('milk') || lower.contains('cheese') || lower.contains('yogurt') ||
               lower.contains('butter') || lower.contains('cream') || lower.contains('dairy')) {
      return 'Dairy';
    } else if (lower.contains('rice') || lower.contains('pasta') || lower.contains('bread') ||
               lower.contains('wheat') || lower.contains('flour') || lower.contains('grain') ||
               lower.contains('oats') || lower.contains('quinoa')) {
      return 'Grains';
    } else {
      return 'Pantry';
    }
  }

  Future<void> sendMessage(String message) async {
    // Add user message
    final userMessage = ChatMessage(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...state.messages, userMessage];
    state = state.copyWith(messages: updatedMessages, isLoading: true, error: null);

    // Check if user wants to add items to grocery list
    final groceryItems = _extractGroceryItems(message);
    if (groceryItems.isNotEmpty) {
      final groceryNotifier = _ref.read(groceryListProvider.notifier);
      for (var item in groceryItems) {
        final category = _determineCategory(item);
        groceryNotifier.addItem(
          name: item.split(' ').map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1)).join(' '),
          quantity: '1',
          category: category,
        );
      }
    }

    try {
      // Prepare conversation history
      final conversationHistory = state.messages
          .where((msg) => msg.text.isNotEmpty)
          .map((msg) => msg.toMap())
          .toList();

      // Custom system prompt for meal planning
      String systemPrompt = '''You are a helpful AI assistant specializing in meal planning and nutrition. 
Your role is to help users create personalized meal plans based on their preferences, dietary restrictions, and health goals.
When users share information about their diet, allergies, budget, or preferences, provide helpful and practical meal planning advice.''';

      // Add grocery list capability info
      if (groceryItems.isNotEmpty) {
        systemPrompt += '\n\nIf the user asks to add items to their grocery list, acknowledge that you have added them.';
      }

      // Get response from Gemini API
      final response = await _geminiService.sendMessage(
        message: message,
        conversationHistory: conversationHistory,
        systemPrompt: systemPrompt,
      );

      // Modify response if items were added
      String finalResponse = response;
      if (groceryItems.isNotEmpty) {
        if (!response.toLowerCase().contains('added') && !response.toLowerCase().contains('grocery')) {
          finalResponse = response + '\n\n✅ I\'ve added ${groceryItems.length} item${groceryItems.length > 1 ? 's' : ''} to your grocery list: ${groceryItems.join(", ")}.';
        }
      }

      // Add AI response
      final aiMessage = ChatMessage(
        text: finalResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );

      final newMessages = [...updatedMessages, aiMessage];
      state = state.copyWith(messages: newMessages, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearChat() {
    _addWelcomeMessage();
  }
}

// Chat provider
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final geminiService = ref.watch(geminiApiServiceProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return ChatNotifier(geminiService, prefs, ref);
});

