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
            final locale = ref.watch(localeConfigProvider);
            return IconButton(
              onPressed: () {
                ref.read(localeConfigProvider.notifier).setLocale(
                    locale?.languageCode == 'ne'
                        ? null
                        : const Locale('ne', 'np'));
              },
              icon: Icon(
                  locale?.languageCode == 'ne' ? Icons.sunny : Icons.check),
            );
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