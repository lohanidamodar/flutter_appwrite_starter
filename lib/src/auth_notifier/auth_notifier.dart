import 'dart:developer' as developer;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';
import 'auth_status.dart';

class AuthNotifier extends Notifier<AuthState> {
  late final Account _account;

  AuthNotifier(this._account);

  @override
  AuthState build() {
    state = AuthState();
    _getUser();
    return state;
  }

  Account get account => _account;
  Future _getUser() async {
    try {
      state = state.copyWith(loading: true);
      final user = await _account.get();
      state = state.copyWith(
        user: user,
        loading: false,
        error: null,
        status: AuthStatus.authenticated,
      );
      developer.postEvent(
        'appwrite_kit:authEvent',
        state.toMap(),
      );
    } on AppwriteException catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: e.message,
        user: null,
        loading: false,
      );
      developer.postEvent('appwrite_kit:authEvent', state.toMap());
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loading: false,
        user: null,
        status: AuthStatus.unauthenticated,
      );
    }
  }

  Future<bool> deleteSession({String sessionId = 'current'}) async {
    try {
      state = state.copyWith(loading: true);
      await _account.deleteSession(sessionId: sessionId);
      state = state.copyWith(
        error: null,
        status: AuthStatus.unauthenticated,
        loading: false,
        user: null,
      );
      developer.postEvent('appwrite_kit:authEvent', {
        "type": "deleteSession",
        "session": {"id": sessionId}
      });
      return true;
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message, user: null, loading: false);
      return false;
    }
  }

  Future<bool> deleteSessions() async {
    try {
      state = state.copyWith(loading: true);
      await _account.deleteSessions();
      state = state.copyWith(
        loading: false,
        user: null,
        status: AuthStatus.unauthenticated,
      );
      return true;
    } on AppwriteException catch (e) {
      state = state.copyWith(loading: false, error: e.message);
      return false;
    }
  }

  Future<bool> createEmailSession({
    required String email,
    required String password,
    bool notify = true,
  }) async {
    state = state.copyWith(
      status: AuthStatus.authenticating,
      loading: true,
    );
    try {
      await _account.createEmailPasswordSession(
          email: email, password: password);
      await _getUser();
      return true;
    } on AppwriteException catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        loading: false,
        error: e.message,
      );
      return false;
    }
  }

  Future<Token?> createPhoneSession({
    required String userId,
    required String number,
  }) async {
    state = state.copyWith(
      status: AuthStatus.authenticating,
      loading: true,
    );
    try {
      final token =
          await _account.createPhoneToken(userId: userId, phone: number);
      state = state.copyWith(loading: false);
      return token;
    } on AppwriteException catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        loading: false,
        error: e.message,
      );
      return null;
    }
  }

  Future<bool> updatePhoneSession({
    required String userId,
    required String secret,
  }) async {
    state = state.copyWith(
      status: AuthStatus.authenticating,
      loading: true,
    );
    try {
      await _account.updatePhoneSession(userId: userId, secret: secret);
      await _getUser();
      return true;
    } on AppwriteException catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        loading: false,
        error: e.message,
      );
      return false;
    }
  }

  Future<bool> createAnonymousSession() async {
    state = state.copyWith(
      status: AuthStatus.authenticating,
      loading: true,
    );
    try {
      await _account.createAnonymousSession();
      await _getUser();
      return true;
    } on AppwriteException catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        loading: false,
        error: e.message,
      );
      return false;
    }
  }

  Future<bool> createMagicURLToken({
    required String email,
    String userId = 'unique()',
    String? url,
  }) async {
    state = state.copyWith(
      status: AuthStatus.authenticating,
      loading: true,
    );
    try {
      await _account.createMagicURLToken(
          userId: userId, email: email, url: url);
      state = state.copyWith(loading: false);
      return true;
    } on AppwriteException catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        loading: false,
        error: e.message,
      );
      return false;
    }
  }

  Future<bool> updateMagicURLSession({
    required String userId,
    required String secret,
  }) async {
    state = state.copyWith(
      status: AuthStatus.authenticating,
      loading: true,
    );
    try {
      await _account.updateMagicURLSession(userId: userId, secret: secret);
      await _getUser();
      return true;
    } on AppwriteException catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        loading: false,
        error: e.message,
      );
      return false;
    }
  }

  Future<Jwt?> createJWT() async {
    try {
      return await _account.createJWT();
    } on AppwriteException catch (e) {
      state = state.copyWith(
        error: e.message,
      );
      return null;
    }
  }

  /// Create account
  ///
  Future<User?> create({
    required String email,
    required String password,
    String userId = 'unique()',
    bool notify = true,
    bool newSession = true,
    String? name,
  }) async {
    state = state.copyWith(
      status: AuthStatus.authenticating,
      loading: true,
    );
    try {
      final user = await _account.create(
          userId: userId, name: name, email: email, password: password);

      if (newSession) {
        await createEmailSession(email: email, password: password);
      }
      return user;
    } on AppwriteException catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        loading: true,
        error: e.message,
      );
      return null;
    }
  }

  Future<bool> updateStatus() async {
    try {
      state = state.copyWith(loading: true);
      await _account.updateStatus();
      await _getUser();
      return true;
    } on AppwriteException catch (e) {
      state = state.copyWith(loading: false, error: e.message);
      return false;
    }
  }

  Future<User?> updatePrefs({required Map<String, dynamic> prefs}) async {
    try {
      final user = await _account.updatePrefs(prefs: prefs);
      state = state.copyWith(loading: false, user: user);
      return user;
    } on AppwriteException catch (e) {
      state = state.copyWith(loading: false, error: e.message);
      return null;
    }
  }

  Future<LogList?> listLogs({List<String>? queries}) async {
    try {
      return await _account.listLogs(queries: queries);
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  Future<bool> createOAuth2Session({
    required OAuthProvider provider,
    String? success,
    String? failure,
    List<String>? scopes,
  }) async {
    try {
      state = state.copyWith(loading: true, status: AuthStatus.authenticating);
      await _account.createOAuth2Session(
        provider: provider,
        success: success,
        failure: failure,
        scopes: scopes,
      );
      await _getUser();
      return true;
    } on AppwriteException catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.message,
        status: AuthStatus.authenticated,
      );
      return false;
    }
  }

  Future<Session?> getSession({required String sessionId}) async {
    try {
      return await _account.getSession(sessionId: sessionId);
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  Future<SessionList?> listSessions() async {
    try {
      return await _account.listSessions();
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  Future<User?> updateName({required String name}) async {
    try {
      final user = await _account.updateName(name: name);
      state = state.copyWith(user: user);
      return user;
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  Future<User?> updatePhone({
    required String number,
    required String password,
  }) async {
    try {
      final user =
          await _account.updatePhone(phone: number, password: password);
      state = state.copyWith(user: user);
      return user;
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  Future<User?> updateEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _account.updateEmail(email: email, password: password);
      state = state.copyWith(user: user);
      return user;
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  Future<User?> updatePassword({
    required String password,
    String? oldPassword,
  }) async {
    try {
      final user = await _account.updatePassword(
        password: password,
        oldPassword: oldPassword,
      );
      state = state.copyWith(user: user);
      return user;
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  //createRecovery
  Future<Token?> createRecovery({
    required String email,
    required String url,
  }) async {
    try {
      return await _account.createRecovery(email: email, url: url);
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  //updateRecovery
  Future<Token?> updateRecovery({
    required String userId,
    required String password,
    required String secret,
  }) async {
    try {
      return await _account.updateRecovery(
        userId: userId,
        password: password,
        secret: secret,
      );
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  //createVerification
  Future<Token?> createVerification({required String url}) async {
    try {
      return await _account.createVerification(url: url);
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  //updateVerification
  Future<Token?> updateVerification({
    required String userId,
    required String secret,
  }) async {
    try {
      return await _account.updateVerification(userId: userId, secret: secret);
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  /// createPhoneVerification
  Future<Token?> createPhoneVerification() async {
    try {
      return await _account.createPhoneVerification();
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }

  /// updatePhoneVerification
  Future<Token?> updatePhoneVerification({
    required String userId,
    required String secret,
  }) async {
    try {
      return await _account.updatePhoneVerification(
        userId: userId,
        secret: secret,
      );
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    }
  }
}
