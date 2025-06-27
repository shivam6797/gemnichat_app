class MessageModel {
  final String msg;
  final bool isUser;
  final DateTime createdAt;

  MessageModel({
    required this.msg,
    required this.isUser,
    required this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      msg: map['msg'] ?? '',
      isUser: map['isUser'] ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'msg': msg,
      'isUser': isUser,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
