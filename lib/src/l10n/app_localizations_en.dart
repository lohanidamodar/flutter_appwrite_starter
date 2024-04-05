import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'FlAppwrite starter';

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
  String get logoutButtonText => 'Log out';

  @override
  String get profilePageTitle => 'Profile';

  @override
  String get nameFieldLabel => 'Name';

  @override
  String get nameValidationError => 'Please enter name';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get saveButtonLabel => 'Save';

  @override
  String get pickFromGalleryButtonLabel => 'Gallery';

  @override
  String get pickFromCameraButtonLabel => 'Take Photo';

  @override
  String get cancelButtonLabel => 'Cancel';

  @override
  String get pickImageDialogTitle => 'Pick Image';

  @override
  String get introFinishButtonLabel => 'Get Started';

  @override
  String get newUserRegisterButtonLabel => 'new user? register';

  @override
  String get loginFormTitle => 'Login';
}
