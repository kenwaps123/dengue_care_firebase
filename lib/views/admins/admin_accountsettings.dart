import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denguecare_firebase/views/admins/admin_homepage.dart';
import 'package:denguecare_firebase/views/widgets/input_age_widget.dart';
import 'package:denguecare_firebase/views/widgets/input_email_widget.dart';
import 'package:denguecare_firebase/views/widgets/input_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: const Color.fromARGB(255, 118, 162, 120),
      appBar: AppBar(
        title: const Text("Account Settings"),
        leading: BackButton(
          onPressed: () {
            Get.offAll(() => const AdminMainPage());
          },
        ),
      ),
      body: const AdminEdit(),
    );
  }
}

class AdminEdit extends StatefulWidget {
  const AdminEdit({super.key});

  @override
  State<AdminEdit> createState() => _AdminEditState();
}

class _AdminEditState extends State<AdminEdit> {
  final FirebaseAuth aw = FirebaseAuth.instance;
  final TextEditingController _newnameController = TextEditingController();
  final TextEditingController _newageController = TextEditingController();
  final TextEditingController _newsexController = TextEditingController();
  final TextEditingController _newemailController = TextEditingController();
  String? _message = '';

  @override
  void dispose() {
    _newnameController.dispose();
    _newageController.dispose();
    _newsexController.dispose();
    _newemailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(); // Loading indicator
        }
        Map<String, dynamic> userData =
            snapshot.data!.data() as Map<String, dynamic>;
        _newnameController.text = userData['name'] ?? '';
        _newageController.text = userData['age'] ?? '';
        _newsexController.text = userData['sex'] ?? '';
        _newemailController.text = userData['email'] ?? '';
        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  constraints: const BoxConstraints(
                    maxWidth: 370,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/logo-no-background.png'),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      Text(
                        "EDIT USER INFO",
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      InputWidget(
                        hintText: "Update Name",
                        controller: _newnameController,
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      InputAgeWidget(
                        hintText: "Update Age",
                        controller: _newageController,
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      InputWidget(
                        hintText: "Update Sex",
                        controller: _newsexController,
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      InputEmailWidget(
                        hintText: "Update Email",
                        controller: _newemailController,
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                          ),
                          onPressed: () async {
                            _updateUserInfo;
                          },
                          child: Text(
                            'Update',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Text(_message ?? ''),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateUserInfoinFirestore(String uid, String newName,
      String newAge, String newSex, String newEmail) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': newName,
        'age': newAge,
        'sex': newSex,
        'email': newEmail,
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _updateUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    String newName = _newnameController.text;
    String newAge = _newageController.text;
    String newSex = _newsexController.text;
    String newEmail = _newemailController.text;
    try {
      await user!.updateDisplayName(newName);
      await user.updateEmail(newEmail);
      await _updateUserInfoinFirestore(
          user.uid, newName, newAge, newSex, newEmail);
      await user.reload();
      setState(() {
        _message = 'User Information updated successfully';
      });
    } catch (error) {
      setState(() {
        _message = 'Error updating user info';
      });
    }
  }
}
