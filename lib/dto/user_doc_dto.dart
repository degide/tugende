import 'package:cloud_firestore/cloud_firestore.dart';

class UserDocDto {
  String uid;
  String? email;
  String? displayName;
  String? photoURL;
  String? phoneNumber;
  Timestamp? createdAt;
  bool isActive;
  bool profileCompleted;
  String signInMethod;
  Timestamp? lastSignInAt;
  String? googleId;

  UserDocDto({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    this.createdAt,
    required this.isActive,
    required this.profileCompleted,
    required this.signInMethod,
    this.lastSignInAt,
    this.googleId,
  });

  factory UserDocDto.fromJson(Map<String, dynamic> json) {
    print('UserDocDto.fromJson: $json'); // Debugging line
    try {
      return UserDocDto(
        uid: json['uid'] as String,
        email: json['email'] as String?,
        displayName: json['displayName'] as String?,
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
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'isActive': isActive,
      'profileCompleted': profileCompleted,
      'signInMethod': signInMethod,
      'lastSignInAt': lastSignInAt,
      'googleId': googleId,
    };
  }
}