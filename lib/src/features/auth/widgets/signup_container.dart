import 'package:flutter_appwrite_starter/src/components/components.dart';
import 'package:flutter/material.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:go_router/go_router.dart';

class SignupContainer extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignupContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignupForm(
        onPressedSignup: (name, email, password) =>
            _signup(context, name, email, password),
        onPressedLogin: () => context.pop(),
        formKey: _formKey,
        isAuthenticating:
            context.authNotifier.status == AuthStatus.authenticating);
  }

  _signup(
      BuildContext context, String name, String email, String password) async {
    if (_formKey.currentState!.validate()) {
      //signup user
      final user = await context.authNotifier.create(
          userId: 'unique()', name: name, email: email, password: password);
      if (user == null) {
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.authNotifier.error!),
        ));
      } else {
        if (!context.mounted) {
          return;
        }
        await context.authNotifier
            .createEmailSession(email: email, password: password);
        if (context.mounted && context.canPop()) {
          context.pop();
        }
      }
    }
  }
}
