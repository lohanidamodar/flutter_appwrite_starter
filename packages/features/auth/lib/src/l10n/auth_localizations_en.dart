import 'auth_localizations.dart';

/// The translations for English (`en`).
class AuthLocalizationsEn extends AuthLocalizations {
  AuthLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginButtonText => 'Login';

  @override
  String get signupButtonText => 'Sign up';

  @override
  String get googleButtonText => 'Continue with Google';

  @override
  String get welcomePageTitle => 'Welcome';

  @override
  String get welcomePageSubtitle => 'FlAppwrite Starter App';

  @override
  String get emailFieldlabel => 'Email';

  @override
  String get passwordFieldLabel => 'Password';

  @override
  String get emailValidationError => 'Please enter email';

  @override
  String get passwordValidationError => 'Please enter password';

  @override
  String get confirmPasswordValidationEmptyError => 'Please confirm password';

  @override
  String get confirmPasswordValidationMatchError => 'Passwords do not match';

  @override
  String get confirmPasswordFieldLabel => 'Confirm password';

  @override
  String get nameFieldLabel => 'Name';

  @override
  String get nameValidationError => 'Please enter name';
}
