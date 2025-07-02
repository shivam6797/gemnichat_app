abstract class ChatEvent {}

class FetchUserDetails extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String message;
  final String chatId;
  SendMessageEvent({required this.message, required this.chatId});
}

class LoadUserChatHistory extends ChatEvent {
  final String userId;
  LoadUserChatHistory(this.userId);
}

class FetchChatByIdEvent extends ChatEvent {
  final String chatId;
  FetchChatByIdEvent(this.chatId);
}

class StartNewChatEvent extends ChatEvent {}

class RenameChatEvent extends ChatEvent {
  final String chatId;
  final String newTitle;
  RenameChatEvent({required this.chatId, required this.newTitle});
}

class DeleteChatEvent extends ChatEvent {
  final String chatId;
  DeleteChatEvent(this.chatId);
}

class RetryLastEvent extends ChatEvent {}

class StopGenerationEvent extends ChatEvent {}

