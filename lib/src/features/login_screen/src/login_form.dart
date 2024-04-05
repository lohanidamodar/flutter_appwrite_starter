import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import '../../../themes/assets.dart';
import '../../../themes/colors.dart';
import 'types.dart';

class LoginForm extends StatelessWidget {
  final LoginCallback onPressedLogin;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode _passwordField = FocusNode();
  final VoidCallback? onNavigateToSignup;
  LoginForm({
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
          SvgPicture.asset(
            AppAssets.logo,
            height: 80.0,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.loginFormTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TextFormField(
            key: const Key("email-field"),
            controller: emailController,
            validator: (value) =>
                (value!.isEmpty) ? l10n.emailValidationError : null,
            decoration: InputDecoration(label: Text(l10n.emailFieldlabel)),
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_passwordField);
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            focusNode: _passwordField,
            controller: passwordController,
            obscureText: true,
            validator: (value) =>
                (value!.isEmpty) ? l10n.passwordValidationError : null,
            decoration: InputDecoration(label: Text(l10n.passwordFieldLabel)),
            onEditingComplete: _login,
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _login,
            child: Text(l10n.loginButtonText),
          ),
          if (onNavigateToSignup != null) ...[
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_forward),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        side: const BorderSide(color: AppColors.primaryColor),
                      ),
                      label: Text(AppLocalizations.of(context)
                          .newUserRegisterButtonLabel),
                      onPressed: onNavigateToSignup,
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

  void _login() {
    onPressedLogin(
      emailController.text,
      passwordController.text,
    );
  }
}
