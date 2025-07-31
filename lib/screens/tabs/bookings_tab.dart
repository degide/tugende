import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tugende/screens/tabs/ride_booking.dart';

class BookingsTab extends StatefulWidget {
  const BookingsTab({super.key});

  @override
  State<BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends State<BookingsTab> {
  late GoogleMapController _controller;
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  bool _isLocationEnabled = false;
  bool _isSearchExpanded = false;
  bool _isSearching = false;
  bool _isLoadingLocation = false;

  List<PlaceResult> _searchResults = [];
  String? _selectedFromLocation;
  String? _selectedToLocation;
  LatLng? _currentLocation;

  // Set this to true for development to skip permission flow
  static const bool _skipPermissionForDev = true;

  // Mock location data for development (no API key needed)
  final List<PlaceResult> _mockPlaces = [
    PlaceResult(
      name: "Nyamirambo Women's Center",
      address: "KK 154 ST, Kigali, Rwanda",
      geometry: PlaceGeometry(location: PlaceLocation(lat: -1.9706, lng: 30.1044)),
    ),
    PlaceResult(
      name: "Biryongo, Car Freezone",
      address: "KK 154 ST, Kigali, Rwanda",
      geometry: PlaceGeometry(location: PlaceLocation(lat: -1.9650, lng: 30.1100)),
    ),
    PlaceResult(
      name: "Kacyiru, Subaru",
      address: "KK 154 ST, Kigali, Rwanda",
      geometry: PlaceGeometry(location: PlaceLocation(lat: -1.9500, lng: 30.1200)),
    ),
    PlaceResult(
      name: "Kigali Convention Centre",
      address: "KG 2 Roundabout, Kigali, Rwanda",
      geometry: PlaceGeometry(location: PlaceLocation(lat: -1.9441, lng: 30.0619)),
    ),
    PlaceResult(
      name: "Kigali International Airport",
      address: "Airport Road, Kigali, Rwanda",
      geometry: PlaceGeometry(location: PlaceLocation(lat: -1.9686, lng: 30.1395)),
    ),
    PlaceResult(
      name: "University of Rwanda",
      address: "Huye, Southern Province, Rwanda",
      geometry: PlaceGeometry(location: PlaceLocation(lat: -2.6103, lng: 29.7397)),
    ),
    PlaceResult(
      name: "Lake Kivu",
      address: "Western Province, Rwanda",
      geometry: PlaceGeometry(location: PlaceLocation(lat: -2.3414, lng: 29.1267)),
    ),
    PlaceResult(
      name: "Volcanoes National Park",
      address: "Musanze, Northern Province, Rwanda",
      geometry: PlaceGeometry(location: PlaceLocation(lat: -1.4671, lng: 29.5236)),
    ),
    PlaceResult(
      name: "Kimisagara Market",
      address: "Nyarugenge, Kigali, Rwanda",
      geometry: PlaceGeometry(location: PlaceLocation(lat: -1.9536, lng: 30.0588)),
    ),
    PlaceResult(
      name: "Remera Taxi Park",
      address: "Gasabo, Kigali, Rwanda",
      geometry: PlaceGeometry(location: PlaceLocation(lat: -1.9355, lng: 30.1086)),
    ),
  ];

  static const CameraPosition _kKigali = CameraPosition(
    target: LatLng(-1.9706, 30.1044),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    // For development, skip permission check
    if (_skipPermissionForDev) {
      setState(() {
        _isLocationEnabled = true;
      });
      _getCurrentLocationForDev();
      return;
    }

    // Check permission status using permission_handler
    PermissionStatus permission = await Permission.location.status;

    if (permission.isGranted) {
      setState(() {
        _isLocationEnabled = true;
      });
      _getCurrentLocation();
    }
    // Don't request automatically, let user click the button
  }

  Future<void> _getCurrentLocationForDev() async {
    // Use Kigali coordinates for development
    setState(() {
      _currentLocation = const LatLng(-1.9706, 30.1044);
      _fromController.text = "Kigali, Rwanda";
      _selectedFromLocation = "Kigali, Rwanda";
    });

    _controller.animateCamera(
      CameraUpdate.newLatLng(_currentLocation!),
    );
  }

  Future<void> _requestLocationPermission() async {
    // For development, just enable location
    if (_skipPermissionForDev) {
      setState(() {
        _isLocationEnabled = true;
      });
      _getCurrentLocationForDev();
      return;
    }

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Request permission using permission_handler
      PermissionStatus permission = await Permission.location.request();

      if (permission.isGranted) {
        setState(() {
          _isLocationEnabled = true;
          _isLoadingLocation = false;
        });
        await _getCurrentLocation();
      } else if (permission.isDenied) {
        _showSnackBar('Location permission denied');
        setState(() {
          _isLoadingLocation = false;
        });
      } else if (permission.isPermanentlyDenied) {
        _showSnackBar('Location permission permanently denied. Please enable in settings.');
        // Optionally open app settings
        await openAppSettings();
        setState(() {
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      _showSnackBar('Error requesting location permission: $e');
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      _controller.animateCamera(
        CameraUpdate.newLatLng(_currentLocation!),
      );

      // Get address from coordinates
      String address = await _getAddressFromCoordinates(position.latitude, position.longitude);
      setState(() {
        _fromController.text = address;
        _selectedFromLocation = address;
      });

    } catch (e) {
      _showSnackBar('Error getting current location: $e');
    }
  }

  Future<String> _getAddressFromCoordinates(double lat, double lng) async {
    // Mock address return for development
    return "Kigali, Rwanda";
  }

  void _onMaybeLater() {
    // Handle maybe later - could navigate to a different screen or show limited functionality
    _showSnackBar('Limited functionality without location access');
  }

  void _onSearchTap() {
    if (!_isLocationEnabled) {
      _showSnackBar('Please enable location first');
      return;
    }

    setState(() {
      _isSearchExpanded = true;
    });
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Filter mock places based on search query
      final List<PlaceResult> results = _mockPlaces
          .where((place) =>
      place.name.toLowerCase().contains(query.toLowerCase()) ||
          place.address.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      print('Search error: $e');
      setState(() {
        _isSearching = false;
      });
      _showSnackBar('Error searching places. Please try again.');
    }
  }

  void _selectLocation(PlaceResult place, bool isFromLocation) {
    setState(() {
      if (isFromLocation) {
        _fromController.text = place.name;
        _selectedFromLocation = place.name;
      } else {
        _toController.text = place.name;
        _selectedToLocation = place.name;
      }
      _searchResults = [];
    });

    // Move camera to selected location
    _controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(place.geometry.location.lat, place.geometry.location.lng),
      ),
    );

    // Navigate to booking screen when both locations are selected
    if (_selectedFromLocation != null && _selectedToLocation != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RideBookingScreen(
            fromLocation: _selectedFromLocation!,
            toLocation: _selectedToLocation!,
          ),
        ),
      );
    }
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF2F5D5A),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Map
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kKigali,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              myLocationEnabled: _isLocationEnabled,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),

            // Location Permission Overlay
            if (!_isLocationEnabled)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F5D5A),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Enable Location',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'To be able to use the service, we require\npermission to enable location.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoadingLocation ? null : _requestLocationPermission,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2F5D5A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoadingLocation
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              'Grant Permission',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoadingLocation ? null : _onMaybeLater,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE5B429),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Maybe Later',
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
              ),

            // Bottom Sheet - Only show when location is enabled
            if (_isLocationEnabled)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isSearchExpanded ?
                  MediaQuery.of(context).size.height * 0.7 : 200,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Handle bar
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      if (_isSearchExpanded) ...[
                        // Header with close button
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isSearchExpanded = false;
                                    _searchResults = [];
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 24,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Text(
                                  "Let's travel together",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Current location display
                        if (_selectedFromLocation != null)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedFromLocation!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 16),

                        // Search inputs
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              // From location
                              _buildLocationInput(
                                controller: _fromController,
                                icon: Icons.radio_button_checked,
                                iconColor: const Color(0xFF2F5D5A),
                                hint: 'From location',
                                isFromLocation: true,
                              ),
                              const SizedBox(height: 12),
                              // To location
                              _buildLocationInput(
                                controller: _toController,
                                icon: Icons.location_on,
                                iconColor: const Color(0xFFE5B429),
                                hint: 'To location',
                                isFromLocation: false,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Search results or loading
                        Expanded(
                          child: _isSearching
                              ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF2F5D5A),
                            ),
                          )
                              : _searchResults.isEmpty
                              ? const Center(
                            child: Text(
                              'Start typing to search for places',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          )
                              : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final place = _searchResults[index];
                              return _buildLocationSuggestion(place);
                            },
                          ),
                        ),
                      ] else ...[
                        // Collapsed state
                        const SizedBox(height: 25),
                        const Text(
                          "Let's travel together",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: GestureDetector(
                            onTap: _onSearchTap,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _selectedFromLocation ?? 'Enter location',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _selectedFromLocation != null
                                            ? Colors.black
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInput({
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
    required String hint,
    required bool isFromLocation,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                _searchPlaces(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSuggestion(PlaceResult place) {
    return GestureDetector(
      onTap: () {
        // Determine which field is currently being edited
        bool isFromLocation = _fromController.text.isNotEmpty;
        _selectLocation(place, !isFromLocation);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    place.address,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceResult {
  final String name;
  final String address;
  final PlaceGeometry geometry;

  PlaceResult({
    required this.name,
    required this.address,
    required this.geometry,
  });
}

class PlaceGeometry {
  final PlaceLocation location;

  PlaceGeometry({required this.location});
}

class PlaceLocation {
  final double lat;
  final double lng;

  PlaceLocation({required this.lat, required this.lng});
}