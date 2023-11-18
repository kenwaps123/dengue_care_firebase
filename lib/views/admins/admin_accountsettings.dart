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

  final TextEditingController _newemailController = TextEditingController();

  @override
  void dispose() {
    _newnameController.dispose();
    _newageController.dispose();

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
                      Image.asset('assets/images/logo-no-background.png'),
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
                            _updateUserInfo();
                          },
                          child: Text(
                            'Update',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
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

  Future<void> _updateUserInfoinFirestore(
      String uid, String newName, String newAge, String newEmail) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': newName,
        'age': newAge,
        'email': newEmail,
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _updateUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    // ignore: unused_local_variable
    bool proceed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Update'),
          content: const Text('Do you wish to proceed with the update?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if user confirms
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return false if user cancels
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
    if (proceed = true) {
      String newName = _newnameController.text;
      String newAge = _newageController.text;
      String newEmail = _newemailController.text;

      try {
        await user!.updateDisplayName(newName);
        await user.updateEmail(newEmail);
        await _updateUserInfoinFirestore(user.uid, newName, newAge, newEmail);
        await user.reload();

        // ignore: use_build_context_synchronously
        _showSnackbarSuccess(context, "User Information updated successfully");
      } catch (error) {
        // ignore: use_build_context_synchronously
        _showSnackbarError(context, error.toString());
      }
    } else {}
  }

  void _showSnackbarSuccess(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _showSnackbarError(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
