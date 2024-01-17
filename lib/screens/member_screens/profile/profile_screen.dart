import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/constants/constants.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/controllers/user_controller.dart';
import 'package:ventureit/models/user.dart';
import 'package:ventureit/utils/utils.dart';
import 'package:ventureit/widgets/primary_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final bool isDashboard;

  const ProfileScreen({super.key, this.isDashboard = false});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController topupController = TextEditingController();

  @override
  void dispose() {
    topupController.dispose();
    super.dispose();
  }

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

  void navigateToMemberArea() {
    Routemaster.of(context).replace('/member');
  }

  void navigateToDashboard() {
    Routemaster.of(context).replace('/admin');
  }

  void navigateToEditProfile() {
    Routemaster.of(context).push('/member/edit-profile');
  }

  void navigateToAddSubmission() {
    Routemaster.of(context).push('/member/add-submission');
  }

  void navigateToSubmissionManual() {
    Routemaster.of(context).push('/member/submission-manual');
  }

  void navigateToMySubmissions() {
    Routemaster.of(context).push('/member/my-submissions');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => checkGuest(context),
    );
  }

  void topUpSubmit() {
    final num = topupController.text;
    topupController.clear();
    Navigator.of(context, rootNavigator: true).pop(getNumber(num));
  }

  void topUp() async {
    modalShown = true;
    final res = await showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) => AlertDialog(
        title: const Text('Top up'),
        content: TextField(
          controller: topupController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            CurrencyTextInputFormatter(
              locale: 'id',
              decimalDigits: 0,
              symbol: 'Rp. ',
            ),
          ],
        ),
        actions: [
          PrimaryButton(
            onPress: topUpSubmit,
            child: const Text('Confirm'),
          )
        ],
      ),
    );
    modalShown = false;

    if (res == null) return;
    ref
        .read(userControllerProvider.notifier)
        .updateBalance(ref.read(userProvider)!.id, res);
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
            onTap: navigateToEditProfile,
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
                          user.name,
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
                      onTap: navigateToMemberArea,
                      leading: const Icon(Icons.dashboard),
                      title: const Text('Member area'),
                    )
                  ])
                : ([
                    ListTile(
                      onTap: topUp,
                      leading: const Icon(Icons.wallet),
                      title: Text(
                          'Rp. ${numberFormatter.format(user?.balance ?? 0)}'),
                    ),
                    if (user?.role == UserRole.admin)
                      ListTile(
                        onTap: navigateToDashboard,
                        leading: const Icon(Icons.dashboard),
                        title: const Text('Dashboard'),
                      ),
                    ListTile(
                      onTap: navigateToAddSubmission,
                      leading: const Icon(Icons.add_box),
                      title: const Text('Add business data'),
                    ),
                    ListTile(
                      onTap: navigateToSubmissionManual,
                      leading: const Icon(Icons.book),
                      title: const Text('Submission manual'),
                    ),
                    ListTile(
                      onTap: navigateToMySubmissions,
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
