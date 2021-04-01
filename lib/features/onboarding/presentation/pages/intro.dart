import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/data/service/api_service.dart';
import 'package:flutter_appwrite_starter/core/presentation/providers/providers.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Swiper(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              //implement intro screen
              Spacer(),
              RaisedButton(
                onPressed: () {
                  _finishIntroScreen(context);
                },
                child: Text(AppLocalizations.of(context).introFinishButtonLabel),
              )
            ],
          );
        },
      ),
    );
  }

  _finishIntroScreen(BuildContext context) async {
    //set intro seen to true in user's intro
    context.read(userRepoProvider).introSeen();
  }
}
