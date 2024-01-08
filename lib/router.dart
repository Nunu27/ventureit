import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/screens/auth/signin_screen.dart';
import 'package:ventureit/screens/auth/signup_screen.dart';
import 'package:ventureit/screens/bottom_tabs.dart';
import 'package:ventureit/screens/explore_screen.dart';
import 'package:ventureit/screens/missions_screen.dart';
import 'package:ventureit/screens/profile_screen.dart';

final loggedOutRoute = RouteMap(
  onUnknownRoute: (path) => const Redirect('/signin'),
  routes: {
    '/signin': (_) => const MaterialPage(child: SignInScreen()),
    '/signup': (_) => const MaterialPage(child: SignUpScreen()),
  },
);
final loggedInRoute = RouteMap(
  onUnknownRoute: (path) => const Redirect('/'),
  routes: {
    '/': (_) => const TabPage(
          child: BottomTabs(),
          paths: ['/explore', '/missions', '/profile'],
        ),
    '/explore': (_) => const MaterialPage(child: ExploreScreen()),
    '/missions': (_) => const MaterialPage(child: MissionsScreen()),
    '/profile': (_) => const MaterialPage(child: ProfileScreen()),
  },
);
