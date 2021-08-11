import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/res/assets.dart';
import 'package:flutter_appwrite_starter/core/res/colors.dart';
import 'package:flutter_appwrite_starter/core/res/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flappwrite_account_kit/flappwrite_account_kit.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextStyle style = TextStyle(fontSize: 20.0);
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
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          SvgPicture.asset(
            AppAssets.logo,
            height: 80.0,
          ),
          Text(
            "Login",
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.all(0),
            child: TextFormField(
              key: Key("email-field"),
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
              key: Key("password-field"),
              controller: _password,
              obscureText: true,
              validator: (value) => (value!.isEmpty)
                  ? AppLocalizations.of(context)!.passwordValidationError
                  : null,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.passwordFieldLabel,
              ),
              style: style,
              onEditingComplete: _login,
            ),
          ),
          SizedBox(height: 20.0),
          if (context.authNotifier.status == AuthStatus.authenticating)
            Center(child: CircularProgressIndicator()),
          if (context.authNotifier.status != AuthStatus.authenticating)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                ),
                onPressed: _login,
                child: Text(AppLocalizations.of(context)!.loginButtonText),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.arrow_forward),
                    style: OutlinedButton.styleFrom(
                      primary: AppColors.primaryColor,
                      side: BorderSide(color: AppColors.primaryColor),
                    ),
                    label: Text(AppLocalizations.of(context)!.signupButtonText),
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.signup),
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
          .createSession(email: _email!.text, password: _password!.text)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.authNotifier.error!),
        ));
      } else {
        Navigator.maybePop(context);
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
