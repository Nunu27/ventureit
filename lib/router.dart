import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/screens/admin_screens/dashboard.dart';
import 'package:ventureit/screens/admin_screens/submission/submissions_screen.dart';
import 'package:ventureit/screens/auth/login_screen.dart';
import 'package:ventureit/screens/auth/register_screen.dart';
import 'package:ventureit/screens/member_screens/bottom_tabs.dart';
import 'package:ventureit/screens/member_screens/business/business_screen.dart';
import 'package:ventureit/screens/member_screens/business/edit_business_screen.dart';
import 'package:ventureit/screens/member_screens/explore_screen.dart';
import 'package:ventureit/screens/member_screens/missions_screen.dart';
import 'package:ventureit/screens/member_screens/profile/edit_profile_screen.dart';
import 'package:ventureit/screens/member_screens/profile/profile_screen.dart';
import 'package:ventureit/screens/member_screens/submission/add_submission_screen.dart';
import 'package:ventureit/screens/member_screens/submission/my_submissions_screen.dart';
import 'package:ventureit/screens/member_screens/submission/submission_manual_screen.dart';

final routes = RouteMap(
  onUnknownRoute: (path) => const Redirect('/member'),
  routes: {
    '/login': (_) => const MaterialPage(child: LogInScreen()),
    '/register': (_) => const MaterialPage(child: RegisterScreen()),
    '/member': (_) => const TabPage(
          child: BottomTabs(),
          paths: ['/member/explore', '/member/missions', '/member/profile'],
        ),
    '/member/explore': (_) => const MaterialPage(child: ExploreScreen()),
    '/member/missions': (_) => const MaterialPage(child: MissionsScreen()),
    '/member/profile': (_) => const MaterialPage(child: ProfileScreen()),
    '/member/edit-profile': (_) =>
        const MaterialPage(child: EditProfileScreen()),
    '/member/submission-manual': (_) =>
        const MaterialPage(child: SubmissionManualScreen()),
    '/member/my-submissions': (_) =>
        const MaterialPage(child: MySubmissionsScreen()),
    '/member/add-submission': (_) =>
        const MaterialPage(child: AddSubmissionScreen()),
    '/member/business/:id': (route) =>
        const MaterialPage(child: BusinessScreen()),
    '/member/business/:id/edit': (_) =>
        const MaterialPage(child: EditBusinessScreen()),
    '/admin': (_) => const TabPage(
          child: Dashboard(),
          paths: ['/admin/submissions', '/admin/profile'],
        ),
    '/admin/submissions': (_) => const MaterialPage(
          child: SubmissionsScreen(),
        ),
    '/admin/profile': (_) => const MaterialPage(
          child: ProfileScreen(isDashboard: true),
        ),
  },
);
