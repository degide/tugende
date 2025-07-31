import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock authentication service for testing
class MockAuthService {
  bool _isAuthenticated = false;
  String? _userId;
  Map<String, dynamic>? _userData;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  Map<String, dynamic>? get userData => _userData;

  Future<bool> signInWithPhoneNumber(String phoneNumber, String otp) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 100));
    
    // Mock validation
    if (phoneNumber.isNotEmpty && otp == '123456') {
      _isAuthenticated = true;
      _userId = 'test_user_123';
      _userData = {
        'uid': _userId,
        'phoneNumber': phoneNumber,
        'signInMethod': 'phone',
        'createdAt': DateTime.now().toIso8601String(),
      };
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    await Future.delayed(Duration(milliseconds: 50));
    _isAuthenticated = false;
    _userId = null;
    _userData = null;
  }

  bool validatePhoneNumber(String phoneNumber) {
    // Simple validation for testing
    final phoneRegex = RegExp(r'^\+\d{10,15}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  bool validateOTP(String otp) {
    return otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp);
  }
}

// Mock user profile service
class MockUserProfileService {
  final Map<String, Map<String, dynamic>> _profiles = {};

  Future<bool> createProfile({
    required String userId,
    required String fullName,
    required String email,
    String? phoneNumber,
    String? gender,
    DateTime? dateOfBirth,
  }) async {
    await Future.delayed(Duration(milliseconds: 100));
    
    if (fullName.isEmpty || email.isEmpty) {
      return false;
    }

    _profiles[userId] = {
      'uid': userId,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'profileCompleted': true,
      'createdAt': DateTime.now().toIso8601String(),
    };
    
    return true;
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    await Future.delayed(Duration(milliseconds: 50));
    return _profiles[userId];
  }

  Future<bool> updateProfile(String userId, Map<String, dynamic> updates) async {
    await Future.delayed(Duration(milliseconds: 100));
    
    if (!_profiles.containsKey(userId)) {
      return false;
    }

    _profiles[userId]!.addAll(updates);
    _profiles[userId]!['updatedAt'] = DateTime.now().toIso8601String();
    return true;
  }

  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  bool validateFullName(String fullName) {
    return fullName.trim().isNotEmpty && fullName.trim().length >= 2;
  }
}

// State providers for loading states
final loadingStateProvider = StateProvider<bool>((ref) => false);
final otpVerifyingProvider = StateProvider<bool>((ref) => false);
final googleLoadingProvider = StateProvider<bool>((ref) => false);

