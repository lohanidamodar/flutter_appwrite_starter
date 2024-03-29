import 'package:flutter_appwrite_starter/src/components/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/themes/assets.dart';
import 'package:flutter_appwrite_starter/src/themes/colors.dart';
import 'package:flutter_svg/svg.dart';

import '../l10n/app_localizations.dart';

class SignupForm extends StatefulWidget {
  final SignupCallback onPressedSignup;
  final VoidCallback onPressedLogin;
  final GlobalKey<FormState> formKey;
  final bool isAuthenticating;
  const SignupForm(
      {Key? key,
      required this.onPressedSignup,
      required this.onPressedLogin,
      required this.formKey,
      required this.isAuthenticating})
      : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextStyle style = const TextStyle(fontSize: 20.0);
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  late final FocusNode _emailField;
  late final FocusNode _passwordField;
  late final FocusNode _confirmPasswordField;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
    _confirmPassword = TextEditingController(text: "");
    _name = TextEditingController(text: "");
    _emailField = FocusNode();
    _passwordField = FocusNode();
    _confirmPasswordField = FocusNode();
  }

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
          const SizedBox(height: 20.0),
          Text(
            "Sign Up",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.all(0),
            child: TextFormField(
              key: const Key("name-field"),
              controller: _name,
              validator: (value) => (value!.isEmpty)
                  ? AppLocalizations.of(context).nameValidationError
                  : null,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).nameFieldLabel,
              ),
              style: style,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_emailField);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: TextFormField(
              key: const Key("email-field"),
              focusNode: _emailField,
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
                labelText: AppLocalizations.of(context).passwordValidationError,
              ),
              style: style,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_confirmPasswordField);
              },
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            padding: const EdgeInsets.all(0),
            child: TextFormField(
              key: const Key("confirm-password-field"),
              controller: _confirmPassword,
              obscureText: true,
              validator: (value) => (value!.isEmpty)
                  ? AppLocalizations.of(context)
                      .confirmPasswordValidationEmptyError
                  : value.isNotEmpty && _password.text != _confirmPassword.text
                      ? AppLocalizations.of(context)
                          .confirmPasswordValidationMatchError
                      : null,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context).confirmPasswordFieldLabel,
              ),
              style: style,
              focusNode: _confirmPasswordField,
              onEditingComplete: () => _signup(),
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
                onPressed: _signup,
                child: Text(AppLocalizations.of(context).signupButtonText),
              ),
            ),
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
                    onPressed: () => widget.onPressedLogin,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _signup() {
    widget.onPressedSignup(_name.text, _email.text, _password.text);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
