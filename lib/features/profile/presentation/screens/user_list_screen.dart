import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nownowww/features/profile/presentation/providers/profile_providers.dart';
import 'package:nownowww/features/profile/presentation/widgets/person_item.dart';

class UserListScreen extends ConsumerWidget {
  final String title;
  final List<String> uids;

  const UserListScreen({
    super.key,
    required this.title,
    required this.uids,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userListProvider(uids));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: usersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          return ListView.separated(
            itemCount: users.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
            itemBuilder: (context, index) => PersonItem(user: users[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
