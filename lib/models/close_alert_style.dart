import 'package:flutter/material.dart';

/// Close alert style
class CloseAlertStyle {
  /// Title
  final String title;

  /// Message
  final String message;

  /// Positive button text
  final String positiveButtonText;

  /// Negative button text
  final String negativeButtonText;

  /// Title text style
  final TextStyle titleTextStyle;

  /// Message text style
  final TextStyle messageTextStyle;

  /// Positive button text style
  final TextStyle positiveButtonTextStyle;

  /// Negative button text style
  final TextStyle negativeButtonTextStyle;

  /// Container decoration
  final BoxDecoration containerDecoration;

  /// Close alert style
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
