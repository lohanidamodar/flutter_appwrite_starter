import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/features/profile/crop_screen.dart';
import 'package:flutter_appwrite_starter/src/features/welcome/welcome_screen.dart';
import 'package:flutter_appwrite_starter/src/features/home_screen/home_screen.dart';
import 'package:flutter_appwrite_starter/src/features/onboarding/intro_screen.dart';
import 'package:flutter_appwrite_starter/src/features/profile/edit_profile_screen.dart';
import 'package:flutter_appwrite_starter/src/features/profile/profile_screen.dart';
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
    final authStateListenable =
        ValueNotifier<AuthState>(ref.read(authProvider));

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
            GoRoute(
              path: 'loading',
              builder: (_, __) => const WelcomeScreen(),
            ),
            GoRoute(
              path: ProfileScreen.name,
              name: ProfileScreen.name,
              builder: (_, __) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: EditProfileScren.name,
                  name: EditProfileScren.name,
                  builder: (_, __) => const EditProfileScren(),
                  routes: [
                    GoRoute(
                      path: CropScreen.name,
                      name: CropScreen.name,
                      builder: (_, state) =>
                          CropScreen(image: state.extra as Uint8List?),
                    )
                  ],
                )
              ],
            ),
            GoRoute(
              path: IntroScreen.name,
              name: IntroScreen.name,
              builder: (_, __) => const IntroScreen(),
            ),
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
        ),
      ],
      redirect: (context, state) {
        final lMatch = state.matchedLocation;
        final qParams = Map<String, String>.from(state.uri.queryParameters);
        final authState = authStateListenable.value;
        final authStatus = authState.status;
        final prefs = (authState.user?.prefs.data ?? {});
        final introSeen = prefs['introSeen'] ?? false;

        if (qParams['redirect'] == lMatch) {
          qParams.remove('redirect');
        }

        if (authStatus == AuthStatus.uninitialized) {
          if (lMatch != '/loading') {
            qParams['redirect'] = qParams['redirect'] ?? lMatch;
          }
          return Uri(path: '/loading', queryParameters: qParams).toString();
        }

        final isProtectedRoute = lMatch == '/' ||
            lMatch.startsWith('/profile') ||
            lMatch == '/intro';

        final isAuthenticated = authStatus == AuthStatus.authenticated;

        if (isProtectedRoute && !isAuthenticated) {
          qParams['redirect'] = qParams['redirect'] ?? lMatch;
          return Uri(path: '/${LoginScreen.name}', queryParameters: qParams)
              .toString();
        }

        if (isProtectedRoute && isAuthenticated && !introSeen) {
          qParams['redirect'] = qParams['redirect'] ?? lMatch;
          return Uri(path: '/${LoginScreen.name}', queryParameters: qParams)
              .toString();
        }

        if (lMatch == '/${IntroScreen.name}' && isAuthenticated && introSeen) {
          return qParams['redirect'] ?? '/';
        }

        if ((lMatch == '/login' || lMatch == '/loading') && isAuthenticated) {
          return qParams['redirect'] ?? '/';
        }
        if (lMatch == '/loading' && !isAuthenticated) {
          return qParams['redirect'] ?? '/login';
        }
        return null;
      },
    );
    return router;
  },
);
