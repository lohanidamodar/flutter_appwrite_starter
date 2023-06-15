import 'package:auth/src/l10n/auth_localizations.dart';
import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';

class SignupForm extends StatefulWidget {
  final VoidCallback? onPop;
  const SignupForm({Key? key, this.onPop}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  TextStyle style = const TextStyle(fontSize: 20.0);
  TextEditingController? _name;
  TextEditingController? _email;
  TextEditingController? _password;
  TextEditingController? _confirmPassword;
  FocusNode? _emailField;
  FocusNode? _passwordField;
  FocusNode? _confirmPasswordField;
  final _formKey = GlobalKey<FormState>();

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
    final l10n = AuthLocalizations.of(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const Logo(
            height: 80.0,
            basePath: 'packages/components',
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
                  ? l10n.nameValidationError
                  : null,
              decoration: InputDecoration(
                labelText: l10n.nameFieldLabel,
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
                  ? l10n.emailValidationError
                  : null,
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
              validator: (value) => (value!.isEmpty)
                  ? l10n.passwordValidationError
                  : null,
              decoration: InputDecoration(
                labelText:
                    l10n.passwordValidationError,
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
                  ? l10n
                      .confirmPasswordValidationEmptyError
                  : value.isNotEmpty &&
                          _password!.text != _confirmPassword!.text
                      ? l10n
                          .confirmPasswordValidationMatchError
                      : null,
              decoration: InputDecoration(
                labelText:
                    l10n.confirmPasswordFieldLabel,
              ),
              style: style,
              focusNode: _confirmPasswordField,
              onEditingComplete: () => _signup(),
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
                onPressed: _signup,
                child: Text(l10n.signupButtonText),
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
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor),
                    ),
                    label: const Text("Back to Login"),
                    onPressed: () => widget.onPop?.call(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _signup() async {
    if (_formKey.currentState!.validate()) {
      //signup user
      final user = await context.authNotifier.create(
          userId: 'unique()',
          name: _name!.text,
          email: _email!.text,
          password: _password!.text);
      if (!mounted) {
        return;
      }
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.authNotifier.error!),
        ));
      } else {
        await context.authNotifier
            .createEmailSession(email: _email!.text, password: _password!.text);
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
