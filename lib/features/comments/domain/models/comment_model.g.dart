// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentModelImpl _$$CommentModelImplFromJson(Map<String, dynamic> json) =>
    _$CommentModelImpl(
      id: json['id'] as String,
      postId: json['postId'] as String,
      uid: json['uid'] as String,
      authorName: json['authorName'] as String,
      authorUsername: json['authorUsername'] as String,
      authorPhotoUrl: json['authorPhotoUrl'] as String?,
      content: json['content'] as String,
      replyCount: (json['replyCount'] as num?)?.toInt() ?? 0,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CommentModelImplToJson(_$CommentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'uid': instance.uid,
      'authorName': instance.authorName,
      'authorUsername': instance.authorUsername,
      'authorPhotoUrl': instance.authorPhotoUrl,
      'content': instance.content,
      'replyCount': instance.replyCount,
      'likesCount': instance.likesCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$ReplyModelImpl _$$ReplyModelImplFromJson(Map<String, dynamic> json) =>
    _$ReplyModelImpl(
      id: json['id'] as String,
      commentId: json['commentId'] as String,
      postId: json['postId'] as String,
      uid: json['uid'] as String,
      authorName: json['authorName'] as String,
      authorUsername: json['authorUsername'] as String,
      authorPhotoUrl: json['authorPhotoUrl'] as String?,
      content: json['content'] as String,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ReplyModelImplToJson(_$ReplyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'commentId': instance.commentId,
      'postId': instance.postId,
      'uid': instance.uid,
      'authorName': instance.authorName,
      'authorUsername': instance.authorUsername,
      'authorPhotoUrl': instance.authorPhotoUrl,
      'content': instance.content,
      'likesCount': instance.likesCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
