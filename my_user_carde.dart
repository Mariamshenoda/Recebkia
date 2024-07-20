import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserInfoCard extends StatefulWidget {
  String? logedinUser;
  UserInfoCard({super.key, required this.logedinUser});

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350, // Increased width to show all data comfortably
      height: 600, // Increased height to show all data comfortably
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.logedinUser)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text('we have no data for you till now 😔'),
              );
            }

            var user = snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_pin_rounded,
                          size: 50,
                          color: Colors.teal[900],
                        ),
                      )
                    ],
                  ),
                  Card(
                    surfaceTintColor: Colors.teal,
                    color: Colors.transparent,
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            'Welcome, ${widget.logedinUser} 😍',
                            style: TextStyle(
                              fontSize: 26,
                              letterSpacing: 1.3,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                              'Name: ${user['firstName']} ${user['lastName']}'),
                        ),
                        ListTile(
                          title: Text('address: ${user['address']}'),
                        ),
                        ListTile(
                          title: Text(
                              'Address:${user['city']},${user['governorate']}'),
                        ),
                        ListTile(
                          title: Text('Phone Number: ${user['phone']}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
