import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/presentation/providers/providers.dart';
import 'package:flutter_appwrite_starter/core/res/routes.dart';
import 'package:flutter_appwrite_starter/features/profile/presentation/widgets/avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).profilePageTitle),
      ),
      body: Consumer(builder: (context, watch, _) {
        final user = watch(userRepoProvider).user;
        return ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            if (user != null) ...[
              //TODO
              /* Center(
                child: Avatar(
                  onButtonPressed: () {},
                  radius: 50,
                  image: user.photoUrl != null
                      ? NetworkImage(user.photoUrl)
                      : null,
                ),
              ), */
              const SizedBox(height: 10.0),
              if (user.name != null) ...[
                Center(
                  child: Text(user.name),
                ),
                const SizedBox(height: 5.0),
              ],
              Center(child: Text(user?.email)),
            ],
            ...ListTile.divideTiles(
              color: Theme.of(context).dividerColor,
              tiles: [
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text(AppLocalizations.of(context).editProfile),
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.editProfile,
                      arguments: user),
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text(AppLocalizations.of(context).logoutButtonText),
                  onTap: () async {
                    await context.read(userRepoProvider).signOut();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
