import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/app.dart';
import 'package:flutter_appwrite_starter/core/data/service/api_service.dart';
import 'package:flutter_appwrite_starter/core/res/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'core/presentation/providers/providers.dart';
import 'core/res/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        location: BannerLocation.topEnd,
        message: "dev",
        textDirection: TextDirection.ltr,
        child: AppwriteAuthKit(
          client: ApiService.instance.client,
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
    ),
  );
}
