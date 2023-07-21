import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:flutter_appwrite_starter/src/components/components.dart';
import 'package:flutter_appwrite_starter/src/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginContainer extends StatelessWidget {
  LoginContainer({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LoginForm(
      onPressedLogin: (email, password) => _login(email, password, context),
      formKey: _formKey,
      onPressedSignup: () => context.goNamed(AppRoutes.signup),
      isAuthenticating:
          context.authNotifier.status == AuthStatus.authenticating,
    );
  }

  _login(String email, String password, BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (!await context.authNotifier
          .createEmailSession(email: email, password: password)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.authNotifier.error!),
        ));
      } else {
        if (context.canPop()) {
          context.pop();
        }
      }
    }
  }
}
