import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/router/router.dart';
import 'package:profile/profile.dart';
import 'package:intro/intro.dart';
import 'src/app_config/app_config_provider.dart';
import 'src/styles/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppThemes.context = context;
    return Consumer(builder: (context, ref, child) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: ref.watch(configProvider).appTitle,
        theme: AppThemes.defaultTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          AuthLocalizations.delegate,
          ProfileLocalizations.delegate,
          IntroLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: AppRoutes.router,
      );
    });
  }
}
