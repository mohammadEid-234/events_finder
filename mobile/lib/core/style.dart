import 'dart:ui';

import 'package:flutter/material.dart';

const mainColor =  Color(0xFF2F6BFF);
const fillColor =  Color(0xFFF4F6F8);
const fillText  = Color(0xFF595757);
const inputBorderRadius = 12.0;
void showErrorDialog(BuildContext context, String message) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}