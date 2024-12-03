import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:technician_app/Assets/Model/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generates a consistent chat ID based on the two user IDs
  String getChatId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join('_');
  }

  // Sends a message to Firestore
  Future<void> sendMessage(
      ChatMessage message, String chatId, String token) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
  }

  // Stream to retrieve chat messages in real time
  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList());
  }
}
