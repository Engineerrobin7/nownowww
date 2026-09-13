abstract class IBlockRepository {
  Future<void> blockUser(String blockerId, String blockedId);
  Future<void> unblockUser(String blockerId, String blockedId);
  Stream<List<String>> watchBlockedUsers(String uid);
  Future<bool> isBlocked(String blockerId, String blockedId);
}
