import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/consultation_service.dart';
import '../models/chat_message.dart';

final chatControllerProvider = StateNotifierProvider<ChatController, ChatState>((ref) {
  return ChatController(ref.watch(consultationServiceProvider));
});

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  ChatState({
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
      error: error,
    );
  }
}

class ChatController extends StateNotifier<ChatState> {
  final ConsultationService _consultationService;

  ChatController(this._consultationService) : super(ChatState());

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. Add User Message
    final userMessage = ChatMessage(content: text, isUser: true);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      // 2. Prepare History for AI
      // Get last 10 messages, preserving order
      final historyMessages = state.messages.where((m) => !m.isError).toList();
      final startIndex = historyMessages.length > 10 ? historyMessages.length - 10 : 0;
      
      final history = historyMessages
          .sublist(startIndex)
          .map((m) => {
                'role': m.isUser ? 'user' : 'assistant',
                'content': m.content,
              })
          .toList();

      // 3. Call Service
      final response = await _consultationService.sendQuery(text, history);

      // 4. Add AI Response
      final aiMessage = ChatMessage(content: response, isUser: false);
      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
      );
    } catch (e) {
      // Handle Error
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        messages: [
          ...state.messages,
          ChatMessage(content: "Error: $e", isUser: false, isError: true),
        ],
      );
    }
  }
}
