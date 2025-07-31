import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tugende/config/routes_config.dart';
import 'package:tugende/providers/auth_provider.dart';
import 'package:tugende/providers/bookings_provider.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

enum StatType { bookedRides, dayStreak, appliedPromos, totalTips }

class _StatItem {
  final StatType type;
  final int value;
  final String image;
  final String description;
  final Color? color;

  _StatItem({
    required this.type,
    required this.value,
    required this.image,
    required this.description,
    this.color,
  });
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userStateProvider);
    final recentBookings = ref.watch(bookingsProvider(''));

    final List<_StatItem> statItems = [
      _StatItem(
        type: StatType.bookedRides,
        value: recentBookings.whenOrNull(data: (data) => data.length) ?? 0,
        image: 'assets/icons/twemoji_racing-car.png',
        description: 'Booked Rides',
      ),
      _StatItem(
        type: StatType.dayStreak,
        value: recentBookings.whenOrNull(data: (data) => data.length) ?? 0,
        image: 'assets/icons/noto-v1_fire.png',
        description: 'Day Streak',
        color: Theme.of(context).colorScheme.secondary,
      ),
      _StatItem(
        type: StatType.appliedPromos,
        value: 0,
        image: 'assets/icons/lsicon_badge-promotion-filled.png',
        description: 'Applied Promos',
        color: Theme.of(context).colorScheme.secondary,
      ),
      _StatItem(
        type: StatType.totalTips,
        value: 0,
        image: 'assets/icons/noto_money-bag.png',
        description: 'Total Tips',
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hi ${userState.user?.fullName?.split(" ").reversed.elementAt(0) ?? userState.user?.email}',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Ready for your next ride?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search_outlined),
                          onPressed: () {},
                          padding: const EdgeInsets.all(8.0),
                          iconSize: 28,
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () {},
                          padding: const EdgeInsets.all(8.0),
                          iconSize: 28,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: statItems.map(
                    (item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 13,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  item.color ??
                                  Theme.of(context).primaryColor,
                              child: Image.asset(
                                item.image,
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.value.toString(),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  item.description,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey.shade800),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // 2 Quick Action Buttons with each leading icon and text and a border radius of 8 wwith background color of #ADD7FE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 10,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  202,
                                  241,
                                  247,
                                ),
                                foregroundColor: Colors.black,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_circle,
                                    size: 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text('Book a Ride'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.redeemPromoScreen,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  202,
                                  241,
                                  247,
                                ),
                                foregroundColor: Colors.black,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_offer,
                                    size: 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text('Apply Promo Code'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 240, 244, 243),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                iconSize: 20,
                                icon: Icon(
                                  Icons.close_fullscreen_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {},
                              ),
                              Text(
                                'Recent Activity',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.replay_circle_filled_sharp,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              ref.invalidate(bookingsProvider(''));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      recentBookings.when(
                        loading:
                            () => const Center(
                              child: SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            ),
                        data: (data) {
                          if (data.isEmpty) {
                            return const SizedBox(
                              height: 200,
                              child: Center(
                                child: Text('No recent bookings found.'),
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final booking = data[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.green.shade100,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  leading: ClipOval(
                                    child: Image.asset(
                                      'assets/images/map.png',
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    '${booking['fromLocation']} - ${booking['toLocation']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    '${booking['bookingDate'].toDate().toLocal()}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'RWF ${booking['price'].toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        booking['paymentMethod'] ?? 'Cash',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        //200 height
                        error:
                            (error, stack) => SizedBox(
                              height: 200,
                              child: Center(
                                child: Text(
                                  'Click the refresh button to try again.',
                                ),
                              ),
                            ),
                      ),
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemCount: _recent_bookings.length, // Example count
                      //   itemBuilder: (context, index) {
                      //     final booking = _recent_bookings[index];
                      //     return Container(
                      //       margin: const EdgeInsets.only(bottom: 10),
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         border: Border.all(
                      //           color: Colors.green.shade100,
                      //           width: 1,
                      //         ),
                      //         borderRadius: BorderRadius.circular(8),
                      //       ),
                      //       child: ListTile(
                      //         leading: ClipOval(
                      //           child: Image.asset(
                      //             'assets/images/map.png',
                      //             width: 40,
                      //             height: 40,
                      //             fit: BoxFit.cover,
                      //           ),
                      //         ),
                      //         title: Text(
                      //           '${booking['fromLocation']} - ${booking['toLocation']}',
                      //           style: TextStyle(fontWeight: FontWeight.bold),
                      //         ),
                      //         subtitle: Text(
                      //           '${booking['bookingDate'].toDate().toLocal()}',
                      //           style: TextStyle(
                      //             fontSize: 12,
                      //             color: Colors.grey.shade800,
                      //           ),
                      //         ),
                      //         trailing: Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Text(
                      //               'RWF ${booking['price'].toStringAsFixed(2)}',
                      //               style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Theme.of(context).primaryColor,
                      //               ),
                      //             ),
                      //             const SizedBox(height: 4),
                      //             Text(
                      //               booking['paymentMethod'] ?? 'Cash',
                      //               style: TextStyle(
                      //                 fontSize: 12,
                      //                 color: Colors.grey.shade800,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
