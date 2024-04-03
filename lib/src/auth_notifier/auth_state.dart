import 'dart:convert';
import 'package:appwrite/models.dart';

import 'auth_status.dart';

class AuthState {
  final User? user;
  final AuthStatus status;
  final bool loading;
  final String? error;

  AuthState({
    this.user,
    this.status = AuthStatus.uninitialized,
    this.loading = false,
    this.error,
  });

  AuthState copyWith({
    String? error,
    User? user,
    bool? loading,
    AuthStatus? status,
  }) {
    return AuthState(
      error: error ?? this.error,
      user: user ?? this.user,
      loading: loading ?? this.loading,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState &&
        other.user == user &&
        other.status == status &&
        other.loading == loading &&
        other.error == error;
  }

  @override
  int get hashCode {
    return user.hashCode ^ status.hashCode ^ loading.hashCode ^ error.hashCode;
  }

  @override
  String toString() {
    return 'AuthState(user: $user, status: $status, loading: $loading, error: $error)';
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'status': status.name,
      'loading': loading,
      'error': error,
    };
  }

  factory AuthState.fromMap(Map<String, dynamic> map) {
    return AuthState(
      user: map['user'] != null ? User.fromMap(map['user']) : null,
      status: (map['status'].toString()).authStatus,
      loading: map['loading'] ?? false,
      error: map['error'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthState.fromJson(String source) =>
      AuthState.fromMap(json.decode(source));
}
