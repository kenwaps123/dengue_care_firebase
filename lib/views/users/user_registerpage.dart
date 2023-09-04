import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../login_page.dart';
import '../widgets/input_age_widget.dart';
import '../widgets/input_confirmpass_widget.dart';
import '../widgets/input_widget.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({super.key});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: IntlPhoneField(
                            initialCountryCode: 'PH',
                            showCountryFlag: false,
                            disableLengthCheck: true,
                            controller: _contactNumberController,
                            decoration: InputDecoration(
                              hintText: "Contact number",
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.poppins(),
                              // border: UnderlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        InputWidget(
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
                              if (_formKey.currentState!.validate()) {}
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
}
