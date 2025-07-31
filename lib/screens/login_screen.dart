import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tugende/config/routes_config.dart';
import 'package:tugende/dto/user_doc_dto.dart';
import 'package:tugende/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
   final  TextEditingController _otpController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  String _selectedIdentifier = 'Phone Number';
  String _selectedCountryCode = '+250';
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _verificationId;

  // Country codes mapping with flags
  final Map<String, String> _countryCodes = {
    '+250': '🇷🇼',
    '+256': '🇺🇬',
    '+254': '🇰🇪',
    '+255': '🇹🇿',
    '+233': '🇬🇭',
    '+234': '🇳🇬',
    '+27': '🇿🇦',
    '+1': '🇺🇸',
    '+44': '🇬🇧',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _otpController.dispose();
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
                            ? ()=> _handleLogin()
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

  /// Builds the header section of the login screen
  Widget _buildHeader() => const SizedBox(height: 20);

  /// Builds the title section with welcome message and taxi icon
  Widget _buildTitleSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
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
        // Taxi icon asset
        Image.asset('assets/images/taxi_icon.png', width: 50, height: 50),
      ],
    );
  }

  /// Builds the toggle switch for selecting identifier type
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

  /// Builds individual toggle tab
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

  /// Builds the input section with animated transition
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

  /// Builds phone number input with country code selector
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

  /// Builds email input field
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

  /// Builds password input field with visibility toggle
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

  /// Builds remember me checkbox
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

  /// Builds action buttons (Sign In/Sign Up)
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
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
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

  /// Builds the footer section with social login options
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
        children: [
          const Text(
            'Continue with:',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _handleGoogleSignIn,
                child: const Opacity(
                  opacity: 1,
                  child: _SocialCircle(icon: FontAwesomeIcons.google),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Validates form inputs based on selected identifier
  bool _isFormValid() {
    if (_selectedIdentifier == 'Phone Number') {
      return _phoneController.text.isNotEmpty;
    } else {
      return _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    }
  }

  /// Handles login process for both phone and email authentication
  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      final auth = ref.read(firebaseAuthProvider);

      if (_selectedIdentifier == 'Phone Number') {
   
        await _handlePhoneLogin();
      } else {
        // Email/Password login
        final credential = await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
         print(credential);
        if (credential.user != null) {
          _showSuccessDialog('Login Successful', 'Welcome back!');
          // Navigate to home screen
          // Ensure you have a route named '/home' defined in your MaterialApp
         
        }
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(_getAuthErrorMessage(e.code));
    } catch (e) {
      _showErrorDialog('An unexpected error occurred. Please try again.');
      print('Login Error: $e'); // Debug logging
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Handles phone number authentication
  Future<void> _handlePhoneLogin() async {
    final auth = ref.read(firebaseAuthProvider);
    final phoneNumber = '$_selectedCountryCode${_phoneController.text.trim()}';

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-verification (Android only)
        final userCredential = await auth.signInWithCredential(credential);
       
        if (userCredential.user != null) {
          final userDoc = FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid);
          final docSnapshot = await userDoc.get();

          if (mounted && docSnapshot.exists) {
            final user = UserDocDto.fromJson(docSnapshot.data()!);
            ref.read(userStateProvider.notifier).signInUser(user);
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteNames.homeScreen,
              (route) => false,
            );
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User not found. Please sign up first.')),
              );
            }
          }
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print("it faillleddd");
        _showErrorDialog(_getAuthErrorMessage(e.code));
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _showOTPDialog();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  /// Handles Google Sign-In authentication
  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final googleSignIn = ref.read(googleSignInProvider);
      final auth = ref.read(firebaseAuthProvider);

      // Authenticate with Google
      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

      if (googleUser == null) {
        // User cancelled the sign-in process
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google sign-in was cancelled.')),
          );
        }
        return;
      }

      // Get authentication details from the signed-in Google user
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a Firebase credential using the Google ID token and access token
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.idToken,
        idToken: googleAuth.idToken,
      );

      // Sign-in to Firebase with the Google credential
      final userCredential = await auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userCredential.user!.email);
        final docSnapshot = await userDoc.get();

        if (mounted && docSnapshot.docs.isNotEmpty) {
          final user = UserDocDto.fromJson(docSnapshot.docs.first.data());
          ref.read(userStateProvider.notifier).signInUser(user);
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.homeScreen,
            (route) => false,
          );
        }
      }
    } catch (e) {
      _showErrorDialog('Google sign-in failed. Please try again.');
      print('Google Sign-In Error: $e'); // Debug logging
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Shows OTP verification dialog
  void _showOTPDialog() {
   
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Enter OTP', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter the verification code sent to $_selectedCountryCode${_phoneController.text}'),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                hintText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
           
             onPressed: () => _verifyOTP(_otpController.text, context),
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

Future<void> _verifyOTP(String otp, BuildContext dialogContext) async {
  try {
    final auth = ref.read(firebaseAuthProvider);

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );
    print("cred $credential");

    final userCredential = await auth.signInWithCredential(credential);

    if (userCredential.user != null) {
      _showSuccessDialog('Login Successful', 'Phone verified successfully!');
      // You can also navigate to home or another screen here
      // Navigator.pushReplacementNamed(context, '/home');
    }
  } on FirebaseAuthException catch (e) {
    _showErrorDialog(_getAuthErrorMessage(e.code));
  } catch (e) {
    _showErrorDialog('An unexpected error occurred during OTP verification. Please try again.');
  }
}


  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF0D3C34), size: 28),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D3C34))),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFF0D3C34), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text('Error', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  /// Returns user-friendly error messages for Firebase Auth errors
  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-phone-number':
        return 'Please enter a valid phone number.';
      case 'invalid-verification-code':
        return 'Invalid verification code. Please try again.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email address but different sign-in credentials. Please sign in using your existing method.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}

/// Social media login button widget
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