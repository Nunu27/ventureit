import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ventureit/models/failure.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

void showSnackBar(String message) {
  snackbarKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

String? validateEmail(String? value) {
  if (value!.isEmpty) return "Enter email!";
  if (!emailRegex.hasMatch(value)) return "Please enter a valid email";
  return null;
}

String? validateUsername(String? value) {
  if (value!.isEmpty) return "Enter username!";
  if (value.length < 5) return "Password need to be atleast 5 characters";
  return null;
}

String? validatePassword(String? value) {
  if (value!.isEmpty) return "Enter password!";
  if (value.length < 6) return "Password need to be atleast 6 characters";
  return null;
}

Failure getError(Object e) {
  if (e is FirebaseAuthException) {
    return Failure(message: e.message!);
  } else if (e is FirebaseException) {
    return Failure(message: e.message!);
  }

  return Failure(message: e.toString());
}
