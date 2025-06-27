import 'package:gemnichat_app/features/auth/models/user_model.dart';
import 'package:gemnichat_app/features/chat/models/chat_model.dart';
import 'package:gemnichat_app/features/chat/models/message_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatError extends ChatState {
  final String message;
  ChatError({required this.message});
}

// ✅ SINGLE STATE with everything
class ChatLoaded extends ChatState {
  final UserModel user;
  final List<ChatModel> chatHistory;
  final List<MessageModel> messages;
  final String? selectedChatId;
   final bool hasStartedChat; // ✅ ADD THIS

  ChatLoaded({
    required this.user,
    required this.chatHistory,
    required this.messages,
    this.selectedChatId,
     this.hasStartedChat = false, // ✅ DEFAULT FALSE
  });

  ChatLoaded copyWith({
    UserModel? user,
    List<ChatModel>? chatHistory,
    List<MessageModel>? messages,
    String? selectedChatId,
     bool? hasStartedChat,
  }) {
    return ChatLoaded(
      user: user ?? this.user,
      chatHistory: chatHistory ?? this.chatHistory,
      messages: messages ?? this.messages,
      selectedChatId: selectedChatId ?? this.selectedChatId,
       hasStartedChat: hasStartedChat ?? this.hasStartedChat,
    );
  }
}
