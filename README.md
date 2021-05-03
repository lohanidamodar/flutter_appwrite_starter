# Flutter Appwrite Starter project

**Made with :heartbeat: from Nepal**

A project you can clone to build your next project with [Flutter](https://flutter.dev) + [Appwrite](https://appwrite.io). 

If you don't already know what Appwrite is, it's an open source self-hosted Back-End as a Service for Web, Mobile and Flutter applications. Learn more on [Appwrite.io home page](https://appwrite.io).

## Features
1. Authentication
    - Email based sign up/in
2. Riverpod State management
3. Localization ready
4. Google Fonts
5. Image picker/Cropper
6. Package info
7. User's profile and preferences management

## Getting Started

How to start your project based on this.

1. Clone this repository locally. The folder structure is somewhat based on clean code architecture
2. Delete `.git` folder to clear git history
3. Using `change_app_package_name` package change the package name to whatever you want your package name to be `flutter pub run change_app_package_name:main com.new.package.name`
4. For changing iOS package name use the text editors Find and Replace in whole project folder where you need to find `com.popupbits.flutter_appwrite_starter` and with the package name you want
5. Using the same Find and replace in whole project folder search for `flutter_appwrite_starter` (package name for dart/flutter project) and replace it with your own suitable name. (check the flutter package naming standards for acceptable format)
6. Using the same Find and replace in whole project folder search for `Appwrite Starter` (display name, launcher name) and replace it with your own suitable name for your app
7. in `lib/core/res/constants.dart` update endpoint and project id with your own endpoint and project id details;

## Adding new Locale
TODO Docs

## Contribution
Contribution (suggestions, issues, feature request, pull requests) are highly welcome. Also looking for help in making it testable by adding unit, widget and integration tests.
