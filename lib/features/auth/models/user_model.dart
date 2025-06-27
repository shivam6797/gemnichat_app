import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gemnichat_app/features/chat/models/chat_model.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final DateTime joinedAt;
  final bool isFirstTime;
  final List<ChatModel> chatHistory;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.joinedAt,
    required this.isFirstTime,
    required this.chatHistory,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'joinedAt': joinedAt.toIso8601String(),
      'isFirstTime': isFirstTime,
      'chatHistory': chatHistory.map((chat) => chat.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      joinedAt: map['joinedAt'] is Timestamp
          ? (map['joinedAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['joinedAt'] ?? '') ?? DateTime.now(),
      isFirstTime: map['isFirstTime'] ?? true,
      chatHistory: map['chatHistory'] != null
          ? List<ChatModel>.from(
              (map['chatHistory'] as List).map((e) => ChatModel.fromMap(e)),
            )
          : [],
    );
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? joinedAt,
    bool? isFirstTime,
    List<ChatModel>? chatHistory,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      joinedAt: joinedAt ?? this.joinedAt,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      chatHistory: chatHistory ?? this.chatHistory,
    );
  }
}
