import 'package:cloud_firestore/cloud_firestore.dart';
import 'post_model.dart';

class PaginatedPosts {
  final List<PostModel> posts;
  final DocumentSnapshot? lastDoc;
  final bool hasMore;

  PaginatedPosts({
    required this.posts,
    this.lastDoc,
    required this.hasMore,
  });
}
