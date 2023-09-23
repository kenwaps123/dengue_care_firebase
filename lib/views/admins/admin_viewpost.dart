import 'package:denguecare_firebase/views/admins/admin_homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/post_list.dart';

class AdminViewPost extends StatelessWidget {
  final Map<String, dynamic> post;

  const AdminViewPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        leading: BackButton(
          onPressed: () {
            Get.offAll(() => const AdminMainPage());
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
