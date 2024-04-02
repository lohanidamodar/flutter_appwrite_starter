import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/themes/colors.dart';

import '../../l10n/app_localizations.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
              l10n.welcomePageTitle,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Frank"),
            ),
            Text(
              l10n.welcomePageSubtitle,
              style: const TextStyle(
                  color: AppColors.primaryColor, fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
