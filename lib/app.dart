import 'package:flutter/material.dart';
import 'core/presentation/providers/providers.dart';
import 'core/res/routes.dart';
import 'core/res/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'features/auth/presentation/pages/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppThemes.context = context;
    return Consumer(builder: (context, watch, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: watch(configProvider).appTitle,
        theme: AppThemes.defaultTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: AuthHomePage(),
      );
    } as Widget Function(BuildContext, T Function<T>(ProviderBase<Object?, T>), Widget?));
  }
}
