import 'package:flutter/material.dart';

SnackBar mySnackbar(String message) {
  return SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    backgroundColor: Colors.black.withOpacity(0.9),
    margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
  );
}