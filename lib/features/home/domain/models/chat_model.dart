import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@freezed
class ChatModel with _$ChatModel {
  const factory ChatModel({
    required String id,
    required List<String> participantIds,
    required String lastMessage,
    required DateTime lastMessageAt,
    @Default({}) Map<String, int> unreadCounts,
    @Default({}) Map<String, bool> typingStatus,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);
}
