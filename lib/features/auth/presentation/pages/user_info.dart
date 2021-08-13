import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flappwrite_account_kit/flappwrite_account_kit.dart';

class UserInfoPage extends StatelessWidget {
  final User? user;

  const UserInfoPage({Key? key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profilePageTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(user!.email),
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.logoutButtonText),
              onPressed: () {
                context.authNotifier.deleteSession();
              },
            )
          ],
        ),
      ),
    );
  }
}
