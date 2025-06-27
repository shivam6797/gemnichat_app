class ChatModel {
  final String chatId;
  final String title;
  final DateTime createdAt;

  ChatModel({
    required this.chatId,
    required this.title,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'] ?? '',
      title: map['title'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  ChatModel copyWith({String? chatId, String? title, DateTime? createdAt}) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
