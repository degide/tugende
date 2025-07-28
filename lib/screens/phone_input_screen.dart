import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+250'; // Default: Rwanda
  bool _agreedToTerms = false;

  final Map<String, String> _countryCodes = {
    '+250': '🇷🇼', '+256': '🇺🇬', '+254': '🇰🇪',
    '+255': '🇹🇿', '+233': '🇬🇭', '+234': '🇳🇬',
    '+27': '🇿🇦', '+1': '🇺🇸', '+44': '🇬🇧',
  };

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

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
                          text: 'Start ride-sharing',
                          color: const Color(0xFF0D3C34),
                          onPressed: _agreedToTerms && _phoneController.text.isNotEmpty
                              ? () => Navigator.pushNamed(context, '/otp-verification')
                              : null,
                        ),
                        const SizedBox(height: 15),
                        _buildActionButton(
                          text: 'Continue to Login',
                          color: const Color(0xFFF2B200),
                          textColor: Colors.black,
                          onPressed: () => Navigator.pushNamed(context, '/login'),
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

  Widget _buildHeader(BuildContext context) {
    return Container(); // Empty container since we'll move the back button
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
            padding: EdgeInsets.all(10),
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
                  Text(
                    'Join TugendeApp!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
