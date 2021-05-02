import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/res/colors.dart';
import 'package:flutter_appwrite_starter/features/auth/presentation/widgets/signup.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: AppColors.primaryColor,
        ),
      ),
      body: SignupForm(),
    );
  }
}
