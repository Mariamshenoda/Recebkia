import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gp_project/pages/profile_page.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<Item> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle user not logged in scenario
        return;
      }
      String email = user.email!;
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('Request')
              .doc(email)
              .get();

      if (documentSnapshot.exists) {
        QuerySnapshot<Map<String, dynamic>> itemsSnapshot =
            await FirebaseFirestore.instance
                .collection('Request')
                .doc(email)
                .collection('Items')
                .get();

        List<Item> fetchedItems = itemsSnapshot.docs.map((doc) {
          return Item.fromFirestore(doc.data(), doc.id);
        }).toList();

        setState(() {
          items = fetchedItems;
          isLoading = false;
        });
      } else {
        // Handle document does not exist scenario
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle errors appropriately
      print('Error fetching items: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('السجل'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(),
                ));
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? const Center(child: Text('لم يتم العثور على العناصر.'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: const EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text(item.city),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Comments: ${item.comments}'),
                            Text('Governorate: ${item.governorate}'),
                            Text('Payment Method: ${item.paymentMethod}'),
                            Text('Total Points: ${item.totalmoney}'),
                            Text('Type: ${item.type}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class Item {
  final String id;
  final String city;
  final String comments;
  final String governorate;
  final String paymentMethod;
  final int totalmoney;
  final String type;

  Item({
    required this.id,
    required this.city,
    required this.comments,
    required this.governorate,
    required this.paymentMethod,
    required this.totalmoney,
    required this.type,
  });

  factory Item.fromFirestore(Map<String, dynamic> data, String id) {
    return Item(
      id: id,
      city: data['city'] ?? '',
      comments: data['comments'] ?? '',
      governorate: data['governorate'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      totalmoney: data['total-money'] ?? 0,
      type: data['type'] ?? '',
    );
  }
}
