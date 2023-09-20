import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denguecare_firebase/utility/utils_success.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../utility/utils.dart';
import 'admin_homepage.dart';

String imageUrl = '';
String userName = '';
final TextEditingController _titleController = TextEditingController();
final TextEditingController _contentController = TextEditingController();
File? _selectedImage;
File? image;

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
            clearAllInputs();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                postUpload();
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          width: 350,
                          height: 350,
                          fit: BoxFit.cover,
                        )
                      : const Placeholder(
                          fallbackHeight: 300,
                          fallbackWidth: 300,
                        ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _contentController,
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
                              onPressed: () {
                                imgPickUpload();
                              },
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

  void clearAllInputs() {
    setState(() {
      _titleController.clear();
      _contentController.clear();
      // other input resets if any
      _selectedImage = null;
      imageUrl = '';
    });
  }

  void imgPickUpload() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    try {
      if (pickedFile != null) {
        image = File(pickedFile.path);

        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  void postUpload() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    try {
      String imageName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child('images/$imageName');
      UploadTask uploadTask = ref.putFile(image!);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
      imageUrl = await snapshot.ref.getDownloadURL();

      FirebaseFirestore.instance.collection('posts').add({
        'imageUrl': imageUrl,
        'caption': _titleController.text.trim(),
        'postDetails': _contentController.text.trim(),
        'uploaderEmail':
            user!.email, // Assuming the displayName is set for Firebase user.
        'uploaderUID': user.uid,
      });
      UtilSuccess.showSnackBar('Success!');
    } catch (e) {
      //  Utils.showSnackBar(e.toString());
    }
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
