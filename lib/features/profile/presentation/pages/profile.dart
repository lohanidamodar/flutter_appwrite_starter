import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/data/service/api_service.dart';
import 'package:flutter_appwrite_starter/core/presentation/router/router.dart';
import 'package:flutter_appwrite_starter/core/res/constants.dart';
import 'package:flutter_appwrite_starter/features/profile/presentation/widgets/avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:go_router/go_router.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.authNotifier.user;
    final prefs = user?.prefs.data ?? {};
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profilePageTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          if (user != null) ...[
            FutureBuilder(
                future: prefs['photoId'] != null
                    ? ApiService.instance.getImageAvatar(
                        AppConstants.profileBucketId, prefs['photoId']!)
                    : ApiService.instance.getAvatar(user.name),
                builder: (context, AsyncSnapshot<Uint8List> snapshot) {
                  return Center(
                    child: Avatar(
                      onButtonPressed: () {},
                      radius: 50,
                      image: (prefs['photoUrl'] != null
                          ? NetworkImage(prefs['photoUrl']!)
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
                leading: const Icon(Icons.edit),
                title: Text(AppLocalizations.of(context)!.editProfile),
                onTap: () => context.goNamed(AppRoutes.editProfile),
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: Text(AppLocalizations.of(context)!.logoutButtonText),
                onTap: () async {
                  await context.authNotifier.deleteSession();
                  context.pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
