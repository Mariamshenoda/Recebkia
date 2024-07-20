import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gp_project/model/product.dart';

class ProductTile extends StatelessWidget {
  final Product food;
  final void Function()? onTap;

  const ProductTile({
    Key? key,
    required this.food,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection('Orders');

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromARGB(255, 202, 252, 164),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                food.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "نقطة${food.price.toString()} ",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.teal[900],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    if (user != null) {
                      // Get a reference to the user's document in the Users collection
                      final userDoc = FirebaseFirestore.instance
                          .collection('Users')
                          .doc(user.email);

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
                              title: Text('إعادة التدوير لكسب النقاط'),
                              content:
                                  Text('يجب عليك إعادة التدوير لكسب النقاط!'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('نعم'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // If totalPoints is not 0, proceed to add the item to the Orders collection
                        final orderDoc = ordersCollection.doc(user.email);
                        await orderDoc.collection('Items').add({
                          'name': food.name,
                          'price': food.price,
                          'imageUrl': food.imageUrl,
                          'date': DateTime.now(),
                        });

                        // Show a success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تمت إضافة العنصر بنجاح!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xFF54C500),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Center(child: Text("أضف إلى السلة")),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
