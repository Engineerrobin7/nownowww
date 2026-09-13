// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) {
  return _CommentModel.fromJson(json);
}

/// @nodoc
mixin _$CommentModel {
  String get id => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String get authorUsername => throw _privateConstructorUsedError;
  String? get authorPhotoUrl => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  int get replyCount => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommentModelCopyWith<CommentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentModelCopyWith<$Res> {
  factory $CommentModelCopyWith(
          CommentModel value, $Res Function(CommentModel) then) =
      _$CommentModelCopyWithImpl<$Res, CommentModel>;
  @useResult
  $Res call(
      {String id,
      String postId,
      String uid,
      String authorName,
      String authorUsername,
      String? authorPhotoUrl,
      String content,
      int replyCount,
      int likesCount,
      DateTime createdAt});
}

/// @nodoc
class _$CommentModelCopyWithImpl<$Res, $Val extends CommentModel>
    implements $CommentModelCopyWith<$Res> {
  _$CommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? uid = null,
    Object? authorName = null,
    Object? authorUsername = null,
    Object? authorPhotoUrl = freezed,
    Object? content = null,
    Object? replyCount = null,
    Object? likesCount = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorUsername: null == authorUsername
          ? _value.authorUsername
          : authorUsername // ignore: cast_nullable_to_non_nullable
              as String,
      authorPhotoUrl: freezed == authorPhotoUrl
          ? _value.authorPhotoUrl
          : authorPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      replyCount: null == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentModelImplCopyWith<$Res>
    implements $CommentModelCopyWith<$Res> {
  factory _$$CommentModelImplCopyWith(
          _$CommentModelImpl value, $Res Function(_$CommentModelImpl) then) =
      __$$CommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String postId,
      String uid,
      String authorName,
      String authorUsername,
      String? authorPhotoUrl,
      String content,
      int replyCount,
      int likesCount,
      DateTime createdAt});
}

/// @nodoc
class __$$CommentModelImplCopyWithImpl<$Res>
    extends _$CommentModelCopyWithImpl<$Res, _$CommentModelImpl>
    implements _$$CommentModelImplCopyWith<$Res> {
  __$$CommentModelImplCopyWithImpl(
      _$CommentModelImpl _value, $Res Function(_$CommentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? uid = null,
    Object? authorName = null,
    Object? authorUsername = null,
    Object? authorPhotoUrl = freezed,
    Object? content = null,
    Object? replyCount = null,
    Object? likesCount = null,
    Object? createdAt = null,
  }) {
    return _then(_$CommentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorUsername: null == authorUsername
          ? _value.authorUsername
          : authorUsername // ignore: cast_nullable_to_non_nullable
              as String,
      authorPhotoUrl: freezed == authorPhotoUrl
          ? _value.authorPhotoUrl
          : authorPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      replyCount: null == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentModelImpl implements _CommentModel {
  const _$CommentModelImpl(
      {required this.id,
      required this.postId,
      required this.uid,
      required this.authorName,
      required this.authorUsername,
      this.authorPhotoUrl,
      required this.content,
      this.replyCount = 0,
      this.likesCount = 0,
      required this.createdAt});

  factory _$CommentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String postId;
  @override
  final String uid;
  @override
  final String authorName;
  @override
  final String authorUsername;
  @override
  final String? authorPhotoUrl;
  @override
  final String content;
  @override
  @JsonKey()
  final int replyCount;
  @override
  @JsonKey()
  final int likesCount;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CommentModel(id: $id, postId: $postId, uid: $uid, authorName: $authorName, authorUsername: $authorUsername, authorPhotoUrl: $authorPhotoUrl, content: $content, replyCount: $replyCount, likesCount: $likesCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorUsername, authorUsername) ||
                other.authorUsername == authorUsername) &&
            (identical(other.authorPhotoUrl, authorPhotoUrl) ||
                other.authorPhotoUrl == authorPhotoUrl) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.replyCount, replyCount) ||
                other.replyCount == replyCount) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      postId,
      uid,
      authorName,
      authorUsername,
      authorPhotoUrl,
      content,
      replyCount,
      likesCount,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentModelImplCopyWith<_$CommentModelImpl> get copyWith =>
      __$$CommentModelImplCopyWithImpl<_$CommentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentModelImplToJson(
      this,
    );
  }
}

abstract class _CommentModel implements CommentModel {
  const factory _CommentModel(
      {required final String id,
      required final String postId,
      required final String uid,
      required final String authorName,
      required final String authorUsername,
      final String? authorPhotoUrl,
      required final String content,
      final int replyCount,
      final int likesCount,
      required final DateTime createdAt}) = _$CommentModelImpl;

