import 'dart:typed_data';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:flutter_appwrite_starter/features/auth/presentation/pages/crop_page.dart';
import 'package:flutter_appwrite_starter/features/auth/presentation/pages/login.dart';
import 'package:flutter_appwrite_starter/features/auth/presentation/pages/signup.dart';
import 'package:flutter_appwrite_starter/features/auth/presentation/pages/splash.dart';
import 'package:flutter_appwrite_starter/features/auth/presentation/pages/welcome.dart';
import 'package:flutter_appwrite_starter/features/home/presentation/pages/home.dart';
import 'package:flutter_appwrite_starter/features/onboarding/presentation/pages/intro.dart';
import 'package:flutter_appwrite_starter/features/profile/presentation/pages/edit_profile.dart';
import 'package:flutter_appwrite_starter/features/profile/presentation/pages/profile.dart';
import 'package:go_router/go_router.dart';

abstract class AppRoutes {
  static const home = "/";
  static const splash = "splash";
  static const login = "login";
  static const signup = "signup";
  static const userInfo = "user_info";
  static const String profile = "profile";
  static const String editProfile = "edit_profile";
  static const String cropPage = "crop_page";

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: AppRoutes.home,
        builder: (context, __) =>
            context.authNotifier.status == AuthStatus.authenticated
                ? const HomePage()
                : const WelcomePage(),
        routes: [
          GoRoute(path: 'loading', builder: (_, __) => const Splash()),
          GoRoute(
            path: 'login',
            name: AppRoutes.login,
            builder: (_, __) => const LoginPage(),
          ),
          GoRoute(
            path: 'signup',
            name: AppRoutes.signup,
            builder: (_, __) => const SignupPage(),
          ),
          GoRoute(
            path: 'profile',
            name: AppRoutes.profile,
            builder: (_, __) => const UserProfile(),
            routes: [
              GoRoute(
                path: 'edit',
                name: AppRoutes.editProfile,
                builder: (_, __) => const EditProfile(),
                routes: [
                  GoRoute(
                    path: 'crop',
                    name: AppRoutes.cropPage,
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
    ],
    redirect: (context, state) {
      final lMatch = state.matchedLocation;
      final qParams = state.queryParameters;
      final authStatus = context.authNotifier.status;

      if (lMatch == '/' && authStatus == AuthStatus.authenticated) {
        return (context.authNotifier.user?.prefs.data ?? {})['introSeen'] ??
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
        return (context.authNotifier.user?.prefs.data ?? {})['introSeen'] ??
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
}
