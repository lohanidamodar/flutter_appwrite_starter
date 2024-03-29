import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/l10n/app_localizations.dart';

import 'types.dart';

class LoginForm extends StatelessWidget {
  final LoginCallback onPressedLogin;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback? onNavigateToSignup;
  const LoginForm({
    super.key,
    required this.onPressedLogin,
    required this.emailController,
    required this.passwordController,
    this.onNavigateToSignup,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Login'),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(label: Text(l10n.emailFieldlabel)),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(label: Text(l10n.passwordFieldLabel)),
          ),
          const SizedBox(height: 20.0),
          if (onNavigateToSignup != null) ...[
            TextButton(
              onPressed: () => onNavigateToSignup?.call(),
              child: Text(l10n.newUserRegisterButtonLabel),
            ),
            const SizedBox(height: 10.0),
          ],
          ElevatedButton(
            onPressed: () => onPressedLogin(
              emailController.text,
              passwordController.text,
            ),
            child: Text(l10n.loginButtonText),
          )
        ],
      ),
    );
  }
}
