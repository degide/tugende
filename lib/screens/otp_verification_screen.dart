import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:tugende/config/routes_config.dart';

// Separate state providers for different loading states
final otpVerifyingProvider = StateProvider<bool>((ref) => false);
final otpResendingProvider = StateProvider<bool>((ref) => false);

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  static const int _otpLength = 6; // Firebase OTP is usually 6 digits

  late final List<TextEditingController> _otpControllers;
  late final List<FocusNode> _focusNodes;

  int _resendTimer = 60;
  bool _canResend = false;
  Timer? _timer;

  // Route arguments
  late String phoneNumber;
  late String verificationId;
  int? resendToken;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _startResendTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Fix: Properly handle the Map arguments
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (arguments != null) {
      phoneNumber = arguments['phoneNumber'] as String? ?? '+000 000 0000';
      verificationId = arguments['verificationId'] as String? ?? '';
      resendToken = arguments['resendToken'] as int?;
    } else {
      phoneNumber = '+000 000 0000';
      verificationId = '';
      resendToken = null;
    }
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _resendCode() async {
    if (!_canResend) return;
    
    // Set only resending state to true
    ref.read(otpResendingProvider.notifier).state = true;
    
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        forceResendingToken: resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification happened, sign in immediately
          ref.read(otpResendingProvider.notifier).state = false;
          ref.read(otpVerifyingProvider.notifier).state = true;
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ref.read(otpResendingProvider.notifier).state = false;
          _showSnackBar('Resend failed: ${e.message}', isError: true);
        },
        codeSent: (String newVerificationId, int? newResendToken) {
          ref.read(otpResendingProvider.notifier).state = false;
          // Update with new verification ID and resend token
          setState(() {
            verificationId = newVerificationId;
            resendToken = newResendToken;
          });
          _showSnackBar('OTP code resent successfully!');
          _startResendTimer();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          ref.read(otpResendingProvider.notifier).state = false;
          // Handle timeout
        },
      );
    } catch (e) {
      ref.read(otpResendingProvider.notifier).state = false;
      _showSnackBar('Error resending code: ${e.toString()}', isError: true);
    }
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    // Auto-verify when all digits are entered
    final code = _otpControllers.map((c) => c.text).join();
    if (code.length == _otpLength) {
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    final code = _otpControllers.map((c) => c.text).join();
    if (code.length != _otpLength) {
      _showSnackBar('Please enter the full OTP code.', isError: true);
      return;
    }

    if (verificationId.isEmpty) {
      _showSnackBar('Verification ID is missing. Please try again.', isError: true);
      return;
    }

    // Set only verifying state to true
    ref.read(otpVerifyingProvider.notifier).state = true;

    try {
      // Create phone auth credential
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      await _signInWithCredential(credential);
    } catch (e) {
      ref.read(otpVerifyingProvider.notifier).state = false;
      _showSnackBar('Invalid OTP code. Please try again.', isError: true);
      
      // Clear the OTP fields
      for (final controller in _otpControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      await _createUserProfile(userCredential.user);
      
      if (mounted && userCredential.user != null) {
        _showSnackBar('Phone verified successfully!');
        Navigator.pushReplacementNamed(context, RouteNames.personalDetailsScreen, arguments: {
          'phoneNumber': phoneNumber,
          'uid': userCredential.user?.uid,
        });
      }
    } catch (e) {
      _showSnackBar('Sign-in failed: ${e.toString()}', isError: true);
    } finally {
      // Reset both loading states
      ref.read(otpVerifyingProvider.notifier).state = false;
      ref.read(otpResendingProvider.notifier).state = false;
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
          'isPhoneVerified': true,
        });
      } else {
        // Update existing user to mark phone as verified
        await userDoc.update({
          'uid': user.uid,
          'isPhoneVerified': true,
          'lastUpdated': FieldValue.serverTimestamp(),
          'isActive': true,
        });
      }
    } catch (e) {
      print('Error creating/updating user profile: $e');
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red[600] : Colors.green[600],
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: isError ? 4 : 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVerifying = ref.watch(otpVerifyingProvider);
    final isResending = ref.watch(otpResendingProvider);
    
    // Disable back button and inputs when either process is running
    final isAnyProcessRunning = isVerifying || isResending;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBE6),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button inside the container
                      IconButton(
                        onPressed: isAnyProcessRunning ? null : () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        padding: const EdgeInsets.all(10),
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(height: 15),
                      _buildTitleSection(),
                      const SizedBox(height: 30),
                      _buildOtpInputSection(isDisabled: isAnyProcessRunning),
                      const SizedBox(height: 30),
                      _buildResendSection(),
                      const SizedBox(height: 30),
                      _buildVerifyButton(),
                    ],
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
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter OTP Code sent to you!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Check your messages. We have sent a one-time verification code to $phoneNumber. Enter the code below to verify your account!',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        Image.asset(
          'assets/images/taxi_icon.png',
          width: 50,
          height: 50,
        ),
      ],
    );
  }

  Widget _buildOtpInputSection({required bool isDisabled}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_otpLength, (index) {
        return Container(
          width: 50,
          height: 60,
          decoration: BoxDecoration(
            color: isDisabled ? Colors.grey[100] : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _focusNodes[index],
            enabled: !isDisabled,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: isDisabled ? Colors.grey : Colors.black,
            ),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) => _onOtpChanged(value, index),
          ),
        );
      }),
    );
  }

  Widget _buildResendSection() {
    final isResending = ref.watch(otpResendingProvider);
    final isVerifying = ref.watch(otpVerifyingProvider);
    
    return Center(
      child: Column(
        children: [
          Text(
            _canResend
                ? 'You can resend the code now'
                : 'We can resend the code in $_resendTimer seconds.',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: (_canResend && !isResending && !isVerifying) ? _resendCode : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isResending) ...[
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  isResending ? 'Resending...' : 'Resend Code',
                  style: TextStyle(
                    fontSize: 16,
                    color: (_canResend && !isResending && !isVerifying) 
                        ? Colors.black 
                        : Colors.grey,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton() {
    final isVerifying = ref.watch(otpVerifyingProvider);
    final isResending = ref.watch(otpResendingProvider);
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (isVerifying || isResending) ? null : _verifyOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF2B200),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 0,
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isVerifying) ...[
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Text(isVerifying ? 'Verifying...' : 'Verify'),
            if (!isVerifying) ...[
              const SizedBox(width: 10),
              const Icon(Icons.arrow_forward),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0D3C34),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: const Column(
        children: [
          Text(
            'Continue with:',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialCircle(icon: FontAwesomeIcons.google),
              SizedBox(width: 20),
              _SocialCircle(icon: FontAwesomeIcons.facebookF),
              SizedBox(width: 20),
              _SocialCircle(icon: FontAwesomeIcons.xTwitter),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialCircle extends StatelessWidget {
  final IconData icon;
  const _SocialCircle({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: FaIcon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}