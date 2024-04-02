import 'package:flutter/material.dart';
import 'signup_form.dart';
import 'types.dart';

class SignupScreen extends StatefulWidget {
  static const String name = 'signup';
  final SignupCallback onSignup;
  final VoidCallback? onPressedBackToLogin;
  const SignupScreen(
      {super.key, required this.onSignup, this.onPressedBackToLogin});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          SignupForm(
            onPressedSignup: widget.onSignup,
            emailController: _emailController,
            passwordController: _passwordController,
            nameController: _nameController,
            onPressedBackToLogin: widget.onPressedBackToLogin,
          ),
        ],
      ),
    );
  }
}
