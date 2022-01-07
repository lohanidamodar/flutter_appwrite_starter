import 'package:flappwrite_account_kit/flappwrite_account_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/features/home/presentation/pages/home.dart';
import 'package:flutter_appwrite_starter/features/onboarding/presentation/pages/intro.dart';
import './splash.dart';
import 'welcome.dart';

class AuthHomePage extends StatelessWidget {
  const AuthHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = context.authNotifier;
    switch (authNotifier.status) {
      case AuthStatus.unauthenticated:
      case AuthStatus.authenticating:
        return const WelcomePage();
      case AuthStatus.authenticated:
        if (authNotifier.isLoading) return const Splash();
        return (authNotifier.user?.prefs.data ?? {})['introSeen'] ?? false
            ? const HomePage()
            : const IntroPage();
      case AuthStatus.uninitialized:
      default:
        return const Splash();
    }
  }
}
