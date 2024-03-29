import 'package:flutter_appwrite_starter/src/features/auth/widgets/login_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/themes/colors.dart';

import '../../l10n/app_localizations.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            style:
                const TextStyle(color: AppColors.primaryColor, fontSize: 20.0),
          ),
          const SizedBox(height: 20.0),
          Expanded(child: LoginContainer()),
        ],
      ),
    );
  }
}
