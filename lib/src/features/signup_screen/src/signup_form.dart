import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import '../../../themes/assets.dart';
import '../../../themes/colors.dart';
import 'types.dart';

class SignupForm extends StatelessWidget {
  final SignupCallback onPressedSignup;
  final VoidCallback? onPressedBackToLogin;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final FocusNode _emailField = FocusNode();
  final FocusNode _passwordField = FocusNode();
  SignupForm({
    super.key,
    required this.onPressedSignup,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    this.onPressedBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppAssets.logo,
            height: 80.0,
          ),
          const Text('Create account'),
          TextFormField(
            controller: nameController,
            validator: (value) =>
                (value!.isEmpty) ? l10n.nameValidationError : null,
            decoration: InputDecoration(
              label: Text(l10n.nameFieldLabel),
            ),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            key: const Key("email-field"),
            focusNode: _emailField,
            controller: emailController,
            decoration: InputDecoration(
              label: Text(l10n.emailFieldlabel),
            ),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            key: const Key("password-field"),
            focusNode: _passwordField,
            controller: passwordController,
            obscureText: true,
            validator: (value) =>
                (value!.isEmpty) ? l10n.passwordValidationError : null,
            onEditingComplete: _signup,
            decoration: InputDecoration(
              label: Text(l10n.passwordFieldLabel),
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _signup,
            child: const Text('Create'),
          ),
          if (onPressedBackToLogin != null) ...[
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        side: const BorderSide(color: AppColors.primaryColor),
                      ),
                      label: const Text("Back to Login"),
                      onPressed: onPressedBackToLogin,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _signup() => onPressedSignup(
        nameController.text,
        emailController.text,
        passwordController.text,
      );
}
