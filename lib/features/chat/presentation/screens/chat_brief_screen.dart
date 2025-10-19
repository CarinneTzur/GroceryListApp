import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';

class ChatBriefScreen extends ConsumerStatefulWidget {
  const ChatBriefScreen({super.key});

  @override
  ConsumerState<ChatBriefScreen> createState() => _ChatBriefScreenState();
}

class _ChatBriefScreenState extends ConsumerState<ChatBriefScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      text: "Hi! I'm here to help you plan your meals. Tell me about your preferences, dietary restrictions, or any specific foods you'd like to include or avoid in your meal plan.",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      _addAIResponse(text);
    });
  }

  void _addAIResponse(String userMessage) {
    setState(() {
      _messages.add(ChatMessage(
        text: _generateAIResponse(userMessage),
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  String _generateAIResponse(String userMessage) {
    // Simple mock responses based on keywords
    final message = userMessage.toLowerCase();
    
    if (message.contains('vegetarian') || message.contains('vegan')) {
      return "Great! I'll make sure to include plenty of plant-based options in your meal plan. I can suggest delicious vegetarian recipes with good protein sources like beans, lentils, and quinoa.";
    } else if (message.contains('allergy') || message.contains('allergic')) {
      return "I understand you have allergies. Please let me know specifically what you're allergic to so I can ensure those ingredients are completely avoided in your meal recommendations.";
    } else if (message.contains('budget') || message.contains('cheap') || message.contains('affordable')) {
      return "I'll focus on budget-friendly recipes and suggest cost-effective alternatives. I can also help you plan meals that use similar ingredients to reduce waste and save money.";
    } else if (message.contains('time') || message.contains('quick') || message.contains('fast')) {
      return "I'll prioritize quick and easy recipes for you. I can suggest 15-30 minute meals and meal prep options to save time during the week.";
    } else if (message.contains('protein') || message.contains('muscle') || message.contains('gym')) {
      return "I'll make sure to include high-protein recipes in your meal plan. I can suggest lean meats, fish, eggs, and plant-based protein sources to help you meet your fitness goals.";
    } else if (message.contains('lose weight') || message.contains('weight loss')) {
      return "I'll create a meal plan focused on nutrient-dense, lower-calorie options that will help you achieve your weight loss goals while keeping you satisfied.";
    } else {
      return "Thanks for sharing that! I'm taking note of your preferences. Is there anything else you'd like me to know about your dietary needs, cooking skills, or meal planning goals?";
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Brief'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              setState(() {
                _messages.clear();
                _addWelcomeMessage();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Tell me about your preferences...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser 
          ? MainAxisAlignment.end 
          : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(
                Icons.smart_toy,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser 
                  ? AppTheme.primaryColor 
                  : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft: message.isUser 
                    ? const Radius.circular(18) 
                    : const Radius.circular(4),
                  bottomRight: message.isUser 
                    ? const Radius.circular(4) 
                    : const Radius.circular(18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser 
                        ? Colors.white 
                        : AppTheme.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isUser 
                        ? Colors.white.withOpacity(0.7) 
                        : AppTheme.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.secondaryColor,
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
