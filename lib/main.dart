import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/firebase_options.dart';
import 'package:ventureit/router.dart';
import 'package:ventureit/theme/color_schemes.dart';
import 'package:ventureit/utils/utils.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyBackButtonDispatcher extends RootBackButtonDispatcher {
  @override
  Future<bool> didPopRoute() async {
    // Close any open modal
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop();
      return true;
    }
    return super.didPopRoute();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  bool isLoading = true;

  void getUserData() async {
    await ref.read(authControllerProvider.notifier).getCurrentUser();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'VentureIt',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      scaffoldMessengerKey: snackbarKey,
      backButtonDispatcher: MyBackButtonDispatcher(),
      routerDelegate: RoutemasterDelegate(
        navigatorKey: navigatorKey,
        routesBuilder: (context) => routes,
      ),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
