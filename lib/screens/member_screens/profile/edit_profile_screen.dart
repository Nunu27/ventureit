import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/utils/validation.dart';

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
    if (_form.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [IconButton(onPressed: save, icon: const Icon(Icons.done))],
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar),
                        radius: 60,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 30,
                                color: Colors.black,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: validateUsername,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: validateUsername,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
