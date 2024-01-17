import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/constants/constants.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/models/user.dart';
import 'package:ventureit/utils/utils.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final bool isDashboard;

  const ProfileScreen({super.key, this.isDashboard = false});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void logOut(BuildContext context, WidgetRef ref) {
    showConfirmationDialog(
      context: context,
      title: 'Log out',
      optionOne: 'Cancel',
      optionTwo: 'Continue',
      isDismissable: true,
      onOptionTwo: () {
        ref.read(authControllerProvider.notifier).logOut();
        Routemaster.of(context).replace('/login');
      },
    );
  }

  void navigateToMemberArea(BuildContext context) {
    Routemaster.of(context).replace('/member');
  }

  void navigateToDashboard(BuildContext context) {
    Routemaster.of(context).replace('/admin');
  }

  void navigateToEditProfile(BuildContext context, WidgetRef ref) {
    Routemaster.of(context).push('/member/edit-profile');
  }

  void navigateToAddSubmission(BuildContext context, WidgetRef ref) {
    Routemaster.of(context).push('/member/add-submission');
  }

  void navigateToSubmissionManual(BuildContext context) {
    Routemaster.of(context).push('/member/submission-manual');
  }

  void navigateToMySubmissions(BuildContext context, WidgetRef ref) {
    Routemaster.of(context).push('/member/my-submissions');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => checkGuest(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
              onPressed: () => logOut(context, ref),
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ))
        ],
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () => navigateToEditProfile(context, ref),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        user == null ? Constants.defaultAvatar : user.avatar),
                    radius: 40,
                  ),
                  const SizedBox(width: 20),
                  if (user != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          user.username,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(user.email),
                      ],
                    )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: widget.isDashboard
                ? ([
                    ListTile(
                      onTap: () => navigateToMemberArea(context),
                      leading: const Icon(Icons.dashboard),
                      title: const Text('Member area'),
                    )
                  ])
                : ([
                    ListTile(
                      onTap: () => navigateToDashboard(context),
                      leading: const Icon(Icons.wallet),
                      title: const Text('Rp. 0'),
                    ),
                    if (user?.role == UserRole.admin)
                      ListTile(
                        onTap: () => navigateToDashboard(context),
                        leading: const Icon(Icons.dashboard),
                        title: const Text('Dashboard'),
                      ),
                    ListTile(
                      onTap: () => navigateToAddSubmission(context, ref),
                      leading: const Icon(Icons.add_box),
                      title: const Text('Add business data'),
                    ),
                    ListTile(
                      onTap: () => navigateToSubmissionManual(context),
                      leading: const Icon(Icons.book),
                      title: const Text('Submission manual'),
                    ),
                    ListTile(
                      onTap: () => navigateToMySubmissions(context, ref),
                      leading: const Icon(Icons.my_library_books),
                      title: const Text('My submissions'),
                    ),
                  ]),
          )
        ],
      ),
    );
  }
}
