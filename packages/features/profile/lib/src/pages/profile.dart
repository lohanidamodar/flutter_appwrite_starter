import 'dart:typed_data';

import 'package:api_service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:profile/src/constants.dart';
import 'package:profile/src/l10n/profile_localizations.dart';

import '../widgets/avatar.dart';

class UserProfile extends StatelessWidget {
  final VoidCallback onPressedEditProfile;
  final VoidCallback? onPop;
  const UserProfile({Key? key, required this.onPressedEditProfile, this.onPop,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.authNotifier.user;
    final prefs = user?.prefs.data ?? {};
    final l10n = ProfileLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profilePageTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          if (user != null) ...[
            FutureBuilder(
                future: prefs['photoId'] != null
                    ? ApiService.instance.getImageAvatar(
                        ProfileConstants.profileBucketId, prefs['photoId']!)
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
                title: Text(l10n.editProfile),
                onTap: () => onPressedEditProfile(),
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: Text(l10n.logoutButtonText),
                onTap: () async {
                  await context.authNotifier.deleteSession();
                  onPop?.call();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