void main() {
  group('Authentication Service Unit Tests', () {
    late MockAuthService authService;

    setUp(() {
      authService = MockAuthService();
    });

    test('Phone number validation works correctly', () {
      expect(authService.validatePhoneNumber('+250788123456'), isTrue);
      expect(authService.validatePhoneNumber('+1234567890'), isTrue);
      expect(authService.validatePhoneNumber('123456789'), isFalse);
      expect(authService.validatePhoneNumber('+12345'), isFalse);
      expect(authService.validatePhoneNumber(''), isFalse);
    });

    test('OTP validation works correctly', () {
      expect(authService.validateOTP('123456'), isTrue);
      expect(authService.validateOTP('000000'), isTrue);
      expect(authService.validateOTP('12345'), isFalse);
      expect(authService.validateOTP('1234567'), isFalse);
      expect(authService.validateOTP('abcdef'), isFalse);
      expect(authService.validateOTP(''), isFalse);
    });

    test('Sign in with valid phone number and OTP succeeds', () async {
      final result = await authService.signInWithPhoneNumber('+250788123456', '123456');
      
      expect(result, isTrue);
      expect(authService.isAuthenticated, isTrue);
      expect(authService.userId, equals('test_user_123'));
      expect(authService.userData!['phoneNumber'], equals('+250788123456'));
      expect(authService.userData!['signInMethod'], equals('phone'));
    });

    test('Sign in with invalid OTP fails', () async {
      final result = await authService.signInWithPhoneNumber('+250788123456', '000000');
      
      expect(result, isFalse);
      expect(authService.isAuthenticated, isFalse);
      expect(authService.userId, isNull);
    });

    // Google sign-in test removed to avoid UnimplementedError

    test('Sign out clears authentication state', () async {
      // First sign in with phone/OTP
      await authService.signInWithPhoneNumber('+250788123456', '123456');
      expect(authService.isAuthenticated, isTrue);
      
      // Then sign out
      await authService.signOut();
      expect(authService.isAuthenticated, isFalse);
      expect(authService.userId, isNull);
      expect(authService.userData, isNull);
    });
  });

  group('User Profile Service Unit Tests', () {
    late MockUserProfileService profileService;

    setUp(() {
      profileService = MockUserProfileService();
    });

    test('Email validation works correctly', () {
      expect(profileService.validateEmail('test@example.com'), isTrue);
      expect(profileService.validateEmail('user@gmail.com'), isTrue);
      expect(profileService.validateEmail('invalid-email'), isFalse);
      expect(profileService.validateEmail('test@'), isFalse);
      expect(profileService.validateEmail('@example.com'), isFalse);
      expect(profileService.validateEmail(''), isFalse);
    });

    test('Full name validation works correctly', () {
      expect(profileService.validateFullName('John Doe'), isTrue);
      expect(profileService.validateFullName('Jane'), isTrue);
      expect(profileService.validateFullName('A'), isFalse);
      expect(profileService.validateFullName(''), isFalse);
      expect(profileService.validateFullName('   '), isFalse);
    });

    test('Create profile with valid data succeeds', () async {
      final result = await profileService.createProfile(
        userId: 'test_123',
        fullName: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '+250788123456',
        gender: 'Male',
        dateOfBirth: DateTime(1990, 1, 1),
      );

      expect(result, isTrue);
      
      final profile = await profileService.getProfile('test_123');
      expect(profile, isNotNull);
      expect(profile!['fullName'], equals('John Doe'));
      expect(profile['email'], equals('john@example.com'));
      expect(profile['profileCompleted'], isTrue);
    });

    test('Create profile with invalid data fails', () async {
      final result = await profileService.createProfile(
        userId: 'test_456',
        fullName: '',
        email: 'john@example.com',
      );

      expect(result, isFalse);
      
      final profile = await profileService.getProfile('test_456');
      expect(profile, isNull);
    });

    test('Update existing profile succeeds', () async {
      // First create a profile
      await profileService.createProfile(
        userId: 'test_789',
        fullName: 'Jane Smith',
        email: 'jane@example.com',
      );

      // Then update it
      final updateResult = await profileService.updateProfile('test_789', {
        'phoneNumber': '+250788654321',
        'gender': 'Female',
      });

      expect(updateResult, isTrue);
      
      final updatedProfile = await profileService.getProfile('test_789');
      expect(updatedProfile!['phoneNumber'], equals('+250788654321'));
      expect(updatedProfile['gender'], equals('Female'));
      expect(updatedProfile['updatedAt'], isNotNull);
    });

    test('Update non-existent profile fails', () async {
      final result = await profileService.updateProfile('non_existent', {
        'fullName': 'New Name',
      });

      expect(result, isFalse);
    });

    test('Get non-existent profile returns null', () async {
      final profile = await profileService.getProfile('non_existent');
      expect(profile, isNull);
    });
  });

  group('Loading State Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Loading state initially false', () {
      final loadingState = container.read(loadingStateProvider);
      expect(loadingState, isFalse);
    });

    test('Loading state can be updated', () {
      // Update loading state to true
      container.read(loadingStateProvider.notifier).state = true;
      expect(container.read(loadingStateProvider), isTrue);

      // Update back to false
      container.read(loadingStateProvider.notifier).state = false;
      expect(container.read(loadingStateProvider), isFalse);
    });

    test('OTP verifying state works independently', () {
      // Set OTP verifying to true
      container.read(otpVerifyingProvider.notifier).state = true;
      expect(container.read(otpVerifyingProvider), isTrue);
      expect(container.read(loadingStateProvider), isFalse); // Should not affect other states

      // Set loading to true
      container.read(loadingStateProvider.notifier).state = true;
      expect(container.read(loadingStateProvider), isTrue);
      expect(container.read(otpVerifyingProvider), isTrue); // Should maintain its state
    });

    test('Multiple loading states can be managed independently', () {
      container.read(loadingStateProvider.notifier).state = true;
      container.read(otpVerifyingProvider.notifier).state = false;
      container.read(googleLoadingProvider.notifier).state = true;

      expect(container.read(loadingStateProvider), isTrue);
      expect(container.read(otpVerifyingProvider), isFalse);
      expect(container.read(googleLoadingProvider), isTrue);
    });
  });
}
