import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/dependencies.dart';
import 'package:flutter_appwrite_starter/src/app/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

import 'src/app/app.dart';
import 'src/app/app_constants.dart';
import 'src/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  usePathUrlStrategy();
  runApp(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        location: BannerLocation.topStart,
        message: "dev",
        textDirection: TextDirection.ltr,
        child: ProviderScope(
          overrides: [
            configProvider.overrideWith(
              (_) => AppConfig(
                appTitle: AppConstants.appNameDev,
                buildFlavor: AppFlavor.dev,
              ),
            ),
          ],
          child: const App(),
        ),
      ),
    ),
  );
}
