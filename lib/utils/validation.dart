import 'package:ventureit/utils/utils.dart';

final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

// Auth

String? validateEmail(String? value) {
  if (value!.isEmpty) return "Enter email!";
  if (!emailRegex.hasMatch(value)) return "Please enter a valid email";
  return null;
}

String? validateUsername(String? value) {
  if (value!.isEmpty) return "Enter username!";
  if (value.length < 5) return "Username need to be atleast 5 characters";
  return null;
}

String? validatePassword(String? value) {
  if (value!.isEmpty) return "Enter password!";
  if (value.length < 6) return "Password need to be atleast 6 characters";
  return null;
}

String? validateUrl(String? value) {
  if (value!.isEmpty) return "Enter url!";
  final host = Uri.tryParse(value)?.host;
  if (host == null || host.isEmpty) return ('Invalid url');
  return null;
}

// Business general

// Business product
String? validateProductName(String? value) {
  if (value?.isEmpty ?? false) return "Enter product name";
  return null;
}

String? validateProductPrice(String? value) {
  if (value?.isEmpty ?? false) return "Enter product price";
  if (getNumber(value ?? '') <= 0) {
    return 'Must be positive number greater than zero';
  }
  return null;
}

String? validatePositiveNumber(String? value) {
  if (value?.isEmpty ?? false) return "Enter a number";
  if (getNumber(value ?? '') <= 0) {
    return 'Must be positive number greater than zero';
  }
  return null;
}
