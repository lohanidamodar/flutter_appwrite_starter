import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/dependencies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

import 'src/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  usePathUrlStrategy();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
