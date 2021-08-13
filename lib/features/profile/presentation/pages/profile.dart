import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/data/service/api_service.dart';
import 'package:flutter_appwrite_starter/core/res/routes.dart';
import 'package:flutter_appwrite_starter/features/profile/data/model/user_prefs.dart';
import 'package:flutter_appwrite_starter/features/profile/presentation/widgets/avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flappwrite_account_kit/flappwrite_account_kit.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.authNotifier.user;
    final prefs = user?.prefsConverted((data) => UserPrefs.fromMap(data));
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profilePageTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          if (user != null) ...[
            FutureBuilder(
                future: prefs?.photoId != null
                    ? ApiService.instance.getImageAvatar(prefs!.photoId!)
                    : ApiService.instance.getAvatar(user.name),
                builder: (context, AsyncSnapshot<Uint8List> snapshot) {
                  return Center(
                    child: Avatar(
                      onButtonPressed: () {},
                      radius: 50,
                      image: (prefs?.photoUrl != null
                          ? NetworkImage(prefs!.photoUrl!)
                          : snapshot.hasData
                              ? MemoryImage(snapshot.data!)
                              : null) as ImageProvider<dynamic>?,
                    ),
                  );
                }),
            const SizedBox(height: 10.0),
            Center(
              child: Text(user.name),
            ),
            const SizedBox(height: 5.0),
            Center(child: Text(user.email)),
          ],
          ...ListTile.divideTiles(
            color: Theme.of(context).dividerColor,
            tiles: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text(AppLocalizations.of(context)!.editProfile),
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.editProfile),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text(AppLocalizations.of(context)!.logoutButtonText),
                onTap: () async {
                  await context.authNotifier.deleteSession();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
