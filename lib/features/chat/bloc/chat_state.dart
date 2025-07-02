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

class ChatLoaded extends ChatState {
  final UserModel user;
  final List<ChatModel> chatHistory;
  final List<MessageModel> messages;
  final bool isTyping;
  final String? selectedChatId;
   final bool hasStartedChat;

  ChatLoaded({
    required this.user,
    required this.chatHistory,
    required this.messages,
   this.isTyping = false,
    this.selectedChatId,
     this.hasStartedChat = false,
  });

  ChatLoaded copyWith({
    UserModel? user,
    List<ChatModel>? chatHistory,
    List<MessageModel>? messages,
    bool? isTyping,
    String? selectedChatId,
     bool? hasStartedChat,
  }) {
    return ChatLoaded(
      user: user ?? this.user,
      chatHistory: chatHistory ?? this.chatHistory,
      messages: messages ?? this.messages,
        isTyping: isTyping ?? this.isTyping,
      selectedChatId: selectedChatId ?? this.selectedChatId,
       hasStartedChat: hasStartedChat ?? this.hasStartedChat,
    );
  }
}
