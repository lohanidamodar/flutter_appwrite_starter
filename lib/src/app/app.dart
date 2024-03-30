import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/l10n/locale_config_provider.dart';
import 'package:flutter_appwrite_starter/src/router/router.dart';
import 'package:get_it/get_it.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import '../themes/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final router = ref.watch(routerProvider);
      final locale = ref.watch(localeConfigProvider);
      final appThemes = GetIt.I.get<AppThemes>();
      return MaterialApp.router(
        locale: locale,
        debugShowCheckedModeBanner: false,
        title: ref.watch(configProvider).appTitle,
        theme: appThemes.lightTheme,
        darkTheme: appThemes.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      );
    });
  }
}
