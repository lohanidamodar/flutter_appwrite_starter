import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/features/login_screen/login_screen.dart';
import 'package:flutter_appwrite_starter/src/themes/colors.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: kToolbarHeight),
            Text(
              AppLocalizations.of(context).welcomePageTitle,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Frank"),
            ),
            Text(
              AppLocalizations.of(context).welcomePageSubtitle,
              style: const TextStyle(
                  color: AppColors.primaryColor, fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
