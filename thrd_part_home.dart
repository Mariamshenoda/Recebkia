import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_project/pages/busniss_request_page.dart';
import 'package:gp_project/pages/user_request_page.dart';

class Cardes extends StatelessWidget {
  const Cardes({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Roles')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(); // Return an empty container while loading
          } else {
            if (snapshot.hasError) {
              return Container(); // Return an empty container on error
            } else {
              final role = snapshot.data!.get('role');
              if (role == 'User') {
                return Container(
                  height: 400,
                  color: Color(0xFFA0EB68),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserRequestPage(
                                          type: 'كرتون',
                                        )),
                              );
                            },
                            child: ServiceCard(
                              image: AssetImage(
                                  'images/1_j9BnLsdm0LWdsDAcGU5tRA.jpg'),
                              name: 'كرتون',
                              description:
                                  'يمكنك وضع كرتون بأي حجم وكمية واستبدالها بالنقاط أو النقود',
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserRequestPage(
                                          type: 'بلاستيك',
                                        )),
                              );
                            },
                            child: ServiceCard(
                              image: AssetImage(
                                  'images/istockphoto-1166983428-612x612.jpg'),
                              name: 'بلاستيك',
                              description:
                                  'يمكنك وضع زجاجات بأي حجم وكمية واستبدالها بالنقاط أو النقود',
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserRequestPage(
                                          type: 'علب',
                                        )),
                              );
                            },
                            child: ServiceCard(
                              image:
                                  AssetImage('images/10941_pe_cans_768022.jpg'),
                              name: 'علب',
                              description:
                                  'يمكنك وضع علب بأي حجم وكمية واستبدالها بالنقاط أو النقود',
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserRequestPage(
                                          type: 'ورق',
                                        )),
                              );
                            },
                            child: ServiceCard(
                              image: AssetImage(
                                  'images/Shutterstock_1777304945.jpg'),
                              name: 'ورق',
                              description:
                                  'يمكنك وضع ورق بأي حجم وكمية واستبداله بالنقاط أو النقود',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  height: 400,
                  color: Color(0xFFA0EB68),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BusnissRequestPage(
                                          rtype: 'كرتون',
                                        )),
                              );
                            },
                            child: ServiceCard(
                              image: AssetImage(
                                  'images/1_j9BnLsdm0LWdsDAcGU5tRA.jpg'),
                              name: 'كرتون',
                              description:
                                  'يمكنك وضع كرتون بأي حجم وكمية واستبدالها بالنقاط أو النقود',
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BusnissRequestPage(
                                          rtype: 'بلاستيك',
                                        )),
                              );
                            },
                            child: ServiceCard(
                              image: AssetImage(
                                  'images/istockphoto-1166983428-612x612.jpg'),
                              name: 'بلاستيك',
                              description:
                                  'يمكنك وضع زجاجات بأي حجم وكمية واستبدالها بالنقاط أو النقود',
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BusnissRequestPage(
                                          rtype: 'علب',
                                        )),
                              );
                            },
                            child: ServiceCard(
                              image:
                                  AssetImage('images/10941_pe_cans_768022.jpg'),
                              name: 'علب',
                              description:
                                  'يمكنك وضع علب بأي حجم وكمية واستبدالها بالنقاط أو النقود',
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BusnissRequestPage(
                                          rtype: 'ورق',
                                        )),
                              );
                            },
                            child: ServiceCard(
                              image: AssetImage(
                                  'images/Shutterstock_1777304945.jpg'),
                              name: 'ورق',
                              description:
                                  'يمكنك وضع ورق بأي حجم وكمية واستبداله بالنقاط أو النقود',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          }
        });
  }
}

class ServiceCard extends StatelessWidget {
  final ImageProvider image;
  final String name;
  final String description;

  const ServiceCard({
    required this.image,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
