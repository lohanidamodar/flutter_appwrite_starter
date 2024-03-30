import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/features/profile/crop_page.dart';
import 'package:flutter_appwrite_starter/src/features/welcome/welcome.dart';
import 'package:flutter_appwrite_starter/src/features/home_screen/home_screen.dart';
import 'package:flutter_appwrite_starter/src/features/onboarding/intro.dart';
import 'package:flutter_appwrite_starter/src/features/profile/edit_profile.dart';
import 'package:flutter_appwrite_starter/src/features/profile/profile.dart';
import 'package:flutter_appwrite_starter/src/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth_notifier/auth_state.dart';
import '../auth_notifier/auth_status.dart';
import '../features/login_screen/login_screen.dart';
import '../features/signup_screen/signup_screen.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    final routerKey = GlobalKey<NavigatorState>(debugLabel: 'routerKey');
    final authNotifier = ref.read(authProvider.notifier);
    final authStateListenable = ValueNotifier<AuthState>(AuthState());

    ref
      ..onDispose(authStateListenable.dispose)
      ..listen(authProvider, (_, next) {
        authStateListenable.value = next;
      });

    final router = GoRouter(
      navigatorKey: routerKey,
      initialLocation: '/${LoginScreen.name}',
      refreshListenable: authStateListenable,
      routes: [
        GoRoute(
          path: '/',
          name: HomeScreen.name,
          builder: (_, __) => const HomeScreen(),
          routes: [
            GoRoute(path: 'loading', builder: (_, __) => const WelcomePage()),
            GoRoute(
              path: UserProfile.name,
              name: UserProfile.name,
              builder: (_, __) => const UserProfile(),
              routes: [
                GoRoute(
                  path: EditProfile.name,
                  name: EditProfile.name,
                  builder: (_, __) => const EditProfile(),
                  routes: [
                    GoRoute(
                      path: CropPage.name,
                      name: CropPage.name,
                      builder: (_, state) =>
                          CropPage(image: state.extra as Uint8List?),
                    )
                  ],
                )
              ],
            ),
            GoRoute(path: 'intro', builder: (_, __) => const IntroPage())
          ],
        ),
        GoRoute(
          path: '/${SignupScreen.name}',
          name: SignupScreen.name,
          builder: (context, __) {
            return SignupScreen(
              onSignup: (name, email, password) async {
                await authNotifier.create(
                  email: email,
                  password: password,
                  name: name,
                );
              },
              onPressedBackToLogin: () {
                context.goNamed(LoginScreen.name);
              },
            );
          },
        ),
        GoRoute(
          path: '/${LoginScreen.name}',
          name: LoginScreen.name,
          builder: (context, __) => LoginScreen(
            onLogin: (email, password) async {
              await authNotifier.createEmailSession(
                  email: email, password: password);
            },
            onNavigateToSignup: () {
              context.goNamed(SignupScreen.name);
            },
            error: authStateListenable.value.error,
            loading: authStateListenable.value.loading,
          ),
        )
      ],
      redirect: (context, state) {
        final lMatch = state.matchedLocation;
        final qParams = state.uri.queryParameters;
        final authState = authStateListenable.value;
        final authStatus = authState.status;
        if (authStatus == AuthStatus.uninitialized) {
          return '/loading';
        }

        if (lMatch == '/' && authStatus == AuthStatus.unauthenticated) {
          return '/${LoginScreen.name}';
        }

        if (lMatch == '/' && authStatus == AuthStatus.authenticated) {
          return (authState.user?.prefs.data ?? {})['introSeen'] ?? false
              ? null
              : '/intro';
        }

        if (lMatch.startsWith('/profile') &&
            (authStatus == AuthStatus.authenticating ||
                authStatus == AuthStatus.uninitialized)) {
          return Uri(path: '/loading', queryParameters: {'redirect': lMatch})
              .toString();
        }
        if (lMatch == '/intro' && authStatus == AuthStatus.authenticated) {
          return (authState.user?.prefs.data ?? {})['introSeen'] ?? false
              ? '/'
              : null;
        }

        if (lMatch.startsWith('/profile') &&
            authStatus == AuthStatus.unauthenticated) {
          return '/login';
        }

        if ((lMatch == '/login' || lMatch == '/loading') &&
            authStatus == AuthStatus.authenticated) {
          return qParams['redirect'] ?? '/';
        }
        if (lMatch == '/loading' && authStatus == AuthStatus.unauthenticated) {
          return qParams['redirect'] ?? '/login';
        }
        return null;
      },
    );
    return router;
  },
);
