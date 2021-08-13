import 'package:flappwrite_account_kit/flappwrite_account_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/features/home/presentation/pages/home.dart';
import 'package:flutter_appwrite_starter/features/onboarding/presentation/pages/intro.dart';
import 'package:flutter_appwrite_starter/features/profile/data/model/user_prefs.dart';
import './splash.dart';
import 'welcome.dart';

class AuthHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = context.authNotifier;
    switch (authNotifier.status) {
      case AuthStatus.unauthenticated:
      case AuthStatus.authenticating:
        return WelcomePage();
      case AuthStatus.authenticated:
        if (authNotifier.isLoading) return Splash();
        return authNotifier.user
                    ?.prefsConverted<UserPrefs>(
                        (data) => UserPrefs.fromMap(data))
                    .introSeen ??
                false
            ? HomePage()
            : IntroPage();
      case AuthStatus.uninitialized:
      default:
        return Splash();
    }
  }
}
