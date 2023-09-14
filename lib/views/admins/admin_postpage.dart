import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'admin_homepage.dart';

String imageUrl = '';
String userName = '';

class AdminPostPage extends StatefulWidget {
  const AdminPostPage({super.key});

  @override
  State<AdminPostPage> createState() => _AdminPostPageState();
}

class _AdminPostPageState extends State<AdminPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Post'),
        leading: BackButton(
          onPressed: () {
            Get.offAll(() => const AdminMainPage());
          },
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.check))],
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: '',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    children: [
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                  Icons.add_photo_alternate_outlined),
                              onPressed: () {},
                              label: const Text('Upload an image'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> retrieveName() async {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  if (user == null) {
    return ''; // Return an empty string or handle the case when the user is not authenticated
  }

  final docSnapshot = await firestore.collection('users').doc(user.uid).get();
  final userData = docSnapshot.data();

  if (userData != null && userData.containsKey('name')) {
    return userData['name'] as String;
  } else {
    return ''; // Handle the case when 'name' field is missing
  }
}

void imgPickUpload() async {
  final ImagePicker picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    File image = File(pickedFile.path);
    Reference ref =
        FirebaseStorage.instance.ref().child('images/your_image_name.jpg');
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
    imageUrl = await snapshot.ref.getDownloadURL();
  }
}

void postUpload() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = auth.currentUser;

  FirebaseFirestore.instance.collection('posts').add({
    'imageUrl': imageUrl,
    'caption': 'Your caption',
    'postDetails': 'Details',
    'uploaderName':
        user!.displayName, // Assuming the displayName is set for Firebase user.
    'uploaderUID': user.uid
  });
}
