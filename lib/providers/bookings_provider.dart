import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tugende/providers/auth_provider.dart';


final bookingsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, id) async {
      // Fetch bookings for the user
      print('Fetching bookings for user: ${ref.read(userStateProvider).user?.uid}');
      return await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: ref.read(userStateProvider).user?.uid)
          .orderBy('bookingDate', descending: true)
          .limit(6)
          .get()
          .then((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    });
