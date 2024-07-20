import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gp_project/pages/busniss_request_page.dart';
import 'package:gp_project/pages/card_page.dart';
import 'package:gp_project/pages/contact_page.dart';
import 'package:gp_project/pages/profile_page.dart';
import 'package:gp_project/pages/shop_page.dart';
import 'package:gp_project/pages/user_request_page.dart';
import 'package:gp_project/services/auth/auth_services.dart';
import 'package:gp_project/widgets/divider.dart';
import 'package:gp_project/widgets/frist_part_hom.dart';
import 'package:gp_project/widgets/sec_part_home.dart';
import 'package:gp_project/widgets/tail_part_kome.dart';
import 'package:gp_project/widgets/thrd_part_home.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(context), // Make sure MyAppbar accepts context
      body: SingleChildScrollView(
        child: Column(
          children: [
            Frist(),
            ContainerWithImages(),
            SizedBox(height: 20),
            MyDivider(titel: 'خدمات'),
            SizedBox(height: 20),
            Cardes(),
            SizedBox(height: 20),
            MyDivider(titel: 'شركاؤنا'),
            Container(
              height: 250,
              color: Color(0xFFA0EB68),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset("images/logoun.jpg"),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 350,
                        width: 350,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/logo.jpg"),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("images/images.png"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            MyDivider(titel: 'إحصائيات ريسبيكايا'),
            SizedBox(height: 250),
            Divider(),
            TailPart(),
          ],
        ),
      ),
    );
  }
}

final _authService = AuthServices();

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
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                        return const SizedBox.shrink(); // Empty box if no data
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
                    child: Text('There are no notifications'),
                  );
                }

                var user = snapshot.data!.data() as Map<String, dynamic>;

                // Check if there are any notifications
                bool hasNotifications = user.isNotEmpty;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: hasNotifications
                        ? Colors.green
                        : Colors
                            .teal[200], // Change color based on notification
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                          child: Center(child: Text('${user['massege']}')),
                        ),
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
