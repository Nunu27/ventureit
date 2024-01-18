import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/controllers/modal_controller.dart';
import 'package:ventureit/firebase_options.dart';
import 'package:ventureit/router.dart';
import 'package:ventureit/theme/color_schemes.dart';
import 'package:ventureit/utils/utils.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final businessEditRegex = RegExp(r'^\/member\/business\/.*\/edit.*$');

class RouterDelegate extends RoutemasterDelegate {
  final WidgetRef _ref;

  RouterDelegate({
    required super.routesBuilder,
    super.navigatorKey,
    required WidgetRef ref,
  }) : _ref = ref;

  @override
  Future<bool> popRoute() async {
    if (modalShown) {
      navigatorKey.currentState!.pop(false);
      return true;
    } else if (_ref.read(modalControllerProvider).modalActive) {
      navigatorKey.currentState!.pop();
      return true;
    } else if (currentConfiguration!.path == '/member/add-submission' ||
        businessEditRegex.hasMatch(currentConfiguration!.path)) {
      FocusManager.instance.primaryFocus?.unfocus();

      final res =
          await showDiscardData(navigatorKey.currentState!.context, _ref);

      if (res) {
        navigatorKey.currentState!.pop();
      }
      return true;
    }

    return super.popRoute();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.requestPermission(provisional: true);
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
        fontFamily: "PlusJakartaSans",
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: "PlusJakartaSans",
        colorScheme: darkColorScheme,
      ),
      scaffoldMessengerKey: snackbarKey,
      routerDelegate: RouterDelegate(
        ref: ref,
        navigatorKey: navigatorKey,
        routesBuilder: (context) => routes,
      ),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
