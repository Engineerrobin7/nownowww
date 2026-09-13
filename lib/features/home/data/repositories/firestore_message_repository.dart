import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/chat_model.dart';
import '../../domain/models/message_model.dart';
import '../../domain/repositories/message_repository.dart';

class FirestoreMessageRepository implements IMessageRepository {
  final FirebaseFirestore _firestore;

  FirestoreMessageRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<ChatModel>> watchChats(String uid) {
    return _firestore
        .collection('chats')
        .where('participantIds', arrayContains: uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => ChatModel.fromJson(doc.data())).toList());
  }

  @override
  Stream<List<MessageModel>> watchMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => MessageModel.fromJson(doc.data())).toList());
  }

  @override
  Future<void> sendMessage(String chatId, MessageModel message) async {
    final batch = _firestore.batch();
    final chatRef = _firestore.collection('chats').doc(chatId);
    final msgRef = chatRef.collection('messages').doc(message.id);

    batch.set(msgRef, message.toJson());
    batch.update(chatRef, {
      'lastMessage': message.text,
      'lastMessageAt': message.createdAt,
    });

    await batch.commit();
  }

  @override
  Future<String> getOrCreateChat(String uid1, String uid2) async {
    final query = await _firestore
        .collection('chats')
        .where('participantIds', arrayContains: uid1)
        .get();

    for (var doc in query.docs) {
      List<dynamic> ids = doc.data()['participantIds'];
      if (ids.contains(uid2)) return doc.id;
    }

    final newChat = _firestore.collection('chats').doc();
    await newChat.set({
      'id': newChat.id,
      'participantIds': [uid1, uid2],
      'lastMessage': '',
      'lastMessageAt': FieldValue.serverTimestamp(),
      'unreadCounts': {uid1: 0, uid2: 0},
    });

    return newChat.id;
  }

  @override
  Future<void> setTypingStatus(String chatId, String uid, bool isTyping) async {
    await _firestore.collection('chats').doc(chatId).update({
      'typingStatus.$uid': isTyping,
    });
  }
}
