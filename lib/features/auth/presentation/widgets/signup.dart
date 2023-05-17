import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/res/assets.dart';
import 'package:flutter_appwrite_starter/core/res/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:go_router/go_router.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
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
    return Form(
      key: _formKey,
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
                  ? AppLocalizations.of(context)!.nameValidationError
                  : null,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.nameFieldLabel,
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
                  ? AppLocalizations.of(context)!.emailValidationError
                  : null,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.emailFieldlabel,
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
                  ? AppLocalizations.of(context)!.passwordValidationError
                  : null,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)!.passwordValidationError,
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
                  ? AppLocalizations.of(context)!
                      .confirmPasswordValidationEmptyError
                  : value.isNotEmpty &&
                          _password!.text != _confirmPassword!.text
                      ? AppLocalizations.of(context)!
                          .confirmPasswordValidationMatchError
                      : null,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)!.confirmPasswordFieldLabel,
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
                child: Text(AppLocalizations.of(context)!.signupButtonText),
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
                    onPressed: () => context.pop(),
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
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.authNotifier.error!),
        ));
      } else {
        await context.authNotifier
            .createEmailSession(email: _email!.text, password: _password!.text);
        context.pop();
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
