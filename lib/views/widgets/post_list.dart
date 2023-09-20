import 'package:denguecare_firebase/views/users/user_viewpost.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  _PostsListState createState() => _PostsListState();
}

Widget conditionalImage(String imageUrl) {
  if (kIsWeb) {
    // If the platform is web
    return Image.network(imageUrl);
  } else if (Platform.isAndroid) {
    // If the platform is Android
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  } else {
    // For other platforms (like iOS)
    return Image.network(imageUrl); // or CachedNetworkImage if you prefer
  }
}

class _PostsListState extends State<PostsList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return InkWell(
              onTap: () {
                Get.offAll(() => UserVIewPostPage(post: data));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    conditionalImage(data['imageUrl']),
                    const SizedBox(height: 8.0),
                    Text(data['caption']),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
