import 'package:flutter/material.dart';
import 'package:tugende/screens/tabs/promo_vouchers.dart';
import 'promo_vouchers.dart';

class AvailableRidesScreen extends StatefulWidget {
  final String fromLocation;
  final String toLocation;
  final String date;
  final int passengers;

  const AvailableRidesScreen({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.date,
    required this.passengers,
  });

  @override
  State<AvailableRidesScreen> createState() => _AvailableRidesScreenState();
}

class _AvailableRidesScreenState extends State<AvailableRidesScreen> {
  // Mock drivers data
  final List<Driver> _availableDrivers = [
    Driver(
      name: "Steve Karasira",
      rating: 4.7,
      reviewCount: 123,
      isVerified: true,
      car: Car(
        model: "Range Rover",
        plateNumber: "CCG-785",
        color: "Black",
        image: "https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=400",
      ),
      profileImage: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
      availableSeats: 1,
      price: 3000,
    ),
    Driver(
      name: "Uwimana Clarisse",
      rating: 4.7,
      reviewCount: 123,
      isVerified: true,
      car: Car(
        model: "Range Rover",
        plateNumber: "CCG-785",
        color: "Black",
        image: "https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=400",
      ),
      profileImage: "https://images.unsplash.com/photo-1494790108755-2616b67b2d4c?w=100",
      availableSeats: 2,
      price: 3000,
    ),
    Driver(
      name: "Jean Baptiste",
      rating: 4.8,
      reviewCount: 89,
      isVerified: true,
      car: Car(
        model: "Toyota Prado",
        plateNumber: "RAD-456",
        color: "White",
        image: "https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=400",
      ),
      profileImage: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100",
      availableSeats: 3,
      price: 2500,
    ),
  ];

  void _selectRide(Driver driver) {
    // Navigate to promo/vouchers screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PromosVouchersScreen(
          fromLocation: widget.fromLocation,
          toLocation: widget.toLocation,
          driverName: driver.name,
          price: driver.price,
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
                      'Rides',
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
            // Trip Info Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // From location
                  Row(
                    children: [
                      const Icon(
                        Icons.radio_button_checked,
                        color: Color(0xFF2F5D5A),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.fromLocation,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // To location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFFE5B429),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.toLocation,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Trip details row
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        widget.date,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.passengers} Passengers',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5B429),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            // Available Rides List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _availableDrivers.length,
                itemBuilder: (context, index) {
                  final driver = _availableDrivers[index];
                  return _buildDriverCard(driver);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard(Driver driver) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Driver Info Row
          Row(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(driver.profileImage),
              ),
              const SizedBox(width: 12),
              // Driver Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          driver.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        if (driver.isVerified) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified,
                            color: Color(0xFF2F5D5A),
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Verified Account',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFE5B429),
                        size: 16,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        driver.rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '(${driver.reviewCount}) reviews',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Car Info Row
          Row(
            children: [
              // Car Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  driver.car.image,
                  width: 60,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              // Car Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.car.model,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${driver.car.plateNumber} • ${driver.car.color}',
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
          const SizedBox(height: 16),
          // Location and Price Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Locations
              Expanded(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2F5D5A),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.fromLocation,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const Text(
                                'KK 154 ST, Kigali, Rwanda',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Dotted line
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      child: Column(
                        children: List.generate(4, (index) => Container(
                          margin: const EdgeInsets.only(bottom: 1),
                          width: 1,
                          height: 3,
                          color: Colors.grey.shade500,
                        )),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE5B429),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.toLocation,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const Text(
                                'KK 154 ST, Kigali, Rwanda',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Seat availability and price row
          Row(
            children: [
              const Icon(
                Icons.phone,
                color: Color(0xFFE5B429),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                '${driver.availableSeats} seat(s) available',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFE5B429),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F5D5A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${driver.price.toStringAsFixed(0)} RWF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Book Now Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _selectRide(driver),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F5D5A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Book Now',
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
    );
  }
}

// Data Models
class Driver {
  final String name;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final Car car;
  final String profileImage;
  final int availableSeats;
  final double price;

  Driver({
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    required this.car,
    required this.profileImage,
    required this.availableSeats,
    required this.price,
  });
}

class Car {
  final String model;
  final String plateNumber;
  final String color;
  final String image;

  Car({
    required this.model,
    required this.plateNumber,
    required this.color,
    required this.image,
  });
}