import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/features/auth/presentation/pages/crop_page.dart';
import 'package:flutter_appwrite_starter/features/auth/presentation/pages/home.dart';
import 'package:flutter_appwrite_starter/features/auth/presentation/pages/login.dart';
import 'package:flutter_appwrite_starter/features/auth/presentation/pages/signup.dart';
import 'package:flutter_appwrite_starter/features/auth/presentation/pages/splash.dart';
import 'package:flutter_appwrite_starter/features/auth/presentation/pages/user_info.dart';
import 'package:flutter_appwrite_starter/features/profile/presentation/pages/edit_profile.dart';
import 'package:flutter_appwrite_starter/features/profile/presentation/pages/profile.dart';

class AppRoutes {
  static const home = "/";
  static const splash = "splash";
  static const login = "login";
  static const signup = "signup";
  static const userInfo = "user_info";
  static const String profile = "profile";
  static const String editProfile = "edit_profile";
  static const String cropPage = "crop_page";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        settings: settings,
        builder: (_) {
          switch (settings.name) {
            case home:
              return const AuthHomePage();
            case userInfo:
              return const UserInfoPage();
            case editProfile:
              return const EditProfile();
            case cropPage:
              return CropPage(
                image: settings.arguments as Uint8List?,
              );
            case profile:
              return const UserProfile();
            case login:
              return const LoginPage();
            case signup:
              return const SignupPage();
            case splash:
            default:
              return const Splash();
          }
        });
  }
}
