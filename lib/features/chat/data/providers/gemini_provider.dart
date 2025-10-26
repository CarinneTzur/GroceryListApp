import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/providers/shared_preferences_provider.dart';
import '../../domain/services/gemini_api_service.dart';

// Provider for Gemini API service
final geminiApiServiceProvider = Provider<GeminiApiService>((ref) {
  // Get API key from shared preferences or environment
  final prefs = ref.watch(sharedPreferencesProvider);
  final apiKey = prefs.getString('gemini_api_key') ?? '';
  
  if (apiKey.isEmpty) {
    throw Exception('Gemini API key not found. Please set it in settings.');
  }
  
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

  ChatNotifier(this._geminiService, this._prefs) : super(const ChatState()) {
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
      text: "Hi! I'm here to help you plan your meals. Tell me about your preferences, dietary restrictions, or any specific foods you'd like to include or avoid in your meal plan.",
      isUser: false,
      timestamp: DateTime.now(),
    );
    
    state = state.copyWith(messages: [welcomeMessage]);
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

    try {
      // Prepare conversation history
      final conversationHistory = state.messages
          .where((msg) => msg.text.isNotEmpty)
          .map((msg) => msg.toMap())
          .toList();

      // Custom system prompt for meal planning
      const systemPrompt = '''You are a helpful AI assistant specializing in meal planning and nutrition. 
Your role is to help users create personalized meal plans based on their preferences, dietary restrictions, and health goals.
When users share information about their diet, allergies, budget, or preferences, provide helpful and practical meal planning advice.''';

      // Get response from Gemini API
      final response = await _geminiService.sendMessage(
        message: message,
        conversationHistory: conversationHistory,
        systemPrompt: systemPrompt,
      );

      // Add AI response
      final aiMessage = ChatMessage(
        text: response,
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
  return ChatNotifier(geminiService, prefs);
});

