import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/res/colors.dart';
import 'package:flutter_appwrite_starter/core/res/routes.dart';
import 'package:flutter_appwrite_starter/features/auth/presentation/widgets/login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
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
            AppLocalizations.of(context)!.welcomePageTitle,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w900,
                fontFamily: "Frank"),
          ),
          Text(
            AppLocalizations.of(context)!.welcomePageSubtitle,
            style: TextStyle(color: AppColors.primaryColor, fontSize: 20.0),
          ),
          const SizedBox(height: 20.0),
          Expanded(child: LoginForm()),
        ],
      ),
    );
  }
}
