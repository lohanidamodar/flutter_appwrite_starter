import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/app.dart';
import 'package:flutter_appwrite_starter/core/res/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/presentation/providers/providers.dart';
import 'core/res/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        location: BannerLocation.topEnd,
        message: "dev",
        textDirection: TextDirection.ltr,
        child: ProviderScope(
          child: App(),
          overrides: [
            configProvider.overrideWithProvider(Provider(
              (ref) => AppConfig(
                appTitle: AppConstants.appNameDev,
                buildFlavor: AppFlavor.dev,
              ),
            ))
          ],
        ),
      ),
    ),
  );
}
