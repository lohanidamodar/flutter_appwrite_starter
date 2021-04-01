import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/presentation/providers/providers.dart';
import 'package:flutter_appwrite_starter/features/profile/data/model/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfoPage extends StatelessWidget {
  final User user;

  const UserInfoPage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).profilePageTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(user.email),
            RaisedButton(
              child: Text(AppLocalizations.of(context).logoutButtonText),
              onPressed: () {
                context.read(userRepoProvider).signOut();
              },
            )
          ],
        ),
      ),
    );
  }
}
