import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/presentation/providers/providers.dart';
import 'package:flutter_appwrite_starter/features/home/presentation/pages/home.dart';
import 'package:flutter_appwrite_starter/features/onboarding/presentation/pages/intro.dart';
import '../../data/model/user_repository.dart';
import './splash.dart';
import 'welcome.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        final user = watch(userRepoProvider);
        switch (user.status) {
          case Status.Unauthenticated:
          case Status.Authenticating:
            return WelcomePage();
          case Status.Authenticated:
            if (user.isLoading) return Splash();
            return user.prefs?.introSeen ?? false ? HomePage() : IntroPage();
          case Status.Uninitialized:
          default:
            return Splash();
        }
      },
    );
  }
}
