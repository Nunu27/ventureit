final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

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
