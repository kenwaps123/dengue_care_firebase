import 'package:denguecare_firebase/utility/utils.dart';
import 'package:denguecare_firebase/views/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'users/user_registerpage.dart';
import 'widgets/input_email_widget.dart';
import 'widgets/input_password_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String _selectedUserType = 'User';
  final List<String> _userTypes = ['User', 'Admin'];
  bool _isPasswordNotVisible = true;
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

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
                elevation: 8,
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/logo-no-background.png'),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _selectedUserType,
                          items: _userTypes.map((String userType) {
                            return DropdownMenuItem<String>(
                              value: userType,
                              child: Text(
                                userType,
                                style: GoogleFonts.poppins(fontSize: 16),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedUserType = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        InputEmailWidget(
                          hintText: "Email",
                          controller: emailController,
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        InputPasswordWidget(
                          hintText: "Password",
                          controller: passwordController,
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
                            //padding: const EdgeInsets.symmetric(vertical: 5),
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
                              if (_formKey.currentState!.validate()) {
                                signIn();
                              }
                            },
                            child: Text(
                              "Login",
                              style: GoogleFonts.poppins(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Visibility(
                          visible: _selectedUserType == "User",
                          child: InkWell(
                            onTap: () {
                              Get.to(() => const UserRegisterPage());
                            },
                            child: Text(
                              "Don't have an account? Sign up now!",
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.blue),
                            ),
                          ),
                        )
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

  Future signIn() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }

    Get.offAll(() => const HomePage());
  }
}
