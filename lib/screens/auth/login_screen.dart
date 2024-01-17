import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/utils/validation.dart';
import 'package:ventureit/widgets/loader_overlay.dart';
import 'package:ventureit/widgets/primary_button.dart';

class LogInScreen extends ConsumerStatefulWidget {
  const LogInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  final _form = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordLocked = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void logIn() {
    if (_form.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).login(
            context: context,
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
    }
  }

  void logInWithGoogle() {
    ref.read(authControllerProvider.notifier).loginWithGoogle(context);
  }

  void continueAsGuest() {
    Routemaster.of(context).replace('/member');
  }

  void navigateToRegister() {
    Routemaster.of(context).replace('/register');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      body: LoaderOverlay(
        isLoading: isLoading,
        child: SafeArea(
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
                  const SizedBox(height: 20),
                  PrimaryButton(
                    onPress: logIn,
                    child: const Text('Login'),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Divider(),
                        ),
                      ),
                      Text('or'),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Divider(),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: logInWithGoogle,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: const Text('Continue with Google'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: continueAsGuest,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: const Text('Continue as Guest'),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account yet? "),
                      GestureDetector(
                        onTap: navigateToRegister,
                        child: const Text(
                          'Register',
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
    );
  }
}
