import '../models/user_model.dart';

abstract class IUserRepository {
  Future<UserModel?> getUser(String uid);
  
  Future<void> createUser(UserModel user);
  
  Future<void> updateUser(UserModel user);
  
  Future<bool> isUsernameAvailable(String username);
  
  Stream<UserModel?> watchUser(String uid);

  Future<void> followUser(String currentUid, String targetUid);
  
  Future<void> unfollowUser(String currentUid, String targetUid);

  Future<List<UserModel>> getPopularUsers();

  Future<List<UserModel>> getUsersByIds(List<String> uids);

  Future<void> updatePresence(String uid, bool isOnline);
}
