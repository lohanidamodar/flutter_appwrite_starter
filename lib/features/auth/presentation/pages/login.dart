import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/features/auth/presentation/widgets/login.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LoginForm(),
    );
  }
}
