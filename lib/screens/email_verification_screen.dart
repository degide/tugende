import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends ConsumerState<EmailVerificationScreen> {
  final int _otpLength = 4;
  final List<TextEditingController> _otpControllers = [];
  final List<FocusNode> _focusNodes = [];
  bool _canResend = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeOtpControllers();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _initializeOtpControllers() {
    for (int i = 0; i < _otpLength; i++) {
      _otpControllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
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

  void _resendCode() {
    if (_canResend) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification code resent!')),
      );
      _startResendTimer();
      // TODO: Trigger actual resend logic
    }
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _verifyEmail() {
    final code = _otpControllers.map((c) => c.text).join();
    if (code.length != _otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full verification code.')),
      );
      return;
    }

    // TODO: Implement actual email verification logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email verified successfully!')),
    );

    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
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
                          padding: EdgeInsets.all(10),
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(height: 15),
                        
                        _buildTitleSection(),
                        const SizedBox(height: 30),
                        
                        _buildOtpInputSection(),
                        const SizedBox(height: 30),
                        
                        _buildResendSection(),
                        const SizedBox(height: 30),
                        
                        _buildActionButton(),
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
            children: const [
              Text(
                'Enter Email Verification Code!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Check your email. We\'ve sent a verification code to your email address. Enter the code below to verify your account!',
                style: TextStyle(fontSize: 14, color: Colors.grey),
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

  Widget _buildOtpInputSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_otpLength, (index) {
        return Container(
          width: 60,
          height: 60,
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
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
            onTap: _canResend ? _resendCode : null,
            child: Text(
              'Resend Code',
              style: TextStyle(
                fontSize: 16,
                color: _canResend ? Colors.black : Colors.grey,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _verifyEmail,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF2B200),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Verify'),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward),
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