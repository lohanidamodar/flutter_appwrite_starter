import 'dart:typed_data';
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
  static final loadingRouter = GoRouter(routes: [
    GoRoute(path: '/', builder: (_, __) => const Splash()),
  ]);

  static final introRouter = GoRouter(routes: [
    GoRoute(path: '/', builder: (_, __) => const IntroPage()),
  ]);

  static final publicRouter = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          name: AppRoutes.home,
          builder: (_, __) => const WelcomePage(),
          routes: [
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
          ]),
    ],
  );

  static final privateRouter = GoRouter(routes: [
    GoRoute(
      path: '/',
      name: AppRoutes.home,
      builder: (_, __) => const HomePage(),
      routes: [
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
                  builder: (_, state) => CropPage(
                      image: state.queryParameters['image'] as Uint8List?),
                )
              ],
            ),
          ],
        ),
      ],
    ),
  ]);
}
