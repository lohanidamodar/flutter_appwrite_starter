enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
}

extension AuthStatusExtension on String {
  AuthStatus get authStatus {
    switch (this) {
      case 'uninitialized':
        return AuthStatus.uninitialized;
      case 'authenticated':
        return AuthStatus.authenticated;
      case 'authenticating':
        return AuthStatus.authenticating;
      case 'unauthenticated':
        return AuthStatus.unauthenticated;
      default:
        throw AuthStatus.uninitialized;
    }
  }
}
