import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_project/model/product.dart';
import 'package:gp_project/model/shopdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp_project/pages/shop_page.dart';
import 'package:gp_project/services/auth/auth_services.dart'; // Import Firestore package

class MedicineSearchPage extends StatefulWidget {
  @override
  _MedicineSearchPageState createState() => _MedicineSearchPageState();
}

class _MedicineSearchPageState extends State<MedicineSearchPage> {
  late final Product food;

  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  late String? currentUserEmail = '';
  final user = FirebaseAuth.instance.currentUser;
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('Orders');

  @override
  void initState() {
    super.initState();
    // Fetch the current user's details when the widget initializes
    fetchCurrentUser();
  }

  void fetchCurrentUser() async {
    final _authService = AuthServices();
    User? currentUser = await _authService.getCurrentUser();
    try {
      if (currentUser != null) {
        setState(() {
          // Update the email variable with the current user's email
          currentUserEmail = currentUser.email ?? '';
        });
      }
    } catch (e) {
      print('Error getting current user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Medicine'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShopPage(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchResults = _searchMedicine(value);
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final medicine = _searchResults[index];
                return GestureDetector(
                  onTap: () {
                    // Call a function to save selected product to Firestore
                    saveSelectedItem(medicine);
                  },
                  child: ListTile(
                    title: Text(medicine.name),
                    leading: Image.asset(medicine.imageUrl),
                    trailing: Text('\$${medicine.price.toString()}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void saveSelectedItem(Product medicine) async {
    // Check if the current user's email is available
    if (user != null) {
      // Get a reference to the user's document in the Users collection
      final userDoc =
          FirebaseFirestore.instance.collection('Users').doc(user?.email);

      // Retrieve the user data from the user's document
      final userData = await userDoc.get();

      // Check if the totalPoints field exists and is not null
      final totalPoint = userData.data()?['totalPoints'];

      if (totalPoint == null || totalPoint == 0) {
        // If totalPoints is null or 0, show a pop-up message indicating they should recycle to earn points
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Recycle to Earn Points'),
              content: Text('You need to recycle to earn points!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // If totalPoints is not 0, proceed to add the item to the Orders collection
        final orderDoc = ordersCollection.doc(user?.email);
        await orderDoc.collection('Items').add({
          'name': food.name,
          'price': food.price,
          'imageUrl': food.imageUrl,
          'date': DateTime.now(),
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item added successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Handle the case where current user's email is not available
      print('User email not available');
    }
  }

  List<Product> _searchMedicine(String query) {
    // Call the searchMedicine function from your Shope class
    return Shope().searchMedicine(query);
  }
}
