import 'dart:convert';

class UserPrefs {
  final DateTime? lastLoggedIn;
  final DateTime? registrationDate;
  final String? photoUrl;
  final int? buildNumber;
  final bool? introSeen;
  final String? photoId;

  UserPrefs({
    this.lastLoggedIn,
    this.registrationDate,
    this.photoUrl,
    this.buildNumber,
    this.introSeen,
    this.photoId,
  });

  UserPrefs copyWith({
    DateTime? lastLoggedIn,
    DateTime? registrationDate,
    String? photoUrl,
    int? buildNumber,
    bool? introSeen,
    String? photoId,
  }) {
    return UserPrefs(
      lastLoggedIn: lastLoggedIn ?? this.lastLoggedIn,
      registrationDate: registrationDate ?? this.registrationDate,
      photoUrl: photoUrl ?? this.photoUrl,
      buildNumber: buildNumber ?? this.buildNumber,
      introSeen: introSeen ?? this.introSeen,
      photoId: photoId ?? this.photoId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastLoggedIn': lastLoggedIn?.millisecondsSinceEpoch,
      'registrationDate': registrationDate?.millisecondsSinceEpoch,
      'photoUrl': photoUrl,
      'buildNumber': buildNumber,
      'introSeen': introSeen,
      'photoId': photoId,
    };
  }

  factory UserPrefs.fromMap(Map<String, dynamic> map) {
    return UserPrefs(
      lastLoggedIn: map['lastLoggedIn'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastLoggedIn'])
          : null,
      registrationDate: map['registrationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['registrationDate'])
          : null,
      photoUrl: map['photoUrl'],
      buildNumber: map['buildNumber'],
      introSeen: map['introSeen'],
      photoId: map['photoId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserPrefs.fromJson(String source) =>
      UserPrefs.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserPrefs(lastLoggedIn: $lastLoggedIn, registrationDate: $registrationDate, photoUrl: $photoUrl, buildNumber: $buildNumber, introSeen: $introSeen)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserPrefs &&
        other.lastLoggedIn == lastLoggedIn &&
        other.registrationDate == registrationDate &&
        other.photoUrl == photoUrl &&
        other.buildNumber == buildNumber &&
        other.introSeen == introSeen;
  }

  @override
  int get hashCode {
    return lastLoggedIn.hashCode ^
        registrationDate.hashCode ^
        photoUrl.hashCode ^
        buildNumber.hashCode ^
        introSeen.hashCode;
  }
}
