import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/utils/validation.dart';
import 'package:ventureit/widgets/input/input_form.dart';
import 'package:ventureit/widgets/loader_overlay.dart';
import 'package:ventureit/widgets/primary_button.dart';
import 'package:ventureit/widgets/secondary_button.dart';

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
                        horizontal: 24,
                        vertical: 14,
                      ),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Email",
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 14),
                    InputForm(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      validator: validatePassword,
                      controller: passwordController,
                      obscureText: passwordLocked,
                      hintText: "Password",
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          passwordLocked = !passwordLocked;
                        }),
                        icon: Icon(
                          passwordLocked
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    PrimaryButton(
                      onPress: logIn,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Login'),
                        ],
                      ),
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
                    SecondaryButton(
                      onPressed: logInWithGoogle,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Image.asset(
                                "assets/images/site_logo/google.png"),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text("Login with Google")
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    SecondaryButton(
                      onPressed: continueAsGuest,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Continue as guest"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 45),
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
      ),
    );
  }
}
