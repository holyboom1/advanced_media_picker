import 'package:flutter/material.dart';

class CloseAlertStyle {
  final String title;
  final String message;
  final String positiveButtonText;
  final String negativeButtonText;
  final TextStyle titleTextStyle;
  final TextStyle messageTextStyle;
  final TextStyle positiveButtonTextStyle;
  final TextStyle negativeButtonTextStyle;
  final BoxDecoration containerDecoration;

  CloseAlertStyle({
    required this.title,
    required this.message,
    required this.positiveButtonText,
    required this.negativeButtonText,
    this.titleTextStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    this.messageTextStyle = const TextStyle(
      fontSize: 16,
    ),
    this.positiveButtonTextStyle = const TextStyle(
      fontSize: 16,
      color: Colors.blue,
    ),
    this.negativeButtonTextStyle = const TextStyle(
      fontSize: 16,
      color: Colors.red,
    ),
    this.containerDecoration = const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  });
}
