import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tugende/config/routes_config.dart';
import 'package:tugende/dto/user_doc_dto.dart';
import 'package:tugende/providers/auth_provider.dart';

final loadingProvider = StateProvider<bool>((ref) => false);
final googleLoadingProvider = StateProvider<bool>((ref) => false);

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+250'; //Rwanda
  bool _agreedToTerms = false;

  final Map<String, String> _countryCodes = {
    '+250': '🇷🇼', '+256': '🇺🇬', '+254': '🇰🇪',
    '+255': '🇹🇿', '+233': '🇬🇭', '+234': '🇳🇬',
    '+27': '🇿🇦', '+1': '🇺🇸', '+44': '🇬🇧',
  };

  // Required scopes for Google Sign-In requires real device testing.
  // 'openid' is often implicitly included or required for idToken.
  // static const List<String> _scopes = <String>[
  //   'email',
  //   'profile',
  //   'openid',
  // ];

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (!_agreedToTerms || _phoneController.text.trim().isEmpty) {
      _showSnackBar('Please fill all fields and agree to terms');
      return;
    }

    ref.read(loadingProvider.notifier).state = true;
    final phoneNumber = _selectedCountryCode + _phoneController.text.trim();

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ref.read(loadingProvider.notifier).state = false;
          _handleVerificationError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          ref.read(loadingProvider.notifier).state = false;
          Navigator.pushNamed(
            context,
            '/otp-verification',
            arguments: {
              'verificationId': verificationId,
              'phoneNumber': phoneNumber,
              'resendToken': resendToken,
            },
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
        },
      );
    } catch (e) {
      ref.read(loadingProvider.notifier).state = false;
      _showSnackBar('Error: ${e.toString()}');
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      await _createUserProfile(userCredential.user);
      
      final userDoc = FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid);
      final docSnapshot = await userDoc.get();
      if (mounted && docSnapshot.exists) {
        final user = UserDocDto.fromJson(docSnapshot.data()!);
        ref.read(userStateProvider.notifier).signInUser(user);
        Navigator.pushNamedAndRemoveUntil(context, RouteNames.homeScreen, (route) => false);
      }
    } catch (e) {
      _showSnackBar('Sign-in failed');
    } finally {
      ref.read(loadingProvider.notifier).state = false;
    }
  }

  Future<void> _createUserProfile(User? user) async {
    if (user == null) return;

    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        await userDoc.set({
          'uid': user.uid,
          'phoneNumber': user.phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
          'isActive': true,
          'profileCompleted': false,
          'signInMethod': 'phone',
          'lastSignInAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error creating user profile: $e');
    }
  }

  void _handleVerificationError(FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'invalid-phone-number':
        errorMessage = 'Invalid phone number format';
        break;
      case 'too-many-requests':
        errorMessage = 'Too many requests. Try again later';
        break;
      case 'quota-exceeded':
        errorMessage = 'SMS quota exceeded. Try again tomorrow';
        break;
      default:
        errorMessage = 'Verification failed: ${e.message}';
    }
    _showSnackBar(errorMessage);
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final isGoogleLoading = ref.watch(googleLoadingProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBE6),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleSection(),
                        const SizedBox(height: 25),
                        _buildPhoneInputField(),
                        const SizedBox(height: 15),
                        _buildTermsCheckbox(),
                        const SizedBox(height: 20),
                        _buildActionButton(
                          text: isLoading ? 'Sending...' : 'Start ride-sharing',
                          color: const Color(0xFF0D3C34),
                          onPressed: (isLoading || isGoogleLoading) ? null : (_agreedToTerms && _phoneController.text.isNotEmpty ? _sendOTP : null),
                        ),
                        const SizedBox(height: 15),
                        _buildActionButton(
                          text: 'Continue to Login',
                          color: const Color(0xFFF2B200),
                          textColor: Colors.black,
                          onPressed: (isLoading || isGoogleLoading) ? null : () => Navigator.pushNamed(context, '/login'),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button positioned at the top
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            padding: const EdgeInsets.all(10),
            constraints: const BoxConstraints(),
          ),
        ),
        const SizedBox(height: 15),
        // Title and description
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Join TugendeApp!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your phone number to create your Tugende account!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            Image.asset('assets/images/taxi_icon.png', width: 50, height: 50),
          ],
        ),
      ],
    );
  }

  Widget _buildPhoneInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _selectedCountryCode = value);
            },
            child: Row(
              children: [
                Text(_countryCodes[_selectedCountryCode] ?? ''),
                const SizedBox(width: 5),
                Text(_selectedCountryCode),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
            itemBuilder: (context) => _countryCodes.entries.map((e) {
              return PopupMenuItem<String>(
                value: e.key,
                child: Row(
                  children: [
                    Text(e.value),
                    const SizedBox(width: 10),
                    Text(e.key),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Phone Number',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          visualDensity: VisualDensity.compact,
          value: _agreedToTerms,
          onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
        ),
        Expanded(
          child: RichText(
            textAlign: TextAlign.left,
            text: const TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(text: 'I agree to Tugende\'s '),
                TextSpan(
                  text: 'terms and conditions',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    // final isGoogleLoading = ref.watch(googleLoadingProvider);
    
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0D3C34),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // const SizedBox(height: 20),
          // const Text(
          //   'Continue with:',
          //   style: TextStyle(color: Colors.white, fontSize: 16),
          // ),
          // const SizedBox(height: 15),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     _SocialCircle(
          //       icon: FontAwesomeIcons.google,
          //       isLoading: isGoogleLoading,
          //       onTap: _signInWithGoogle,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}