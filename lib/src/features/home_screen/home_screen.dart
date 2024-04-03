import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/features/profile/profile_screen.dart';
import 'package:flutter_appwrite_starter/src/l10n/app_localizations.dart';
import 'package:flutter_appwrite_starter/src/themes/assets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../providers.dart';

class HomeScreen extends StatefulWidget {
  static String name = 'home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.goNamed(ProfileScreen.name),
          ),
          Consumer(builder: (context, ref, child) {
            var locale = ref.watch(localeConfigProvider);
            return DropdownButton<String>(
                underline: const SizedBox(
                  height: 0,
                ),
                elevation: 0,
                value: locale.languageCode,
                items: [
                  DropdownMenuItem(
                    value: 'ne',
                    child: Flag.fromCode(
                      FlagsCode.NP,
                      height: 24,
                      width: 24,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'us',
                    child: Flag.fromCode(
                      FlagsCode.US,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  locale = Locale(value, value == 'ne' ? 'np' : 'us');
                  ref.read(localeConfigProvider.notifier).setLocale(locale);
                });
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20.0),
            SvgPicture.asset(AppAssets.logo),
            const SizedBox(height: 20.0),
            Text(
              "Welcome to FlAppwrite Starter template, your base to build awesome applications.",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
