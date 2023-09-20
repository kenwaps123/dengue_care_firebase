import 'package:denguecare_firebase/views/users/user_homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/post_list.dart';

class UserVIewPostPage extends StatelessWidget {
  final Map<String, dynamic> post;

  const UserVIewPostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        leading: BackButton(
          onPressed: () {
            Get.offAll(() => const UserMainPage());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            conditionalImage(post['imageUrl']),
            const SizedBox(height: 8.0),
            Text(post['caption']),
            const SizedBox(height: 8.0),
            Text(post['postDetails']),
            // ... Add other details as needed
          ],
        ),
      ),
    );
  }
}
