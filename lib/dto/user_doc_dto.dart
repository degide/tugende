import 'package:cloud_firestore/cloud_firestore.dart';

class UserDocDto {
  String uid;
  String? email;
  String? fullName;
  String? photoURL;
  String? phoneNumber;
  Timestamp? createdAt;
  bool isActive;
  bool profileCompleted;
  String signInMethod;
  Timestamp? lastSignInAt;
  String? googleId;
  DateTime? dateOfBirth;
  String? gender;

  UserDocDto({
    required this.uid,
    this.email,
    this.fullName,
    this.photoURL,
    this.phoneNumber,
    this.createdAt,
    required this.isActive,
    required this.profileCompleted,
    required this.signInMethod,
    this.lastSignInAt,
    this.googleId,
    this.dateOfBirth,
    this.gender,
  });

  //copyWith
  UserDocDto copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? photoURL,
    String? phoneNumber,
    Timestamp? createdAt,
    bool? isActive,
    bool? profileCompleted,
    String? signInMethod,
    Timestamp? lastSignInAt,
    String? googleId,
    DateTime? dateOfBirth,
    String? gender,
  }) {
    return UserDocDto(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      signInMethod: signInMethod ?? this.signInMethod,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      googleId: googleId ?? this.googleId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }

  factory UserDocDto.fromJson(Map<String, dynamic> json) {
    print('UserDocDto.fromJson: $json');
    try {
      return UserDocDto(
        uid: json['uid'] as String,
        email: json['email'] as String?,
        fullName: json['fullName'] as String?,
        photoURL: json['photoURL'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        createdAt: json['createdAt'] != null
            ? json['createdAt'] as Timestamp
            : null,
        isActive: json['isActive'] as bool? ?? false,
        profileCompleted: json['profileCompleted'] as bool? ?? false,
        signInMethod: json['signInMethod'] as String? ?? 'unknown',
        lastSignInAt: json['lastSignInAt'] != null
            ? json['lastSignInAt'] as Timestamp
            : null,
        googleId: json['googleId'] as String?,
        dateOfBirth: json['dateOfBirth'] != null
            ? DateTime.parse(json['dateOfBirth'])
            : null,
        gender: json['gender'] as String?,
      );
    } catch (e) {
      print('Error parsing UserDocDto from JSON: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'isActive': isActive,
      'profileCompleted': profileCompleted,
      'signInMethod': signInMethod,
      'lastSignInAt': lastSignInAt,
      'googleId': googleId,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
    };
  }
}