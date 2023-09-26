import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class InputContactNumber extends StatelessWidget {
  const InputContactNumber({
    super.key,
    required this.hintText,
    this.controller,
    required this.obscureText,
    this.initialVal,
    this.enableTextInput,
  });

  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final String? initialVal;
  final bool? enableTextInput;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
          FilteringTextInputFormatter.digitsOnly,
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        obscureText: obscureText,
        initialValue: initialVal,
        controller: controller,
        enabled: enableTextInput,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(fontSize: 14),
        ), // contentPadding: const EdgeInsets.symmetric(horizontal: 20)),
      ),
    );
  }
}
