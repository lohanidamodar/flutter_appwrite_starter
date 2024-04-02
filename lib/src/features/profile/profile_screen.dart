import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/app/app_constants.dart';
import 'package:flutter_appwrite_starter/src/appwrite/appwrite.dart';
import 'package:flutter_appwrite_starter/src/components/avatar.dart';
import 'package:flutter_appwrite_starter/src/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  static String name = 'profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = GetIt.I.get<Appwrite>();
    final l10n = AppLocalizations.of(context);
    return Consumer(builder: (context, ref, child) {
      final authState = ref.watch(authProvider);
      final authNotifier = ref.read(authProvider.notifier);
      final user = authState.user;
      final prefs = user?.prefs.data ?? {};
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
                      ? apiService.getImageAvatar(
                          AppConstants.profileBucketId, prefs['photoId']!)
                      : apiService.getAvatar(user.name),
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
                  onTap: () => context.goNamed(EditProfileScren.name),
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: Text(l10n.logoutButtonText),
                  onTap: () async {
                    await authNotifier.deleteSession();
                    if (!context.mounted) {
                      return;
                    }
                    // context.pop();
                  },
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
