import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  String _selectedIdentifier = 'Phone Number';
  String _selectedCountryCode = '+250';
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  final Map<String, String> _countryCodes = {
    '+250': '🇷🇼', '+256': '🇺🇬', '+254': '🇰🇪',
    '+255': '🇹🇿', '+233': '🇬🇭', '+234': '🇳🇬',
    '+27': '🇿🇦', '+1': '🇺🇸', '+44': '🇬🇧',
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBE6),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleSection(),
                      const SizedBox(height: 20),
                      _buildIdentifierToggle(),
                      const SizedBox(height: 20),
                      _buildInputSection(),
                      const SizedBox(height: 15),
                      _buildRememberMe(),
                      const SizedBox(height: 30),
                      _buildActionButton(
                        text: 'Sign In',
                        color: const Color(0xFF0D3C34),
                        textColor: Colors.white,
                        isLoading: _isLoading,
                        onPressed: _isFormValid()
                            ? _handleLogin
                            : null,
                      ),
                      const SizedBox(height: 15),
                      _buildActionButton(
                        text: 'Sign Up',
                        color: const Color(0xFFF2B200),
                        textColor: Colors.black,
                        onPressed: () => Navigator.pushNamed(context, '/phone-input'),
                      ),
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

  Widget _buildHeader() => const SizedBox(height: 20);

  Widget _buildTitleSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Choose your identifier below to access your Tugende account!',
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
    );
  }

  Widget _buildIdentifierToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildToggleTab('Phone Number'),
          _buildToggleTab('Username/Mail'),
        ],
      ),
    );
  }

  Widget _buildToggleTab(String label) {
    final isSelected = _selectedIdentifier == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIdentifier = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0D3C34) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      crossFadeState: _selectedIdentifier == 'Phone Number'
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: _buildPhoneInput(),
      secondChild: Column(
        children: [
          _buildEmailInput(),
          const SizedBox(height: 15),
          _buildPasswordInput(),
        ],
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => _selectedCountryCode = value),
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
                  children: [Text(e.value), const SizedBox(width: 10), Text(e.key)],
                ),
              );
            }).toList(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _phoneController,
              focusNode: _phoneFocusNode,
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

  Widget _buildEmailInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.email),
        ],
      ),
    );
  }

  Widget _buildPasswordInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[600],
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ],
      ),
    );
  }

  Widget _buildRememberMe() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (val) => setState(() => _rememberMe = val ?? false),
          activeColor: const Color(0xFF0D3C34),
        ),
        const Text('Remember me'),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: isLoading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Row(
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

  bool _isFormValid() {
    if (_selectedIdentifier == 'Phone Number') {
      return _phoneController.text.isNotEmpty;
    } else {
      return _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    }
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    // Show dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.home, color: Color(0xFF0D3C34), size: 28),
            SizedBox(width: 10),
            Text('Coming Soon!', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D3C34))),
          ],
        ),
        content: const Text(
          'The home page is currently under development. We\'re working hard to bring you the best experience!',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFF0D3C34), fontWeight: FontWeight.bold)),
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
      child: Center(child: FaIcon(icon, color: Colors.white, size: 20)),
    );
  }
}
