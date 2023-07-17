import 'package:flutter_appwrite_starter/src/features/auth/widgets/login_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/themes/colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: AppColors.primaryColor,
          ),
        ),
        body: LoginContainer());
  }
}
