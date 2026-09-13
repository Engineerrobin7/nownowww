import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    required String username,
    required String displayName,
    String? bio,
    String? photoUrl,
    @Default(0) int followingCount,
    @Default(0) int followersCount,
    @Default(0) int postsCount,
    @Default(0) int needsCount,
    @Default(0) int thoughtsCount,
    @Default(0) int commentsCount,
    @Default(false) bool isOnline,
    @Default(false) bool isAdmin,
    DateTime? lastSeen,
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
