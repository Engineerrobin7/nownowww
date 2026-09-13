import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import 'package:nownowww/features/home/data/repositories/firestore_message_repository.dart';
import 'package:nownowww/features/home/domain/models/chat_model.dart';
import 'package:nownowww/features/home/domain/models/message_model.dart';
import 'package:nownowww/features/home/domain/repositories/message_repository.dart';

part 'message_providers.g.dart';

@riverpod
IMessageRepository messageRepository(MessageRepositoryRef ref) {
  return FirestoreMessageRepository();
}

@riverpod
Stream<List<ChatModel>> userChats(UserChatsRef ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return ref.watch(messageRepositoryProvider).watchChats(user.uid);
}

@riverpod
Stream<List<MessageModel>> chatMessages(ChatMessagesRef ref, String chatId) {
  return ref.watch(messageRepositoryProvider).watchMessages(chatId);
}
