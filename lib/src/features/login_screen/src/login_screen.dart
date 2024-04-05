import 'package:flutter/material.dart';

import 'types.dart';
import 'login_form.dart';

class LoginScreen extends StatefulWidget {
  static const String name = 'login';
  final LoginCallback onLogin;
  final String? error;
  final bool loading;
  final VoidCallback? onNavigateToSignup;
  const LoginScreen({
    super.key,
    required this.onLogin,
    this.error,
    this.loading = false,
    this.onNavigateToSignup,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  if (widget.error != null) ...[
                    Text(
                      widget.error!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.red,
                          ),
                    ),
                  ],
                  LoginForm(
                    onPressedLogin: widget.onLogin,
                    onNavigateToSignup: widget.onNavigateToSignup,
                    emailController: _emailController,
                    passwordController: _passwordController,
                  ),
                ],
              ),
            ),
    );
  }
}
