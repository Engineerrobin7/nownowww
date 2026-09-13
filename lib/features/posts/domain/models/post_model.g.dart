// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      id: json['id'] as String,
      uid: json['uid'] as String,
      authorName: json['authorName'] as String,
      authorUsername: json['authorUsername'] as String,
      authorPhotoUrl: json['authorPhotoUrl'] as String?,
      content: json['content'] as String,
      type: $enumDecode(_$PostTypeEnumMap, json['type']),
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      shareCount: (json['shareCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      location: json['location'] as String?,
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'authorName': instance.authorName,
      'authorUsername': instance.authorUsername,
      'authorPhotoUrl': instance.authorPhotoUrl,
      'content': instance.content,
      'type': _$PostTypeEnumMap[instance.type]!,
      'topics': instance.topics,
      'isAnonymous': instance.isAnonymous,
      'likesCount': instance.likesCount,
      'commentCount': instance.commentCount,
      'shareCount': instance.shareCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'location': instance.location,
    };

const _$PostTypeEnumMap = {
  PostType.need: 'need',
  PostType.think: 'think',
};
