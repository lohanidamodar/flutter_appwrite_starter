import 'dart:typed_data';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/auth.dart';
import 'package:home/home.dart';
import 'package:intro/intro.dart';
import 'package:profile/profile.dart';

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
                ? HomePage(
                    onPressedProfile: () => context.goNamed(AppRoutes.profile),
                  )
                : WelcomePage(
                    onSignup: () => context.goNamed(signup),
                  ),
        routes: [
          GoRoute(path: 'loading', builder: (_, __) => const Splash()),
          GoRoute(
            path: 'login',
            name: AppRoutes.login,
            builder: (context, __) => LoginPage(
              onSignup: () => context.goNamed(signup),
              onPop: context.pop,
            ),
          ),
          GoRoute(
            path: 'signup',
            name: AppRoutes.signup,
            builder: (context, __) => SignupPage(
              onPop: context.pop,
            ),
          ),
          GoRoute(
            path: 'profile',
            name: AppRoutes.profile,
            builder: (context, __) => UserProfile(
              onPressedEditProfile: () => context.goNamed(editProfile),
            ),
            routes: [
              GoRoute(
                path: 'edit',
                name: AppRoutes.editProfile,
                builder: (context, __) => EditProfile(
                  onPop: context.pop,
                  onGotoCropPage: (image) {
                    return context.pushNamed<Uint8List?>(
                      cropPage,
                      extra: image,
                    );
                  },
                ),
                routes: [
                  GoRoute(
                    path: 'crop',
                    name: AppRoutes.cropPage,
                    builder: (context, state) => CropPage(
                      image: state.extra as Uint8List?,
                      onImageCropped: (image) => context.pop(image),
                    ),
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
