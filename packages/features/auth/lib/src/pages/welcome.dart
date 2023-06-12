import 'package:flutter/material.dart';
import '../l10n/auth_localizations.dart';
import '../widgets/login.dart';

class WelcomePage extends StatefulWidget {
  final VoidCallback onSignup;
  const WelcomePage({Key? key, required this.onSignup}) : super(key: key);

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
    final l10n = AuthLocalizations.of(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: kToolbarHeight),
          Text(
            l10n.welcomePageTitle,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w900,
                fontFamily: "Frank"),
          ),
          Text(
            l10n.welcomePageSubtitle,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary, fontSize: 20.0),
          ),
          const SizedBox(height: 20.0),
          Expanded(child: LoginForm(onSignup: widget.onSignup)),
        ],
      ),
    );
  }
}
