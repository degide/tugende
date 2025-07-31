import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  UserStateNotifier(super.state);

  void signInUser(UserDocDto? user, {bool isLoading = false}) {
    state = UserState(user, isLoading: isLoading);
  }

  void signOutUser() {
    state = UserState(null, isLoading: false);
  }

  void setLoading(bool isLoading) {
    state = UserState(state.user, isLoading: isLoading);
  }
}

final userStateProvider = StateNotifierProvider<UserStateNotifier, UserState>((ref) {
  return UserStateNotifier(UserState(null, isLoading: true));
});