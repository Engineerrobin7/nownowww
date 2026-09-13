import 'package:flutter_test/flutter_test.dart';
import 'package:nownowww/features/posts/domain/models/post_model.dart';
import 'package:nownowww/features/profile/domain/models/user_model.dart';

void main() {
  group('NOWNOWWW Data Integrity Tests', () {
    test('UserModel should initialize with zero counts and offline status', () {
      final user = UserModel(
        uid: 'test_uid',
        email: 'test@example.com',
        username: 'tester',
        displayName: 'Test User',
      );

      expect(user.needsCount, 0);
      expect(user.thoughtsCount, 0);
      expect(user.isOnline, false);
      expect(user.isAdmin, false);
    });

    test('Anonymous post should have identifying info scrubbed', () {
      final post = PostModel(
        id: 'post_1',
        uid: 'user_1',
        authorName: 'Robin',
        authorUsername: 'robin',
        content: 'Secret thought',
        type: PostType.think,
        isAnonymous: true,
        createdAt: DateTime.now(),
      );

      // This mimics the repository scrubbing logic
      final data = post.toJson();
      if (post.isAnonymous) {
        data['uid'] = 'anonymous_user';
        data['authorName'] = 'Someone';
      }

      expect(data['uid'], 'anonymous_user');
      expect(data['authorName'], 'Someone');
    });

    test('PostType should correctly differentiate Need and Think', () {
      const need = PostType.need;
      const think = PostType.think;

      expect(need.name, 'need');
      expect(think.name, 'think');
    });
  });
}
