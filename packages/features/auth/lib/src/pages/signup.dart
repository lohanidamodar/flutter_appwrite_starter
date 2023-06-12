import 'package:flutter/material.dart';
import '../widgets/signup.dart';

class SignupPage extends StatelessWidget {
  final VoidCallback onPop;
  const SignupPage({Key? key, required this.onPop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: SignupForm(onPop: onPop,),
    );
  }
}
