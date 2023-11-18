import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denguecare_firebase/views/admins/admin_homepage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SemaphoreAPI {
  late String apikey;
  final String baseUrl = 'https://api.semaphore.co/api/v4/messages';

  SemaphoreAPI() {
    _loadEnvironmentVariables();
  }

  Future<void> _loadEnvironmentVariables() async {
    await dotenv.load(fileName: '.env');
    apikey = dotenv.env['apikey'] ?? '';
  }

  Future<bool> sendSMS(String message, List<String> phoneNumbers) async {
    final url = Uri.parse(baseUrl);
    final headers = {
      'Authorization': 'Bearer $apikey',
      'Content-Type': 'application/json',
    };
    final data = {
      'messages': phoneNumbers.map((phoneNumber) {
        return {'content': message, 'to': phoneNumber};
      }).toList(),
    };
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }
}

class AdminAnnouncementPage extends StatefulWidget {
  const AdminAnnouncementPage({super.key});

  @override
  State<AdminAnnouncementPage> createState() => _AdminAnnouncementPageState();
}

class _AdminAnnouncementPageState extends State<AdminAnnouncementPage> {
  final apikey = customDotenv.env['apikey'] ?? '';
  final SemaphoreAPI semaphoreAPI = SemaphoreAPI();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController announcementController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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
                      Image.asset('images/logo-no-background.png'),
                      const SizedBox(height: 20),
                      Text(
                        'SEND ANNOUNCEMENTS',
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: announcementController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
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
                              bool success = await semaphoreAPI.sendSMS(
                                announcementController.text,
                                [phoneController.text],
                              );
                              if (success) {
                                print('success');
                              } else {
                                print('fail');
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

  void sendSMS(String announcement) async {
    final announcement = announcementController.text;
    if (announcement.isNotEmpty) {
      final firestoreCollection =
          FirebaseFirestore.instance.collection('users');

      firestoreCollection.get().then((QuerySnapshot snapshot) {
        final phoneNumbers = snapshot.docs
            .map((doc) {
              return doc['contact_number'];
            })
            .whereType<String>()
            .toList();

        // Send SMS to each fetched phone number
        for (var phoneNumber in phoneNumbers) {
          semaphoreAPI.sendSMS(announcement, [phoneNumber]);
          announcementController.clear();
          continue;
        }
      }).catchError((error) {
        _showSnackbarError(
            context, 'Error fetching phone numbers from Firestore: $error');
      });
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

  void _showSnackbarError(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
