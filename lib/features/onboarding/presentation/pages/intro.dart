import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  "Yo see this only the first time you log in.",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const Spacer(),
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
    final prefs = context.authNotifier.user!.prefs.data;
    prefs['introSeen'] = true;
    await context.authNotifier.updatePrefs(prefs: prefs);
  }
}
