import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/auth_notifier/auth_notifier.dart';
import 'package:flutter_appwrite_starter/src/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final authNotifier = ref.read(authProvider.notifier);
      final authState = ref.watch(authProvider);

      return Scaffold(
        body: PageView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                //implement intro screen
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Welcome to FlAppwrite Starter.",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    _finishIntroScreen(authState.user!, authNotifier);
                  },
                  child:
                      Text(AppLocalizations.of(context).introFinishButtonLabel),
                ),
                const SizedBox(height: 20.0),
              ],
            );
          },
        ),
      );
    });
  }

  _finishIntroScreen(User user, AuthNotifier notifier) async {
    //set intro seen to true in user's intro
    final prefs = user.prefs.data;
    prefs['introSeen'] = true;
    await notifier.updatePrefs(prefs: prefs);
  }
}
