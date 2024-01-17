import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/screens/admin_screens/dashboard.dart';
import 'package:ventureit/screens/admin_screens/submission/submission_detail_screen.dart';
import 'package:ventureit/screens/admin_screens/submission/submissions_screen.dart';
import 'package:ventureit/screens/auth/login_screen.dart';
import 'package:ventureit/screens/auth/register_screen.dart';
import 'package:ventureit/screens/member_screens/bottom_tabs.dart';
import 'package:ventureit/screens/member_screens/business/business_screen.dart';
import 'package:ventureit/screens/member_screens/business/content_edit_business_screen.dart';
import 'package:ventureit/screens/member_screens/business/contents_screen.dart';
import 'package:ventureit/screens/member_screens/business/details_screen.dart';
import 'package:ventureit/screens/member_screens/business/edit_business_screen.dart';
import 'package:ventureit/screens/member_screens/business/gallery_screen.dart';
import 'package:ventureit/screens/member_screens/business/general_edit_business_screen.dart';
import 'package:ventureit/screens/member_screens/business/products_edit_business_screen.dart';
import 'package:ventureit/screens/member_screens/business/products_screen.dart';
import 'package:ventureit/screens/member_screens/business/reviews_screen.dart';
import 'package:ventureit/screens/member_screens/explore_screen.dart';
import 'package:ventureit/screens/member_screens/missions_screen.dart';
import 'package:ventureit/screens/member_screens/profile/edit_profile_screen.dart';
import 'package:ventureit/screens/member_screens/profile/profile_screen.dart';
import 'package:ventureit/screens/member_screens/submission/add_submission_contents.dart';
import 'package:ventureit/screens/member_screens/submission/add_submission_general.dart';
import 'package:ventureit/screens/member_screens/submission/add_submission_products.dart';
import 'package:ventureit/screens/member_screens/submission/my_submissions_screen.dart';
import 'package:ventureit/screens/member_screens/submission/submission_manual_screen.dart';

String? businessId;

final routes = RouteMap(
  onUnknownRoute: (path) => const Redirect('/member'),
  routes: {
    '/login': (_) => const MaterialPage(child: LogInScreen()),
    '/register': (_) => const MaterialPage(child: RegisterScreen()),
    '/member': (_) => const TabPage(
          child: BottomTabs(),
          paths: ['explore', 'missions', 'profile'],
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
        const MaterialPage(child: AddSubmissionGeneral()),
    '/member/add-submission/products': (_) => const TransitionPage(
        child: AddSubmissionProducts(),
        pushTransition: PageTransition.none,
        popTransition: PageTransition.none),
    '/member/add-submission/contents': (_) => const TransitionPage(
        child: AddSubmissionContents(),
        pushTransition: PageTransition.none,
        popTransition: PageTransition.none),
    '/member/business/:id': (route) => TabPage(
          child: BusinessScreen(
            businessId: route.pathParameters['id']!,
          ),
          paths: const [
            'products',
            'reviews',
            'gallery',
            'details',
            'contents',
          ],
        ),
    '/member/business/:id/products': (route) =>
        MaterialPage(child: ProductsScreen(id: route.pathParameters['id']!)),
    '/member/business/:id/reviews': (route) =>
        MaterialPage(child: ReviewsScreen(id: route.pathParameters['id']!)),
    '/member/business/:id/gallery': (route) =>
        MaterialPage(child: GalleryScreen(id: route.pathParameters['id']!)),
    '/member/business/:id/details': (route) =>
        MaterialPage(child: DetailsScreen(id: route.pathParameters['id']!)),
    '/member/business/:id/contents': (route) =>
        MaterialPage(child: ContentsScreen(id: route.pathParameters['id']!)),
    '/member/business/:id/edit': (route) {
      final id = route.pathParameters['id'];
      if (id != null) businessId = id;

      return TabPage(
        child: EditBusinessScreen(
          businessId: businessId!,
        ),
        paths: const [
          'general',
          'products',
          'content',
        ],
      );
    },
    '/member/business/:id/edit/general': (route) => MaterialPage(
          child: GeneralEditBusiness(id: route.pathParameters['id']!),
        ),
    '/member/business/:id/edit/products': (route) => MaterialPage(
          child: ProductsEditBusiness(id: route.pathParameters['id']!),
        ),
    '/member/business/:id/edit/content': (route) => MaterialPage(
          child: ContentEditBusiness(id: route.pathParameters['id']!),
        ),
    '/admin': (_) => const TabPage(
          child: Dashboard(),
          paths: ['submissions', 'profile'],
        ),
    '/admin/submissions': (_) => const MaterialPage(
          child: SubmissionsScreen(),
        ),
    '/admin/submission/:id': (route) => MaterialPage(
          child: SubmissionDetailScreen(
            id: route.pathParameters['id']!,
          ),
        ),
    '/admin/profile': (_) => const MaterialPage(
          child: ProfileScreen(isDashboard: true),
        ),
  },
);
