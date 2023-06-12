import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/router/router.dart';
import 'providers/providers.dart';
import 'res/themes.dart';
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
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: AppRoutes.router,
      );
    });
  }
}
