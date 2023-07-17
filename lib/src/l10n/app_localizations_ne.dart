import 'app_localizations.dart';

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get appName => 'FlAppwrite Starter';

  @override
  String get loginButtonText => 'लगिन';

  @override
  String get signupButtonText => 'बनाउनुहोस';

  @override
  String get googleButtonText => 'Google लगिन';

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
}
