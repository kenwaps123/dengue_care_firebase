import 'dart:convert';

//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:denguecare_firebase/main.dart';
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

  Future<bool> sendSMS(String message, List<String> phoneNumbers) async {
    final url = Uri.parse(baseUrl);
    final headers = {
      'Access-Control-Allow-Origin': '*', // Required for CORS support to work
      'Access-Control-Allow-Methods': 'POST',
      'Authorization': 'apikey $apikey',
      'Access-Control-Request-Headers': 'Content-Type, application/json',
      'Access-Control-Max-Age': '3600',
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
  final apikey = dotenv.env['apikey'] ?? '';
  // final SemaphoreAPI semaphoreAPI = SemaphoreAPI();
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
                              sendSMS();
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

  Future<void> sendSMS() async {
    final apikey = dotenv.env['apikey'] ?? '';
    dotenv.load();
    final number = phoneController.text;
    final message = announcementController.text;

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
      print('SMS sent successfully');
      print(response.body);
    } else {
      print('Failed to send SMS');
      print(response.body);
    }

    phoneController.clear();
    announcementController.clear();
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
