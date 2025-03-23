import 'dart:ui';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';
import '../../secrets.dart';

class GeminiChatController {
  final List<types.Message> messages = [];
  final types.User user = const types.User(
    id: '1',
    firstName: 'User',
    imageUrl: 'https://randomuser.me/api/portraits/men/36.jpg',
  );
  final types.User gemini = const types.User(
    id: '2',
    firstName: 'Gemini',
    imageUrl: 'https://i.imgur.com/xmppHCW.png',
  );
  late GenerativeModel model;
  bool isLoading = false;
  ChatSession? _chatSession;

  // Callback for UI updates
  final Function(VoidCallback) updateState;

  GeminiChatController({required this.updateState}) {
    initGemini();
  }

  void initGemini() {
    model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: Secrets.apiKey);

    // Create a chat session with initial context (not visible to user)
    final initialContext = """
    You are an AI assistant in an agriculture app called AgriSage. 
    The app helps farmers with crop management, pest identification, and sustainable farming practices.
    Provide concise, helpful answers related to agriculture, farming techniques, and plant health.
    Always maintain a friendly, professional tone and prioritize sustainable farming methods.
    When discussing farming techniques, consider both traditional and modern approaches.
    """;

    _chatSession = model.startChat(history: [
      Content.text(initialContext),
    ]);

    // Add visible welcome message to UI
    addBotMessage("Hello! I'm Gemini. How can I help you with your farming needs today?");
  }

  void addMessage(types.Message message) {
    updateState(() {
      messages.insert(0, message);
    });
  }

  void addBotMessage(String text) {
    final uuid = const Uuid().v4();
    final botMessage = types.TextMessage(
      author: gemini,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: uuid,
      text: text,
    );
    addMessage(botMessage);
  }

  Future<void> sendMessage(types.PartialText message) async {
    if (message.text.trim().isEmpty) return;

    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    addMessage(textMessage);

    updateState(() {
      isLoading = true;
    });

    try {
      // Use chat session instead of one-off generation
      final response = await _chatSession!.sendMessage(Content.text(message.text));
      if (response.text != null) {
        addBotMessage(response.text!);
      } else {
        addBotMessage("I'm sorry, I couldn't generate a response.");
      }
    } catch (e) {
      addBotMessage("Sorry, there was an error: ${e.toString()}");
    } finally {
      updateState(() {
        isLoading = false;
      });
    }
  }

  void clearChat() {
    updateState(() {
      messages.clear();

      // Reset the chat session with the initial context
      final initialContext = """
      You are an AI assistant in an agriculture app called AgriSage. 
      The app helps farmers with crop management, pest identification, and sustainable farming practices.
      Provide concise, helpful answers related to agriculture, farming techniques, and plant health.
      Always maintain a friendly, professional tone and prioritize sustainable farming methods.
      When discussing farming techniques, consider both traditional and modern approaches.
      """;

      _chatSession = model.startChat(history: [
        Content.text(initialContext),
      ]);

      addBotMessage("Chat history cleared. How can I help with your farming questions today?");
    });
  }
}