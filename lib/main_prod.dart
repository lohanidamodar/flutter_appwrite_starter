import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/data/service/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    AppwriteAuthKit(
      client: ApiService.instance.client,
      child: const ProviderScope(
        child: App(),
      ),
    ),
  );
}
