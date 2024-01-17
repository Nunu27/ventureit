import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/controllers/user_controller.dart';
import 'package:ventureit/utils/picker.dart';
import 'package:ventureit/utils/validation.dart';
import 'package:ventureit/widgets/input/text_input.dart';
import 'package:ventureit/widgets/loader_overlay.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _form = GlobalKey<FormState>();
  File? avatar;
  late TextEditingController fullNameController;
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();

    final user = ref.read(userProvider)!;

    fullNameController = TextEditingController(text: user.name);
    usernameController = TextEditingController(text: user.username);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void save() {
    if (_form.currentState!.validate()) {
      ref.read(userControllerProvider.notifier).updateUser(
            context,
            ref.read(userProvider)!.copyWith(
                  name: fullNameController.text.trim(),
                  username: usernameController.text.trim(),
                ),
            avatar,
          );
    }
  }

  void selectAvatar() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        avatar = File(res.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userControllerProvider);
    final user = ref.read(userProvider)!;
    final theme = Theme.of(context);

    return LoaderOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          actions: [IconButton(onPressed: save, icon: const Icon(Icons.done))],
        ),
        body: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        avatar == null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(user.avatar),
                                radius: 60,
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(avatar!),
                                radius: 60,
                              ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton.filled(
                            onPressed: selectAvatar,
                            color: theme.colorScheme.onPrimary,
                            icon: const Icon(Icons.camera_alt),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextForm(
                  controller: fullNameController,
                  label: 'Full name',
                  maxLines: 1,
                  validator: validateUsername,
                ),
                CustomTextForm(
                  controller: usernameController,
                  label: 'Username',
                  maxLines: 1,
                  validator: validateUsername,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
