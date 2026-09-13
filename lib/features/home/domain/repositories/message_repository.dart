import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class IMessageRepository {
  Stream<List<ChatModel>> watchChats(String uid);
  Stream<List<MessageModel>> watchMessages(String chatId);
  Future<void> sendMessage(String chatId, MessageModel message);
  Future<String> getOrCreateChat(String uid1, String uid2);
  Future<void> setTypingStatus(String chatId, String uid, bool isTyping);
}
