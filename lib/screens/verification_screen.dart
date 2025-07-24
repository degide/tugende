import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // light background
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 30),

                // Welcome texts and car icon
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBE6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Welcome!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Let's get started!",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/images/taxi_icon.png',
                            width: 50,
                            height: 50,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Social Login Buttons
                      _buildSocialButton('Continue with Google', FontAwesomeIcons.google, Color(0xFF0D3C34)),
                      const SizedBox(height: 12),
                      _buildSocialButton('Continue with Facebook', FontAwesomeIcons.facebookF, Color(0xFF0D3C34)),
                      const SizedBox(height: 12),
                      _buildSocialButton('Continue with X(twitter)', FontAwesomeIcons.xTwitter, Color(0xFF0D3C34)),
                      const SizedBox(height: 12),
                      _buildSocialButton('Continue with Apple', FontAwesomeIcons.apple, Colors.black),

                      const SizedBox(height: 30),

                      // Sign Up Button
                      _buildActionButton(
                        text: "Sign Up",
                        color: const Color(0xFF0D3C34),
                        onPressed: () => Navigator.pushNamed(context, '/phone-input'),
                      ),
                      const SizedBox(height: 20),

                      // Sign In Button
                      _buildActionButton(
                        text: "Sign In",
                        color: const Color(0xFFF2B200),
                        textColor: Colors.black,
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, IconData icon, Color iconColor, {bool fill = false}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      child: Row(
        children: [
          FaIcon(icon, color: iconColor),
          const SizedBox(width: 20),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback onPressed,
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
}
