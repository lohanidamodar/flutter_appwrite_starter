import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'app/app_config.dart';
import 'app/app_constants.dart';
import 'appwrite/appwrite.dart';
import 'auth_notifier/auth_notifier.dart';
import 'auth_notifier/auth_state.dart';
import 'l10n/locale_notifier.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(GetIt.I.get<Appwrite>().account),
);

final configProvider = Provider<AppConfig>((ref) => AppConfig(
      appTitle: AppConstants.appName,
      buildFlavor: AppFlavor.prod,
    ));

final localeConfigProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);
