import 'package:denguecare_firebase/views/admins/admin_homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAccountSettings extends StatefulWidget {
  const AdminAccountSettings({super.key});

  @override
  State<AdminAccountSettings> createState() => _AdminAccountSettingsState();
}

class _AdminAccountSettingsState extends State<AdminAccountSettings> {
  final user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: const Text("Account Settings"),
        leading: BackButton(
          onPressed: () {
            Get.offAll(() => const AdminMainPage());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Form(
              key: _formKey,
              child: Card(
                elevation: 8,
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  constraints: BoxConstraints(
                    maxWidth:
                        MediaQuery.of(context).size.width > 600 ? 400 : 300,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
