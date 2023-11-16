import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denguecare_firebase/views/admins/admin_homepage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String baseUrl = 'https://api.semaphore.co/api/v4/messages';
String apikey = dotenv.env['apikey'] ?? '';

class SemaphoreAPI {
  late String apikey;

  SemaphoreAPI() {
    _loadEnvironmentVariables();
  }

  Future<void> _loadEnvironmentVariables() async {
    await dotenv.load();
    apikey = dotenv.env['apikey'] ?? '';
  }
}

class AdminAnnouncementPage extends StatefulWidget {
  const AdminAnnouncementPage({super.key});

  @override
  State<AdminAnnouncementPage> createState() => _AdminAnnouncementPageState();
}

class _AdminAnnouncementPageState extends State<AdminAnnouncementPage> {
  final apikey = dotenv.env['apikey'] ?? '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController announcementController = TextEditingController();
  final reference = FirebaseFirestore.instance.collection('users');

  @override
  void dispose() {
    announcementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text('Admin Announcements'),
            leading: BackButton(
              onPressed: () {
                Get.offAll(() => const AdminMainPage());
              },
            )),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo-no-background.png'),
                      const SizedBox(height: 20),
                      Text(
                        'SEND ANNOUNCEMENTS',
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: announcementController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          labelText: 'Announcement',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                            ),
                            onPressed: () async {
                              // Show a confirmation dialog
                              bool? confirmSend =
                                  await _showConfirmationDialog(context);
                              if (confirmSend == true) {
                                sendBulk();
                                // ignore: use_build_context_synchronously
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              }
                            },
                            child: Text(
                              'Send',
                              style: GoogleFonts.poppins(fontSize: 20),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendBulk() async {
    final apikey = dotenv.env['apikey'] ?? '';
    try {
      List<String> numbers = await getPhoneNumbers();

      List<Future<void>> smsFutures = numbers
          .map((String number) =>
              sendSMS(apikey, number, announcementController.text))
          .toList();

      // Wait for all SMS futures to complete
      await Future.wait(smsFutures);
      _formKey.currentState!.reset();
    } catch (e) {
      _showSnackbarError('Failed to send SMS');
    }
  }

  Future<List<String>> getPhoneNumbers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    List<String> numbers = [];

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      String numberString = doc['contact_number'];
      // ignore: avoid_print
      print('Raw number string: $numberString');
      numbers.addAll(numberString.split(',').map((e) => e.trim()));
    }
    // ignore: avoid_print
    print('Parsed numbers: $numbers');
    return numbers;
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to send the SMS?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User clicked "Cancel"
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User clicked "OK"
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendSMS(String apikey, String number, String message) async {
    final parameters = {
      'apikey': apikey,
      'number': number,
      'message': message,
    };
    final response = await http.post(
      Uri.parse('https://api.semaphore.co/api/v4/messages'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: parameters,
    );

    if (response.statusCode == 200) {
      _showSnackbarSuccess('SMS sent successfully');
    } else {
      _showSnackbarError('Failed to send SMS');
    }

    // phoneController.clear();
    announcementController.clear();
  }

  void _showSnackbarSuccess(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _showSnackbarError(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
