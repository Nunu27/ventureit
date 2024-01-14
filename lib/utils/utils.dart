import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/models/failure.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
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

Failure getError(Object e) {
  if (e is FirebaseAuthException) {
    return Failure(message: e.message!);
  } else if (e is FirebaseException) {
    return Failure(message: e.message!);
  }

  return Failure(message: e.toString());
}
