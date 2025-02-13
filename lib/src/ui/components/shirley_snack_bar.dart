import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    PanacheSnackBar(text: text, isError: isError),
  );
}

class PanacheSnackBar extends SnackBar {
  final String text;
  final bool isError;

  PanacheSnackBar({super.key, required this.text, this.isError = false})
      : super(
          backgroundColor: Color.fromRGBO(228, 23, 73, 1),
          width: 360.0,
          content: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
        );
}
