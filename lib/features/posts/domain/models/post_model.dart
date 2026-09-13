import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

enum PostType { need, think }

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String uid,
    required String authorName,
    required String authorUsername,
    String? authorPhotoUrl,
    required String content,
    required PostType type,
    @Default([]) List<String> topics,
    @Default(false) bool isAnonymous,
    @Default(0) int likesCount,
    @Default(0) int commentCount,
    @Default(0) int shareCount,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? location,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
}
