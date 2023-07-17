import 'package:flutter_appwrite_starter/src/components/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/themes/assets.dart';
import 'package:flutter_appwrite_starter/src/themes/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../l10n/app_localizations.dart';

class LoginForm extends StatefulWidget {
  final LoginCallback onPressedLogin;
  final VoidCallback onPressedSignup;
  final GlobalKey<FormState> formKey;
  final bool isAuthenticating;
  const LoginForm({
    Key? key,
    required this.onPressedLogin,
    required this.formKey,
    required this.onPressedSignup,
    this.isAuthenticating = false,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextStyle style = const TextStyle(fontSize: 20.0);
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _passwordField = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          SvgPicture.asset(
            AppAssets.logo,
            height: 80.0,
          ),
          Text(
            "Login",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.all(0),
            child: TextFormField(
              key: const Key("email-field"),
              controller: _email,
              validator: (value) => (value!.isEmpty)
                  ? AppLocalizations.of(context).emailValidationError
                  : null,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).emailFieldlabel,
              ),
              style: style,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_passwordField);
              },
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            padding: const EdgeInsets.all(0),
            child: TextFormField(
              focusNode: _passwordField,
              key: const Key("password-field"),
              controller: _password,
              obscureText: true,
              validator: (value) => (value!.isEmpty)
                  ? AppLocalizations.of(context).passwordValidationError
                  : null,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).passwordFieldLabel,
              ),
              style: style,
              onEditingComplete: _login,
            ),
          ),
          const SizedBox(height: 20.0),
          if (widget.isAuthenticating)
            const Center(child: CircularProgressIndicator()),
          if (!widget.isAuthenticating)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                ),
                onPressed: _login,
                child: Text(AppLocalizations.of(context).loginButtonText),
              ),
            ),
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
                    label: Text(AppLocalizations.of(context).signupButtonText),
                    onPressed: widget.onPressedSignup,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _login() {
    widget.onPressedLogin(_email.text, _password.text);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
