import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/utils/validation.dart';
import 'package:ventureit/widgets/input/input_form.dart';
import 'package:ventureit/widgets/loader_overlay.dart';
import 'package:ventureit/widgets/primary_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  bool passwordLocked = true;
  bool validateLocked = true;

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  void register() {
    if (_form.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).register(
            context: context,
            fullName: fullNameController.text.trim(),
            email: emailController.text.trim(),
            username: usernameController.text.trim(),
            password: passwordController.text.trim(),
          );
    }
  }

  String? validateConfirmation(String? value) {
    final validation = validatePassword(value);
    if (validation != null) {
      return validation;
    } else if (passwordController.text == value) {
      return null;
    }

    return 'Confirmation password is different';
  }

  void navigateToLogin() {
    Routemaster.of(context).replace('/login');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    final theme = Theme.of(context);
    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: LoaderOverlay(
        isLoading: isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              height: availableHeight,
              child: Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          height: 64,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Venture",
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 36,
                          ),
                        ),
                        Text(
                          "It",
                          style: TextStyle(
                            fontSize: 36,
                            color: theme.colorScheme.onBackground,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text(
                      "Promote your business, Discover your favorite things, Let your journey begins!",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    InputForm(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      controller: emailController,
                      validator: validateEmail,
                      hintText: "Email",
                    ),
                    const SizedBox(height: 14),
                    InputForm(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      controller: fullNameController,
                      validator: validateUsername,
                      hintText: "Full name",
                    ),
                    const SizedBox(height: 14),
                    InputForm(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      controller: usernameController,
                      validator: validateUsername,
                      hintText: "Username",
                    ),
                    const SizedBox(height: 14),
                    InputForm(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      controller: passwordController,
                      obscureText: passwordLocked,
                      validator: validatePassword,
                      hintText: "Password",
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          passwordLocked = !passwordLocked;
                        }),
                        icon: Icon(passwordLocked
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    const SizedBox(height: 14),
                    InputForm(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      controller: passwordConfirmationController,
                      obscureText: validateLocked,
                      validator: validateConfirmation,
                      hintText: "Confirm password",
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          validateLocked = !validateLocked;
                        }),
                        icon: Icon(validateLocked
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    const SizedBox(height: 14),
                    PrimaryButton(
                      onPress: register,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Register"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 45),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: navigateToLogin,
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
