import 'package:flutter/material.dart';
import '../widgets/login.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback onSignup;
  final VoidCallback? onPop;
  const LoginPage({Key? key, required this.onSignup, this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: LoginForm(
        onSignup: onSignup,
        onPop: onPop,
      ),
    );
  }
}
