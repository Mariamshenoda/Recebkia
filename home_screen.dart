// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:recbekia/services/auth/auth_services.dart';
// import 'package:url_launcher/url_launcher.dart';

// import 'paymob_manager.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late String? currentUserEmail = '';
//   late int totalMoney = 0;

//   @override
//   void initState() {
//     super.initState();
//     fetchCurrentUser();
//     getTotalMoney().then((value) {
//       setState(() {
//         totalMoney = value;
//       });
//     });
//   }

//   void fetchCurrentUser() async {
//     final _authService = AuthServices();
//     User? currentUser = await _authService.getCurrentUser();
//     try {
//       if (currentUser != null) {
//         setState(() {
//           currentUserEmail = currentUser.email ?? '';
//         });
//       }
//     } catch (e) {
//       print('Error getting current user: $e');
//     }
//   }

//   Future<int> getTotalMoney() async {
//     // Step 1: Fetch the role of the current user from the "Request" collection
//     final roleSnapshot = await FirebaseFirestore.instance
//         .collection('Request')
//         .doc(FirebaseAuth.instance.currentUser!.email)
//         .get();

//     // Step 2: If the role is "Business", fetch the "total-money" field from each document in the "Items" subcollection
//     if (roleSnapshot.exists) {
//       final role = roleSnapshot.data()?['role'];
//       if (role == 'Business') {
//         final itemsSnapshot = await FirebaseFirestore.instance
//             .collection('Request')
//             .doc(FirebaseAuth.instance.currentUser!.email)
//             .collection('Items')
//             .get();

//         // Step 3: Sum up all the values of the "total-money" field
//         int totalMoney = 0;
//         itemsSnapshot.docs.forEach((doc) {
//           totalMoney +=
//               (doc['total-money'] ?? 0) as int; // Explicitly convert to int
//         });

//         return totalMoney;
//       }
//     }
//     // Return 0 if role is not "Business" or if role doesn't exist
//     return 0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Paymob Integration"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async => _pay(),
//               child: const Text("Pay 10 EGP"),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 print('Total Money: $totalMoney');
//               },
//               child: const Text("Print Total"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pay() async {
//     PaymobManager().getPaymentKey(totalMoney, "EGP").then((String paymentKey) {
//       launchUrl(
//         Uri.parse(
//             "https://accept.paymob.com/api/acceptance/iframes/845444?payment_token=$paymentKey"),
//       );
//     });
//   }
// }
