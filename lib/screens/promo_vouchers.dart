import 'package:flutter/material.dart';
import 'package:tugende/screens/payment_method.dart';

// Promos / Vouchers Screen
class PromosVouchersScreen extends StatefulWidget {
  final String fromLocation;
  final String toLocation;
  final String driverName;
  final String driverProfileImage;
  final double price;

  const PromosVouchersScreen({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.driverName,
    required this.driverProfileImage,
    required this.price,
  });

  @override
  State<PromosVouchersScreen> createState() => _PromosVouchersScreenState();
}

class _PromosVouchersScreenState extends State<PromosVouchersScreen> {
  final TextEditingController _promoController = TextEditingController();
  String? _selectedPromo;

  // Mock promo codes
  final List<PromoCode> _promoCodes = [
    PromoCode(
      title: "10% OFF & 10% Cashback",
      description: "10CFG • Min spend 1500 RWF • Valid till 12/05/2025",
      isHighlighted: true,
    ),
    PromoCode(
      title: "10% OFF & 10% Cashback",
      description: "10CFG • Min spend 1500 RWF • Valid till 12/05/2025",
      isHighlighted: false,
    ),
    PromoCode(
      title: "10% OFF & 10% Cashback",
      description: "10CFG • Min spend 1500 RWF • Valid till 12/05/2025",
      isHighlighted: false,
    ),
    PromoCode(
      title: "10% OFF & 10% Cashback",
      description: "10CFG • Min spend 1500 RWF • Valid till 12/05/2025",
      isHighlighted: false,
    ),
    PromoCode(
      title: "10% OFF & 10% Cashback",
      description: "10CFG • Min spend 1500 RWF • Valid till 12/05/2025",
      isHighlighted: false,
    ),
  ];

  void _applyPromoCode() {
    if (_selectedPromo != null || _promoController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentMethodScreen(
            fromLocation: widget.fromLocation,
            toLocation: widget.toLocation,
            driverName: widget.driverName,
            driverProfileImage: widget.driverProfileImage,
            price: widget.price,
            appliedPromo: _selectedPromo ?? _promoController.text,
          ),
        ),
      );
    }
  }

  void _selectPromo(PromoCode promo) {
    setState(() {
      _selectedPromo = promo.title;
    });
    _applyPromoCode();
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
                      'Promos / Vouchers',
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
                    // Main Container with all content
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Promo Code Entry Section
                            const Text(
                              'Have a Promo Code?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: TextField(
                                      controller: _promoController,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter code here',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _applyPromoCode,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE5B429),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                    ),
                                    child: const Text(
                                      'Redeem',
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
                            const SizedBox(height: 24),
                            // Available Promos List
                            Expanded(
                              child: ListView.builder(
                                itemCount: _promoCodes.length,
                                itemBuilder: (context, index) {
                                  final promo = _promoCodes[index];
                                  return _buildPromoCard(promo, index);
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Apply Code Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _applyPromoCode,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2F5D5A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Apply Code',
                                  style: TextStyle(
                                    fontSize: 18,
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

  Widget _buildPromoCard(PromoCode promo, int index) {
    return GestureDetector(
      onTap: () => _selectPromo(promo),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: promo.isHighlighted ? const Color(0xFFE5B429) : Colors.transparent,
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
              child: const Icon(
                Icons.local_offer,
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
                    promo.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: promo.isHighlighted ? const Color(0xFFE5B429) : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    promo.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }
}

class PromoCode {
  final String title;
  final String description;
  final bool isHighlighted;

  PromoCode({
    required this.title,
    required this.description,
    required this.isHighlighted,
  });
}