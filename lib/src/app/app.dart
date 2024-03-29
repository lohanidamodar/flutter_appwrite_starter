import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/l10n/locale_config_provider.dart';
import 'package:flutter_appwrite_starter/src/router/router.dart';
import '../l10n/app_localizations.dart';
import 'config_provider.dart';
import '../themes/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    AppThemes.context = context;
    return Consumer(builder: (context, ref, child) {
      final router = ref.watch(routerProvider);
      return MaterialApp.router(
        locale: ref.watch<Locale?>(localeConfigProvider),
        debugShowCheckedModeBanner: false,
        title: ref.watch(configProvider).appTitle,
        theme: AppThemes.defaultTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      );
    });
  }
}
