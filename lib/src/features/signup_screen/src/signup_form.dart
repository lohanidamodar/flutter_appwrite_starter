import 'package:flutter/material.dart';

import 'types.dart';

class SignupForm extends StatelessWidget {
  final SignupCallback onPressedLogin;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  const SignupForm({
    super.key,
    required this.onPressedLogin,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Create account'),
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              label: Text('name'),
            ),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              label: Text('email'),
            ),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              label: Text('password'),
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () => onPressedLogin(
              nameController.text,
              emailController.text,
              passwordController.text,
            ),
            child: const Text('Create'),
          )
        ],
      ),
    );
  }
}
