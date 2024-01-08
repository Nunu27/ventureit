import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/utils.dart';
import 'package:ventureit/widgets/loader.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  bool passwordLocked = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  void signUp() {
    if (_form.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).signUp(
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

  void navigateToSignIn() {
    Routemaster.of(context).replace('/signin');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      body: isLoading
          ? const Loader()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      const Text('VentureIt'),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: validateUsername,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        obscureText: passwordLocked,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          suffix: InkWell(
                            onTap: () => setState(() {
                              passwordLocked = !passwordLocked;
                            }),
                            child: Icon(
                              passwordLocked
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordConfirmationController,
                        obscureText: passwordLocked,
                        decoration: InputDecoration(
                          labelText: 'Password Confirmation',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          suffix: InkWell(
                            onTap: () => setState(() {
                              passwordLocked = !passwordLocked;
                            }),
                            child: Icon(
                              passwordLocked
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: validateConfirmation,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: signUp,
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: const Text('Sign Up'),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: navigateToSignIn,
                            child: const Text(
                              'Sign in',
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
    );
  }
}
