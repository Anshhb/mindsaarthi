import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/api_service.dart';
import '../../../services/firestore_service.dart';
import 'chat_model.dart';
import 'chat_state.dart';

final chatControllerProvider = StateNotifierProvider<ChatController, ChatState>(
  (ref) {
    return ChatController();
  },
);

class ChatController extends StateNotifier<ChatState> {
  ChatController() : super(ChatState());

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    state = state.copyWith(
      messages: [...state.messages, ChatMessage(role: "user", text: text)],
      isLoading: true,
    );

    try {
      final response = await ApiService.sendMessage(text);

      String botReply = response["reply"] ?? "";
      String sentiment = response["sentiment"] ?? "";
      int risk = response["risk"] ?? 0;
      List actions = response["actions"] ?? [];
      // String suggestion = response["recommendation"] ?? "";
      String suggestion =
          actions.isNotEmpty ? actions.map((e) => "• $e").join("\n") : "";

      List<ChatMessage> newMessages = [
        ...state.messages,
        ChatMessage(role: "bot", text: botReply),
      ];

      for (var action in actions) {
        newMessages.add(ChatMessage(role: "action", text: "• $action"));
      }


      state = state.copyWith(messages: newMessages, isLoading: false);

      await FirestoreService.saveChat(
        message: text,
        reply: botReply,
        sentiment: sentiment,
        risk: risk,
        suggestion: suggestion,
      );
    } catch (e) {
      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(role: "bot", text: "Error connecting to server"),
        ],
        isLoading: false,
      );
    }
  }
}
