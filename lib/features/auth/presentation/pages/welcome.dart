import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/res/routes.dart';
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
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
            ),
            width: double.infinity,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: kToolbarHeight),
              Text(
                AppLocalizations.of(context).welcomePageTitle,
                style: Theme.of(context).textTheme.headline2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontFamily: "Frank"),
              ),
              Text(
                AppLocalizations.of(context).welcomePageSubtitle,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              const SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                        ),
                        child:
                            Text(AppLocalizations.of(context).loginButtonText),
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.login),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: Colors.white,
                          side: BorderSide(color: Colors.white),
                        ),
                        child:
                            Text(AppLocalizations.of(context).signupButtonText),
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.signup),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
