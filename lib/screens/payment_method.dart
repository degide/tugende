import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tugende/config/routes_config.dart';
import 'package:tugende/providers/auth_provider.dart';
import 'package:tugende/providers/bookings_provider.dart';

class PaymentMethodScreen extends ConsumerStatefulWidget {
  final String fromLocation;
  final String toLocation;
  final String driverName;
  final String driverProfileImage;
  final double price;
  final String? appliedPromo;

  const PaymentMethodScreen({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.driverName,
    required this.driverProfileImage,
    required this.price,
    this.appliedPromo,
  });

  @override
  ConsumerState<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  String? _selectedPaymentMethod;

  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      name: "Use VISA Card",
      description: "Cards work seamlessly",
      icon: Icons.credit_card,
      isSelected: true,
    ),
    PaymentMethod(
      name: "Cash",
      description: "Pay drivers directly",
      icon: Icons.money,
      isSelected: false,
    ),
    PaymentMethod(
      name: "MTN Momo",
      description: "We didn't forget MTN",
      icon: Icons.phone_android,
      isSelected: false,
    ),
    PaymentMethod(
      name: "Airtel Pay",
      description: "Airtel is also available",
      icon: Icons.phone_android,
      isSelected: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = "Use VISA Card";
  }

  void _selectPaymentMethod(PaymentMethod method) {
    setState(() {
      _selectedPaymentMethod = method.name;
      // Update selection state
      for (var paymentMethod in _paymentMethods) {
        paymentMethod.isSelected = paymentMethod.name == method.name;
      }
    });
  }

  void _confirmPayment() async {
    try {
      // Save booking to Firebase Firestore
      await _saveBookingToFirestore();

      // Show booking confirmation modal
      _showBookingConfirmationModal();
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating booking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveBookingToFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = ref.read(userStateProvider).user;

    final bookingData = {
      'userId': user?.uid,
      'driverName': widget.driverName,
      'driverPictureUrl': widget.driverProfileImage,
      'fromLocation': widget.fromLocation,
      'toLocation': widget.toLocation,
      'price': widget.price,
      'paymentMethod': _selectedPaymentMethod,
      'appliedPromo': widget.appliedPromo,
      'bookingDate': FieldValue.serverTimestamp(),
      'status': 'requested', // pending, confirmed, completed, cancelled
    };

    await firestore.collection('bookings').add(bookingData);
    ref.invalidate(bookingsProvider(''));
  }

  void _showBookingConfirmationModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF2F5D5A),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              // Title
              const Text(
                'Booking Requested!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              // Description
              const Text(
                'We\'ve received your ride request! We\'ll let you know once your driver accepts.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              // View My Rides Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.pushNamed(context, RouteNames.homeScreen); // Go to home screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5B429),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'View My Rides',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                  ),
                  const Expanded(
                    child: Text(
                      'Choose Payment Method',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the back button
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Payment Methods List
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: _paymentMethods.map((method) {
                          return _buildPaymentMethodCard(method);
                        }).toList(),
                      ),
                    ),
                    const Spacer(),
                    // Confirm Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _confirmPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F5D5A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod method) {
    return GestureDetector(
      onTap: () => _selectPaymentMethod(method),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: method.isSelected ? const Color(0xFFE5B429) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2F5D5A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                method.icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    method.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (method.isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFE5B429),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}


class PaymentMethod {
  final String name;
  final String description;
  final IconData icon;
  bool isSelected;

  PaymentMethod({
    required this.name,
    required this.description,
    required this.icon,
    required this.isSelected,
  });
}