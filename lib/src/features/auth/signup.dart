import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/themes/colors.dart';
import 'package:flutter_appwrite_starter/src/features/auth/widgets/signup_container.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: AppColors.primaryColor,
        ),
      ),
      body: SignupContainer(),
    );
  }
}
