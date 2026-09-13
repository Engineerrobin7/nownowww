import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    required String postId,
    required String uid,
    required String authorName,
    required String authorUsername,
    String? authorPhotoUrl,
    required String content,
    @Default(0) int replyCount,
    @Default(0) int likesCount,
    required DateTime createdAt,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
}

@freezed
class ReplyModel with _$ReplyModel {
  const factory ReplyModel({
    required String id,
    required String commentId,
    required String postId,
    required String uid,
    required String authorName,
    required String authorUsername,
    String? authorPhotoUrl,
    required String content,
    @Default(0) int likesCount,
    required DateTime createdAt,
  }) = _ReplyModel;

  factory ReplyModel.fromJson(Map<String, dynamic> json) => _$ReplyModelFromJson(json);
}
