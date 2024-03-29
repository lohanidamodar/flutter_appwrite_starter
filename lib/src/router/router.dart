import 'dart:typed_data';
import 'package:flutter_appwrite_starter/src/features/profile/crop_page.dart';
import 'package:flutter_appwrite_starter/src/features/welcome/splash.dart';
import 'package:flutter_appwrite_starter/src/features/welcome/welcome.dart';
import 'package:flutter_appwrite_starter/src/features/home/home.dart';
import 'package:flutter_appwrite_starter/src/features/onboarding/intro.dart';
import 'package:flutter_appwrite_starter/src/features/profile/edit_profile.dart';
import 'package:flutter_appwrite_starter/src/features/profile/profile.dart';
import 'package:flutter_appwrite_starter/src/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth_notifier/auth_status.dart';
import '../features/login_screen/login_screen.dart';
import '../features/signup_screen/signup_screen.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: HomePage.name,
          builder: (context, __) => authState.status == AuthStatus.authenticated
              ? const HomePage()
              : const WelcomePage(),
          routes: [
            GoRoute(path: 'loading', builder: (_, __) => const Splash()),
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
                ),
              ],
            ),
            GoRoute(path: 'intro', builder: (_, __) => const IntroPage()),
          ],
        ),
        GoRoute(
          path: '/${SignupScreen.name}',
          name: SignupScreen.name,
          builder: (_, __) {
            return SignupScreen(onSignup: (name, email, password) async {
              await authNotifier.create(
                email: email,
                password: password,
                name: name,
              );
            });
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
            error: authState.error,
            loading: authState.loading,
          ),
        ),
      ],
      redirect: (context, state) {
        final lMatch = state.matchedLocation;
        final qParams = state.uri.queryParameters;
        final authStatus = authState.status;

        if (lMatch == '/' && authStatus == AuthStatus.authenticated) {
          return (authState.user?.prefs.data ?? {})['introSeen'] ??
                  false
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
          return (authState.user?.prefs.data ?? {})['introSeen'] ??
                  false
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
  },
);
