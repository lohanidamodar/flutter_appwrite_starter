import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/features/profile/data/model/user_prefs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flappwrite_account_kit/flappwrite_account_kit.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              //implement intro screen
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  _finishIntroScreen(context);
                },
                child:
                    Text(AppLocalizations.of(context)!.introFinishButtonLabel),
              )
            ],
          );
        },
      ),
    );
  }

  _finishIntroScreen(BuildContext context) async {
    //set intro seen to true in user's intro
    final prefs = context.authNotifier.user!
        .prefsConverted((data) => UserPrefs.fromMap(data));
    await context.authNotifier
        .updatePrefs(prefs: prefs.copyWith(introSeen: true).toMap());
  }
}
