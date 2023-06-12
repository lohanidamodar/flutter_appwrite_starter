import 'profile_localizations.dart';

/// The translations for English (`en`).
class ProfileLocalizationsEn extends ProfileLocalizations {
  ProfileLocalizationsEn([String locale = 'en']) : super(locale);

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
}
