import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Crashlytics.instance.enableInDevMode = true;
    runApp(
      ProviderScope(child: App()),
    );
}
