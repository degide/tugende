import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:tugende/config/routes_config.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends ConsumerState<EmailVerificationScreen> {
  bool isEmailVerified = false;
  bool _canResend = false;
  int _resendTimer = 60;
  Timer? _timer;
  Timer? _checkTimer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Check if email is already verified
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    
    if (!isEmailVerified) {
      _startResendTimer();
      
      // Start checking for email verification every 3 seconds
      _checkTimer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => _checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _checkTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = 60;
      _canResend = false;
    });
    
    _timer?.cancel();
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

  Future<void> _checkEmailVerified() async {
    // Reload user to get latest email verification status
    await FirebaseAuth.instance.currentUser?.reload();
    
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });

    if (isEmailVerified) {
      _checkTimer?.cancel();
      _timer?.cancel();
      
      _showSuccessSnackBar('Email verified successfully! Redirecting to login...');
      
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            RouteNames.loginScreen,
            (route) => false,
          );
        }
      });
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (!_canResend) return;
    
    setState(() => _isLoading = true);
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        _showSuccessSnackBar('Verification email sent! Check your inbox.');
        _startResendTimer();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to send verification email: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
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
                        // Back button
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(height: 15),
                        
                        _buildTitleSection(),
                        const SizedBox(height: 30),
                        
                        if (!isEmailVerified) ...[
                          _buildEmailInfoSection(user?.email ?? ''),
                          const SizedBox(height: 30),
                          
                          _buildInstructionSection(),
                          const SizedBox(height: 30),
                          
                          _buildResendSection(),
                          const SizedBox(height: 20),
                          
                          _buildManualCheckButton(),
                          const SizedBox(height: 20),
                          
                          _buildSignOutButton(),
                        ] else ...[
                          _buildSuccessSection(),
                          const SizedBox(height: 30),
                          
                          _buildContinueButton(),
                        ],
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
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEmailVerified ? 'Email Verified!' : 'Verify Your Email',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                isEmailVerified 
                    ? 'Your email has been successfully verified!'
                    : 'We\'ve sent a verification link to your email address.',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isEmailVerified ? Colors.green.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            isEmailVerified ? Icons.check_circle : Icons.email,
            size: 30,
            color: isEmailVerified ? Colors.green : const Color(0xFF0D3C34),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailInfoSection(String email) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.email, color: Color(0xFF0D3C34)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              email,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'How to verify:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '1. Check your email inbox (and spam folder)\n'
            '2. Look for an email from Firebase\n'
            '3. Click the "Verify Email" button in the email\n'
            '4. Return to this app - we\'ll detect the verification automatically',
            style: TextStyle(fontSize: 14, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: const [
          Icon(Icons.check_circle, color: Colors.green, size: 50),
          SizedBox(height: 10),
          Text(
            'Email Successfully Verified!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'You can now sign in to your account.',
            style: TextStyle(fontSize: 14, color: Colors.green),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResendSection() {
    return Center(
      child: Column(
        children: [
          Text(
            _canResend
                ? 'Didn\'t receive the email? You can resend it now.'
                : 'You can resend the verification email in $_resendTimer seconds.',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _canResend ? _resendVerificationEmail : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: _canResend ? const Color(0xFF0D3C34).withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Resend Email',
                      style: TextStyle(
                        fontSize: 16,
                        color: _canResend ? const Color(0xFF0D3C34) : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualCheckButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _checkEmailVerified,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF0D3C34),
          side: const BorderSide(color: Color(0xFF0D3C34)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('I\'ve Verified My Email'),
            SizedBox(width: 10),
            Icon(Icons.refresh),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF2B200),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Continue to Sign In'),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Center(
      child: TextButton(
        onPressed: _signOut,
        child: Text(
          'Sign out and try again',
          style: TextStyle(
            color: Colors.grey[600],
            decoration: TextDecoration.underline,
          ),
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
      child: Column(
        children: const [
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