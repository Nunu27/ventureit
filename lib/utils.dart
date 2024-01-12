import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/models/failure.dart';

Codec<String, String> base64Converter = utf8.fuse(base64);
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

bool isGuest() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null || user.isAnonymous) return true;
  return false;
}

void showSnackBar(String message) {
  if (!snackbarKey.currentState!.mounted) return;

  snackbarKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

void showConfirmationDialog({
  required BuildContext context,
  required String title,
  bool isDismissable = false,
  String? body,
  String? optionOne,
  VoidCallback? onOptionOne,
  String? optionTwo,
  required VoidCallback onOptionTwo,
  bool useRootNavigator = true,
}) {
  Widget optionOneBtn = TextButton(
    onPressed: onOptionOne ??
        () {
          Navigator.of(context, rootNavigator: true).pop();
        },
    child: Text(optionOne ?? "Cancel"),
  );
  Widget optionTwoBtn = TextButton(
    onPressed: onOptionTwo,
    child: Text(optionTwo ?? "Continue"),
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: body == null ? null : Text(body),
    actions: [
      optionOneBtn,
      optionTwoBtn,
    ],
  );

  showDialog(
    context: context,
    barrierColor: Colors.black.withAlpha(50),
    barrierDismissible: isDismissable,
    builder: (BuildContext context) {
      return alert;
    },
    useRootNavigator: useRootNavigator,
  );
}

void checkGuest(BuildContext context) {
  if (isGuest()) {
    showConfirmationDialog(
      context: context,
      title: 'Account required',
      body: 'Please login to use this feature.',
      isDismissable: false,
      optionOne: 'Login',
      onOptionOne: () => Routemaster.of(context).replace('/login'),
      optionTwo: 'Register',
      onOptionTwo: () => Routemaster.of(context).replace('/register'),
      useRootNavigator: false,
    );
  }
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

String convertToPrecisionString(double number, {int precision = 1}) {
  String result = number.toStringAsFixed(precision);

  if (precision == 0) {
    result = result.replaceAll(RegExp(r'\.0*$'), '');
  }

  return result;
}

String formatDistance(double distance) {
  if (distance >= 500) return '${convertToPrecisionString(distance / 1000)} km';
  return '${distance.round()} m';
}

Future<Placemark> getPlacemark(Position position) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  return placemarks.first;
}

Failure getError(Object e) {
  if (e is FirebaseAuthException) {
    return Failure(message: e.message!);
  } else if (e is FirebaseException) {
    return Failure(message: e.message!);
  }

  return Failure(message: e.toString());
}