  factory _CommentModel.fromJson(Map<String, dynamic> json) =
      _$CommentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get postId;
  @override
  String get uid;
  @override
  String get authorName;
  @override
  String get authorUsername;
  @override
  String? get authorPhotoUrl;
  @override
  String get content;
  @override
  int get replyCount;
  @override
  int get likesCount;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$CommentModelImplCopyWith<_$CommentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReplyModel _$ReplyModelFromJson(Map<String, dynamic> json) {
  return _ReplyModel.fromJson(json);
}

/// @nodoc
mixin _$ReplyModel {
  String get id => throw _privateConstructorUsedError;
  String get commentId => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String get authorUsername => throw _privateConstructorUsedError;
  String? get authorPhotoUrl => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReplyModelCopyWith<ReplyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReplyModelCopyWith<$Res> {
  factory $ReplyModelCopyWith(
          ReplyModel value, $Res Function(ReplyModel) then) =
      _$ReplyModelCopyWithImpl<$Res, ReplyModel>;
  @useResult
  $Res call(
      {String id,
      String commentId,
      String postId,
      String uid,
      String authorName,
      String authorUsername,
      String? authorPhotoUrl,
      String content,
      int likesCount,
      DateTime createdAt});
}

/// @nodoc
class _$ReplyModelCopyWithImpl<$Res, $Val extends ReplyModel>
    implements $ReplyModelCopyWith<$Res> {
  _$ReplyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? commentId = null,
    Object? postId = null,
    Object? uid = null,
    Object? authorName = null,
    Object? authorUsername = null,
    Object? authorPhotoUrl = freezed,
    Object? content = null,
    Object? likesCount = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      commentId: null == commentId
          ? _value.commentId
          : commentId // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorUsername: null == authorUsername
          ? _value.authorUsername
          : authorUsername // ignore: cast_nullable_to_non_nullable
              as String,
      authorPhotoUrl: freezed == authorPhotoUrl
          ? _value.authorPhotoUrl
          : authorPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReplyModelImplCopyWith<$Res>
    implements $ReplyModelCopyWith<$Res> {
  factory _$$ReplyModelImplCopyWith(
          _$ReplyModelImpl value, $Res Function(_$ReplyModelImpl) then) =
      __$$ReplyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String commentId,
      String postId,
      String uid,
      String authorName,
      String authorUsername,
      String? authorPhotoUrl,
      String content,
      int likesCount,
      DateTime createdAt});
}

/// @nodoc
class __$$ReplyModelImplCopyWithImpl<$Res>
    extends _$ReplyModelCopyWithImpl<$Res, _$ReplyModelImpl>
    implements _$$ReplyModelImplCopyWith<$Res> {
  __$$ReplyModelImplCopyWithImpl(
      _$ReplyModelImpl _value, $Res Function(_$ReplyModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? commentId = null,
    Object? postId = null,
    Object? uid = null,
    Object? authorName = null,
    Object? authorUsername = null,
    Object? authorPhotoUrl = freezed,
    Object? content = null,
    Object? likesCount = null,
    Object? createdAt = null,
  }) {
    return _then(_$ReplyModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      commentId: null == commentId
          ? _value.commentId
          : commentId // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorUsername: null == authorUsername
          ? _value.authorUsername
          : authorUsername // ignore: cast_nullable_to_non_nullable
              as String,
      authorPhotoUrl: freezed == authorPhotoUrl
          ? _value.authorPhotoUrl
          : authorPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReplyModelImpl implements _ReplyModel {
  const _$ReplyModelImpl(
      {required this.id,
      required this.commentId,
      required this.postId,
      required this.uid,
      required this.authorName,
      required this.authorUsername,
      this.authorPhotoUrl,
      required this.content,
      this.likesCount = 0,
      required this.createdAt});

  factory _$ReplyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReplyModelImplFromJson(json);

  @override
  final String id;
  @override
  final String commentId;
  @override
  final String postId;
  @override
  final String uid;
  @override
  final String authorName;
  @override
  final String authorUsername;
  @override
  final String? authorPhotoUrl;
  @override
  final String content;
  @override
  @JsonKey()
  final int likesCount;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ReplyModel(id: $id, commentId: $commentId, postId: $postId, uid: $uid, authorName: $authorName, authorUsername: $authorUsername, authorPhotoUrl: $authorPhotoUrl, content: $content, likesCount: $likesCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReplyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.commentId, commentId) ||
                other.commentId == commentId) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorUsername, authorUsername) ||
                other.authorUsername == authorUsername) &&
            (identical(other.authorPhotoUrl, authorPhotoUrl) ||
                other.authorPhotoUrl == authorPhotoUrl) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      commentId,
      postId,
      uid,
      authorName,
      authorUsername,
      authorPhotoUrl,
      content,
      likesCount,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReplyModelImplCopyWith<_$ReplyModelImpl> get copyWith =>
      __$$ReplyModelImplCopyWithImpl<_$ReplyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReplyModelImplToJson(
      this,
    );
  }
}

abstract class _ReplyModel implements ReplyModel {
  const factory _ReplyModel(
      {required final String id,
      required final String commentId,
      required final String postId,
      required final String uid,
      required final String authorName,
      required final String authorUsername,
      final String? authorPhotoUrl,
      required final String content,
      final int likesCount,
      required final DateTime createdAt}) = _$ReplyModelImpl;

  factory _ReplyModel.fromJson(Map<String, dynamic> json) =
      _$ReplyModelImpl.fromJson;

  @override
  String get id;
  @override
  String get commentId;
  @override
  String get postId;
  @override
  String get uid;
  @override
  String get authorName;
  @override
  String get authorUsername;
  @override
  String? get authorPhotoUrl;
  @override
  String get content;
  @override
  int get likesCount;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ReplyModelImplCopyWith<_$ReplyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
