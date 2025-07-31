import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tugende/config/routes_config.dart';
import 'package:tugende/providers/auth_provider.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _NavItem {
  final String title;
  final IconData leading;
  final Widget trailing;
  final VoidCallback? onTap;

  _NavItem({
    required this.title,
    required this.leading,
    required this.trailing,
    this.onTap,
  });
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userStateProvider);

    final List<_NavItem> navItems = [
      _NavItem(
        title: 'User Profile',
        leading: Icons.person_outline,
        trailing: const Icon(Icons.chevron_right_outlined),
        onTap: () {
          Navigator.pushNamed(context, RouteNames.editProfileScreen);
        },
      ),
      _NavItem(
        title: 'Change Password',
        leading: Icons.password_outlined,
        trailing: const Icon(Icons.chevron_right_outlined),
        onTap: _showChangePasswordDialog,
      ),
      _NavItem(
        title: 'Setup Biometrics',
        leading: Icons.fit_screen_outlined,
        trailing: const Icon(Icons.chevron_right_outlined),
        onTap: () {},
      ),
      _NavItem(
        title: 'FAQs',
        leading: Icons.help_outline_rounded,
        trailing: const Icon(Icons.chevron_right_outlined),
        onTap: () {
          Navigator.pushNamed(context, RouteNames.faqScreen);
        },
      ),
      _NavItem(
        title: 'Push Notifications',
        leading: Icons.notifications_on_outlined,
        //toggle switch trailing
        trailing: Switch(value: true, onChanged: (value) {}),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(color: Colors.grey[300]!, width: 1.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          CircleAvatar(
                            radius: 30.0,
                            backgroundImage: AssetImage(
                              'assets/images/avatar.png',
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  userState.user?.fullName ??
                                      userState.user?.email ??
                                      '',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout),
                            onPressed: () => _showLogoutDialog(ref),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Divider(height: 1.0, color: Colors.grey[300]),
                      const SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'If you have any other query you can reach out to our support team.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.black87),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15.0),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 12.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.chat, size: 18.0),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    'Message us on Whatsapp',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                ...navItems.map((navItem) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: ListTile(
                          leading: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: Icon(
                              navItem.leading,
                              size: 24.0,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            navItem.title,
                            style: TextStyle(fontSize: 15.0),
                          ),
                          trailing: navItem.trailing,
                          onTap: navItem.onTap,
                        ),
                      ),
                      navItem != navItems.last
                          ? Divider(height: 1.0, color: Colors.grey[300])
                          : SizedBox.shrink(),
                    ],
                  );
                }),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _logout(WidgetRef ref, BuildContext dialogContext) {
    Navigator.of(dialogContext).pop();
    try {
      FirebaseAuth.instance.signOut();
      GoogleSignIn.instance.signOut();
      // ignore: empty_catches
    } catch (e) {}
    ref.read(userStateProvider.notifier).signOutUser();
    Navigator.pushReplacementNamed(context, RouteNames.loginScreen);
  }

  Future<void> _updatePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      //update password logic here using FirebaseAuth signInWithEmailAndPassword
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          if (kDebugMode) {
            print('No user is currently signed in.');
          }
          return;
        }
        //reauthenticate the user if necessary
        await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: ref.read(userStateProvider).user?.email ?? '',
            password: _currentPasswordController.text.trim(),
          ),
        );
        await user.updatePassword(_newPasswordController.text.trim());
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        _currentPasswordController.clear();
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully')),
          );
          Navigator.of(context).pop(); // Close the dialog
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error updating password: $e');
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update password. Check your current password and try again.')),
          );
        }
      }
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        //password input and confirm password input, save changes and cancel changes buttons
        return AlertDialog(
          title: const Text('Change Password'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Current Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _newPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'New Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Are you sure you want to logout?',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: const Text('No, Stay Logged In'),
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _logout(ref, context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: const Text('Confirm Logout'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
