import 'package:denguecare_firebase/views/home_page.dart';
import 'package:denguecare_firebase/views/widgets/input_contact_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import '../../utility/utils.dart';
import '../login_page.dart';
import '../widgets/input_age_widget.dart';
import '../widgets/input_confirmpass_widget.dart';
import '../widgets/input_email_widget.dart';
import '../widgets/input_widget.dart';
import 'dart:async';

// Define a Timer variable
late Timer _resendOTPTimer;

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({super.key});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordNotVisible = true;
  final _formKey = GlobalKey<FormState>();
  final String userType = 'User';
  var verificationId = ''.obs;
  int _remainingTime = 60;
  String _otpCode = '';
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _sexController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 118, 162, 120),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Form(
              key: _formKey,
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  constraints: const BoxConstraints(maxWidth: 370),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/logo-no-background.png'),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                        InputWidget(
                          hintText: "Name",
                          controller: _nameController,
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        InputAgeWidget(
                          hintText: "Age",
                          controller: _ageController,
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        InputWidget(
                          hintText: "Sex",
                          controller: _sexController,
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        InputContactNumber(
                            hintText: "Contact Number (11-digit)",
                            controller: _contactNumberController,
                            obscureText: false),
                        const SizedBox(height: 20),
                        InputEmailWidget(
                          hintText: "Email",
                          controller: _emailController,
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        InputConfirmPassWidget(
                          hintText: "Password",
                          controller: _passwordController,
                          confirmController: _confirmPasswordController,
                          obscureText: _isPasswordNotVisible,
                          iconButton: IconButton(
                            icon: Icon(_isPasswordNotVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isPasswordNotVisible = !_isPasswordNotVisible;
                              });
                            },
                          ),
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
                            onPressed: () {
                              // if (_formKey.currentState!.validate()) {
                              //   signUp(
                              //       _emailController.text,
                              //       _confirmPasswordController.text,
                              //       _nameController.text,
                              //       _ageController.text,
                              //       _sexController.text,
                              //       _sexController.text,
                              //       userType);
                              // }
                              _showOTPDialog(context);
                            },
                            child: Text("Register",
                                style: GoogleFonts.poppins(fontSize: 20)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        InkWell(
                          onTap: () {
                            Get.to(() => const LoginPage());
                          },
                          child: Text(
                            "Already have an accont? Sign in!",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
//! SHOWDIALOG POP UP

  void _showOTPDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _cardOTPDialog();
      },
    );
  }

  Widget _cardOTPDialog() {
    return AlertDialog(
      title: Text(
        'Verify your phone number',
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Card(
        child: Container(
          padding: const EdgeInsets.all(32.0),
          constraints: const BoxConstraints(maxWidth: 370),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Verify your phone number',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'A 6-digit OTP code is sent to your phone',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  OTPTextField(
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    style: GoogleFonts.poppins(fontSize: 18),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.underline,
                    inputFormatter: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onCompleted: (pin) {
                      _otpCode = pin;
                      print(_otpCode);
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Time Left: $_remainingTime seconds',
                    style: GoogleFonts.poppins(fontSize: 12),
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
                      onPressed: () {},
                      child: Text("Confirm",
                          style: GoogleFonts.poppins(fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

//! SIGN UP
  void signUp(String email, String password, String name, String age,
      String sex, String contactnumber, String userType) async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFirestore(
                    email, name, age, sex, contactnumber, userType)
              })
          .catchError((e) {
        Utils.showSnackBar(e.message);
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
  }

  postDetailsToFirestore(String email, String name, String age, String sex,
      String contactnumber, String userType) async {
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({
      'email': _emailController.text,
      'name': _nameController.text,
      'age': _ageController.text,
      'sex': _sexController.text,
      'contact_number': _contactNumberController.text,
      'role': userType
    });

    Get.offAll(() => const HomePage());
  }

//!FOR OTP
  Future<void> sendOTP(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) {
        // Automatically handled on some devices
      },
      verificationFailed: (e) {
        Utils.showSnackBar(e.message);
      },
      codeSent: (verificationId, resendToken) {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId.value = verificationId;
      },
    );
  }

  Future<void> verifyOTP(String verificationId, String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      // User is successfully authenticated.
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  void startResendOTPTimer() {
    const duration = Duration(minutes: 1); // Adjust the duration as needed
    _resendOTPTimer = Timer(duration, () {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          // Time is up, stop the timer
          cancelResendOTPTimer();
        }
      });
      // Automatically resend OTP after the timer expires
      sendOTP(_contactNumberController
          .text); // Replace userPhoneNumber with the actual phone number
    });
  }

// Function to cancel the timer
  void cancelResendOTPTimer() {
    if (_resendOTPTimer.isActive) {
      _resendOTPTimer.cancel();
    }
  }

  // Function to initiate OTP verification and start the timer
  Future<void> initiateOTPVerification(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Automatically handled on some devices
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure
        },
        codeSent: (String verificationId, resendToken) {
          // Store verificationId and resendToken
          startResendOTPTimer(); // Start the timer when OTP is sent
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout
        },
      );
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }
}
