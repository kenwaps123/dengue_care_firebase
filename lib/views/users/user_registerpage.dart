import 'package:denguecare_firebase/utility/utils_success.dart';
import 'package:denguecare_firebase/views/users/user_homepage.dart';
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
  var _verificationId = ''.obs;
  final int _remainingTime = 60;
  var _otpCode;
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
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _formKey,
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 370),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/logo-no-background.png'),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                        Text(
                          "USER REGISTRATION",
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
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
                            hintText: "Contact Number (10-digit)",
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
                            onPressed: () async {
                              try {
                                if (_formKey.currentState!.validate()) {
                                  String num =
                                      "+63${_contactNumberController.text}";
                                  _showOTPDialog(context);
                                  verifyPhone(num);
                                }
                              } on FirebaseAuthException catch (e) {
                                Utils.showSnackBar(e.message);
                              }
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
                      //print(_otpCode);
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
                      onPressed: () async {
                        // if (_otpCode.isNotEmpty) {
                        // } else {
                        //   Utils.showSnackBar("Please enter the OTP code.");
                        // }
                        try {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                            verificationId: _verificationId.value,
                            smsCode: _otpCode,
                          );
                          await _auth.signInWithCredential(credential);
                          signUp(
                              _emailController.text.trim(),
                              _confirmPasswordController.text.trim(),
                              _nameController.text.trim(),
                              _ageController.text.trim(),
                              _sexController.text.trim(),
                              _contactNumberController.text.trim(),
                              userType);
                          UtilSuccess.showSuccessSnackBar(
                              text: "Success",
                              action: SnackBarAction(
                                  label: 'Text', onPressed: () {}));
                          // Handle user registration completion
                        } on FirebaseAuthException catch (e) {
                          Utils.showSnackBar(e.message);
                        }
                      },
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
        return Utils.showSnackBar(e.message);
      });
    } on FirebaseAuthException catch (e) {
      //print(e);
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

    Get.offAll(() => const UserMainPage());
  }

  Future<void> verifyPhone(String phoneNumber) async {
    verificationCompleted(PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);

      // Handle user registration completion
    }

    verificationFailed(FirebaseAuthException e) {
      // Handle verification failure
      Utils.showSnackBar(e.message);
    }

    codeSent(String verificationId, [int? resendToken]) async {
      // Store the verification ID
      _verificationId = verificationId.obs;
    }

    codeAutoRetrievalTimeout(String verificationId) {
      // Auto retrieval timeout, handle it if needed
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }
}
