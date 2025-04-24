import 'package:flutter/material.dart';

class InputStyleDecoration {
  static InputDecoration style() {
    return const InputDecoration(
      errorStyle: TextStyle(fontSize: 18),
      errorMaxLines: 3,
    );
  }
}
