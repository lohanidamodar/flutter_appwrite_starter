import 'package:flutter/material.dart';
import 'core/presentation/providers/providers.dart';
import 'core/res/routes.dart';
import 'core/res/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'features/auth/presentation/pages/home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppThemes.context = context;
    return Consumer(builder: (context, ref, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: ref.watch(configProvider).appTitle,
        theme: AppThemes.defaultTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: const AuthHomePage(),
      );
    });
  }
}
