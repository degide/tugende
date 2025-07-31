import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugende/dto/user_doc_dto.dart';

// Firebase Auth Service Provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// Google Sign In Provider - Updated for version 7+
final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn.instance;
});

// Auth State Provider
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

class UserState {
  final UserDocDto? user;
  final bool isLoading;

  UserState(this.user, {this.isLoading = false});
}

class UserStateNotifier extends StateNotifier<UserState> {
  static const String _userKey = 'user';
  UserStateNotifier(super.state);

  Future<void> signInUser(UserDocDto user, {bool isLoading = false}) async {
    print('UserStateNotifier: signInUser called with user: ${user.toJson()}, isLoading: $isLoading');
    state = UserState(user, isLoading: isLoading);
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_userKey, state.user?.uid ?? '');
    });
  }

  Future<void> signOutUser() async {
    state = UserState(null, isLoading: false);
    await SharedPreferences.getInstance().then((prefs) {
      prefs.remove(_userKey);
    });
  }

  Future<UserDocDto?> loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_userKey);
    if (userId != null) {
      // Fetch user data from Firestore or any other source
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = UserDocDto.fromJson(userDoc.data()!);
        signInUser(userData, isLoading: false);
        return userData;
      } else {
        signOutUser();
      }
    }
    return null;
  }
}

final userStateProvider = StateNotifierProvider<UserStateNotifier, UserState>((ref) {
  return UserStateNotifier(UserState(null, isLoading: true));
});