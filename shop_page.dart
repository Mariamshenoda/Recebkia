import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gp_project/components/my_product_tile.dart';
import 'package:gp_project/model/product.dart';
import 'package:gp_project/model/shopdata.dart';
import 'package:gp_project/pages/busniss_request_page.dart';
import 'package:gp_project/pages/card_page.dart';
import 'package:gp_project/pages/contact_page.dart';
import 'package:gp_project/pages/home_page.dart';
import 'package:gp_project/pages/profile_page.dart';
import 'package:gp_project/pages/search_page.dart';
import 'package:gp_project/pages/user_request_page.dart';
import 'package:gp_project/services/auth/auth_services.dart';

class ShopPage extends StatelessWidget {
  ShopPage({Key? key}) : super(key: key);
  final _authService = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(context),
      body: Padding(
        padding: const EdgeInsets.only(left: 100.0, right: 100, top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicineSearchPage(),
                              ));
                        },
                        icon: Icon(Icons.search))),
              ],
            ),
            Expanded(
              child: Consumer<Shope>(
                builder: (context, shope, child) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: shope.menu.length,
                    itemBuilder: (context, index) {
                      Product product = shope.menu[index];
                      return Card(
                        elevation: 2,
                        child: ProductTile(
                          food: product,
                          onTap: () {},
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar MyAppbar(BuildContext context) {
    // Receive the context here
    return AppBar(
      backgroundColor: Colors.white,
      leading: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage('images/logo.png'))),
      ),
      title: Text('ريسبيكايا'),
      actions: [
        StreamBuilder(
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
                  // Show all buttons for user role
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContactPage(),
                                ));
                          },
                          child: Text(
                            "الاتصال",
                            style: TextStyle(color: Colors.black),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CartPage(),
                                ));
                          },
                          child: Text(
                            "العربة",
                            style: TextStyle(color: Colors.black),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShopPage(),
                                ));
                          },
                          child: Text(
                            "منتجات",
                            style: TextStyle(color: Colors.black),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserRequestPage(),
                                ));
                          },
                          child: Text(
                            "إعادة التدوير",
                            style: TextStyle(color: Colors.black),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ));
                          },
                          child: Text(
                            "الصفحة الرئيسية",
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  );
                } else {
                  // Hide Recycle button for non-user roles
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContactPage(),
                                ));
                          },
                          child: Text(
                            "الاتصال",
                            style: TextStyle(color: Colors.black),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BusnissRequestPage(),
                                ));
                          },
                          child: Text(
                            "طلبات",
                            style: TextStyle(color: Colors.black),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ));
                          },
                          child: Text(
                            "الصفحة الرئيسية",
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  );
                }
              }
            }
          },
        ),
        SizedBox(
          width: 400,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green)),
              child: Center(
                  child: IconButton(
                key: _notificationButtonKey,
                onPressed: () {
                  showWelcomeMenu(context);
                },
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_active_rounded),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Notification')
                          .doc(FirebaseAuth.instance.currentUser?.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox
                              .shrink(); // Empty box while loading
                        } else if (snapshot.hasError) {
                          return const SizedBox
                              .shrink(); // Empty box if there's an error
                        } else if (snapshot.hasData &&
                            snapshot.data?.exists == true) {
                          // Data exists, show a green dot
                          return Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green, // Dot color
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox
                              .shrink(); // Empty box if no data
                        }
                      },
                    ),
                  ],
                ),
              )),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green)),
              child: IconButton(
                icon: Icon(Icons.person_pin),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfilePage(),
                      ));
                },
              ),
            ),
            IconButton(
                onPressed: () {
                  _authService.signout();
                },
                icon: Icon(Icons.logout))
          ],
        ),
        SizedBox(
          width: 80,
        )
      ],
    );
  }

  final GlobalKey _notificationButtonKey = GlobalKey();

  void showWelcomeMenu(BuildContext context) {
    final RenderBox button =
        _notificationButtonKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          button.localToGlobal(Offset.zero, ancestor: overlay),
          button.localToGlobal(button.size.bottomLeft(Offset.zero),
              ancestor: overlay),
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          // ignore: sort_child_properties_last
          child: SizedBox(
            width: 1000, // Adjust width as needed
            height: 200, // Adjust height as needed
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Notification')
                    .doc(FirebaseAuth.instance.currentUser!.email)
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
                      child: Text('there is no notifications'),
                    );
                  }

                  var user = snapshot.data!.data() as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.teal[200],
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: 50,
                              child: Center(child: Text('${user['massege']}'))),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          enabled: false,
        ),
      ],
    );
  }
}
