import 'package:flappwrite_account_kit/flappwrite_account_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/data/service/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    FlAppwriteAccountKit(
      client: ApiService.instance.client,
      child: ProviderScope(
        child: App(),
      ),
    ),
  );
}
