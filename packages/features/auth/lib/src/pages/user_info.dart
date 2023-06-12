import 'package:appwrite/models.dart';
import 'package:auth/src/l10n/auth_localizations.dart';
import 'package:flutter/material.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';

class UserInfoPage extends StatelessWidget {
  final User? user;

  const UserInfoPage({Key? key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final l10n = AuthLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profilePageTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(user!.email),
            ElevatedButton(
              child: Text(l10n.logoutButtonText),
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
