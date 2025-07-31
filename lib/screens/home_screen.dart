import 'package:flutter/material.dart';
import 'package:tugende/screens/tabs/bookings_tab.dart';
import 'package:tugende/screens/tabs/home_tab.dart';
import 'package:tugende/screens/tabs/profile_tab.dart';
import 'package:tugende/screens/tabs/promos_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _TabItem {
  final String title;
  final IconData icon;
  Widget screen;

  _TabItem({required this.title, required this.icon, required this.screen});
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<_TabItem> _tabItems = [
    _TabItem(title: 'Home', icon: Icons.home_outlined, screen: const HomeTab()),
    _TabItem(
      title: 'Promos',
      icon: Icons.monetization_on_outlined,
      screen: const PromosTab(),
    ),
    _TabItem(
      title: 'Bookings',
      icon: Icons.directions_car_filled_outlined,
      screen: const BookingsTab(),
    ),
    _TabItem(
      title: 'Profile',
      icon: Icons.person_outlined,
      screen: const ProfileTab(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabItems.map((item) => item.screen).toList(),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 13.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              _tabItems.map((item) {
                return IconButton(
                  icon: Icon(item.icon, size: 28),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        _selectedIndex == _tabItems.indexOf(item)
                            ? WidgetStateProperty.all(
                              Theme.of(context).primaryColor,
                            )
                            : WidgetStateProperty.all(Colors.transparent),
                    foregroundColor:
                        _selectedIndex == _tabItems.indexOf(item)
                            ? WidgetStateProperty.all(Colors.white)
                            : WidgetStateProperty.all(Colors.black),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = _tabItems.indexOf(item);
                    });
                  },
                );
              }).toList(),
        ),
      ),
    );
  }
}
