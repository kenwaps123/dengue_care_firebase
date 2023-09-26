import 'package:flutter/material.dart';

class UtilSuccess {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSuccessSnackBar({
    String? text,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color backgroundColor = Colors.green,
  }) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white), // success icon
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
      duration: duration,
      action: action,
      backgroundColor: backgroundColor,
    );

    messengerKey.currentState!.removeCurrentSnackBar();
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
