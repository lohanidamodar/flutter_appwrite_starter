import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/app.dart';
import 'package:api_service/api_service.dart';
import 'package:flutter_appwrite_starter/src/app_config/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'src/app_config/app_config_provider.dart';
import 'src/constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  ApiService.instance.init(
    endpoint: AppConstants.endpoint,
    projectId: AppConstants.projectId,
  );
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
            child: const App(),
            overrides: [
              configProvider.overrideWith(
                (ref) => AppConfig(
                  appTitle: AppConstants.appNameDev,
                  buildFlavor: AppFlavor.dev,
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
