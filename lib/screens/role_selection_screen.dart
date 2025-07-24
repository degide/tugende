import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  String? _selectedRole;

  final List<String> _roles = [
    'Share my ride',
    'I need a ride!',
  ];

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _next() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role')),
      );
      return;
    }

    // TODO: Save role selection to user preferences
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Role selected: $_selectedRole')),
    );

    // Show home page coming soon alert
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.home,
                color: const Color(0xFF0D3C34),
                size: 28,
              ),
              const SizedBox(width: 10),
              const Text(
                'Coming Soon!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D3C34),
                ),
              ),
            ],
          ),
          content: const Text(
            'The home page is currently under development. We\'re working hard to bring you the best experience!',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF0D3C34),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
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
                        
                        _buildRoleSelection(),
                        const SizedBox(height: 40),
                        
                        _buildActionButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
                'What\'s your role?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Choose what you want to be on this app for the experience to be seamless!',
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

  Widget _buildRoleSelection() {
    return Column(
      children: _roles.map((role) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: GestureDetector(
            onTap: () => _selectRole(role),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _selectedRole == role 
                      ? const Color(0xFF0D3C34) 
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Radio<String>(
                    value: role,
                    groupValue: _selectedRole,
                    onChanged: (value) => _selectRole(value!),
                    activeColor: const Color(0xFF0D3C34),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: _selectedRole == role 
                          ? FontWeight.w600 
                          : FontWeight.normal,
                      color: _selectedRole == role 
                          ? const Color(0xFF0D3C34) 
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _next,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D3C34),
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
            const Text('Next'),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
} 