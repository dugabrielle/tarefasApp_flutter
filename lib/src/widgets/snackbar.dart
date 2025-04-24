import 'package:flutter/material.dart';

class SnackbarStyle {
  static SnackBar snackStyle(String message) {
    return SnackBar(
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      backgroundColor: Color(0xFF3B3B3B),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
    );
  }
}
