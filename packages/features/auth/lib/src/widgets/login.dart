import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';

import '../l10n/auth_localizations.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onSignup;
  final VoidCallback? onPop;
  const LoginForm({Key? key, required this.onSignup, this.onPop})
      : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextStyle style = const TextStyle(fontSize: 20.0);
  TextEditingController? _email;
  TextEditingController? _password;
  FocusNode? _passwordField;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
    _passwordField = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AuthLocalizations.of(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const Logo(height: 80, basePath: 'packages/components/',),
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
              validator: (value) =>
                  (value!.isEmpty) ? l10n.emailValidationError : null,
              decoration: InputDecoration(
                labelText: l10n.emailFieldlabel,
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
              validator: (value) =>
                  (value!.isEmpty) ? l10n.passwordValidationError : null,
              decoration: InputDecoration(
                labelText: l10n.passwordFieldLabel,
              ),
              style: style,
              onEditingComplete: _login,
            ),
          ),
          const SizedBox(height: 20.0),
          if (context.authNotifier.status == AuthStatus.authenticating)
            const Center(child: CircularProgressIndicator()),
          if (context.authNotifier.status != AuthStatus.authenticating)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                ),
                onPressed: _login,
                child: Text(l10n.loginButtonText),
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
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor),
                    ),
                    label: Text(l10n.signupButtonText),
                    onPressed: () {
                      widget.onSignup.call();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _login() async {
    if (_formKey.currentState!.validate()) {
      if (!await context.authNotifier
          .createEmailSession(email: _email!.text, password: _password!.text)) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.authNotifier.error!),
        ));
      } else {
        widget.onPop?.call();
      }
    }
  }

  @override
  void dispose() {
    _email!.dispose();
    _password!.dispose();
    super.dispose();
  }
}
