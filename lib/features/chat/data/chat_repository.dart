import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemnichat_app/features/auth/models/user_model.dart';
import 'package:gemnichat_app/features/chat/models/chat_model.dart';
import 'package:gemnichat_app/features/chat/data/chat_api_services.dart';
import 'package:gemnichat_app/features/chat/models/message_model.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ChatApiService apiService;

  ChatRepository({
    required this.firestore,
    required this.auth,
    required this.apiService,
  });
  Future<UserModel> getUserDetails() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    final docRef = firestore.collection("users").doc(uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      // ✅ Agar document nahi mila to ek default UserModel bana ke save karo
      final user = UserModel(
        uid: uid,
        name: auth.currentUser?.displayName ?? "Guest",
        email: auth.currentUser?.email ?? "unknown",
        photoUrl: auth.currentUser?.photoURL ?? "", // fallback to empty string
        joinedAt: DateTime.now(),
        isFirstTime: true,
        chatHistory: [],
      );

      await docRef.set(user.toMap());
      return user;
    }

    return UserModel.fromMap(snapshot.data()!);
  }

  Future<void> updateIsFirstTime(bool value) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    await firestore.collection("users").doc(uid).update({"isFirstTime": value});
  }

  Future<void> addChatToHistory(ChatModel chat) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    await firestore.collection("users").doc(uid).update({
      "chatHistory": FieldValue.arrayUnion([chat.toMap()]),
    });
  }

  Future<void> updateChatHistory(List<ChatModel> updatedList) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    await firestore.collection("users").doc(uid).update({
      "chatHistory": updatedList.map((chat) => chat.toMap()).toList(),
    });
  }

  Future<void> deleteChat({
    required String userId,
    required String chatId,
    required List<ChatModel> updatedChatHistory,
  }) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    // ✅ 1. Update chat history in user's document
    await userDoc.update({
      'chatHistory': updatedChatHistory.map((chat) => chat.toMap()).toList(),
    });

    // ✅ 2. Delete messages from chats/{chatId}/messages
    final messagesSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .get();

    for (final doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }

    // ✅ 3. Delete parent chat doc itself
    await FirebaseFirestore.instance.collection('chats').doc(chatId).delete();
  }

  Future<String> sendMessageToGemini(String prompt) async {
    return await apiService.sendMessage(prompt);
  }

  Future<List<ChatModel>> fetchChatHistory(String userId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    final chatList = userDoc.data()?['chatHistory'] as List<dynamic>? ?? [];

    return chatList
        .map((chat) => ChatModel.fromMap(chat as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveMessage(String chatId, MessageModel message) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    await firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
  }

  Future<List<MessageModel>> fetchMessages(String chatId) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => MessageModel.fromMap(doc.data()))
        .toList();
  }
}
