import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_project/components/my_button.dart';
import 'package:gp_project/components/my_textfilde.dart';
import 'package:gp_project/pages/busniss_request_page.dart';
import 'package:gp_project/pages/card_page.dart';
import 'package:gp_project/pages/home_page.dart';
import 'package:gp_project/pages/profile_page.dart';
import 'package:gp_project/pages/shop_page.dart';
import 'package:gp_project/pages/user_request_page.dart';
import 'package:gp_project/services/auth/auth_services.dart';
import 'package:gp_project/widgets/tail_part_kome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController notsController = TextEditingController();
  final _authService = AuthServices();

  late String? currentUserEmail = '';

  void initState() {
    super.initState();
    fetchCurrentUser();
  }

  void fetchCurrentUser() async {
    final _authService = AuthServices();
    User? currentUser = await _authService.getCurrentUser();
    try {
      if (currentUser != null) {
        setState(() {
          currentUserEmail = currentUser.email ?? '';
        });
      }
    } catch (e) {
      print('Error getting current user: $e');
    }
  }

  void sendRequest() async {
    try {
      // Get the email and notes from controllers
      String email = emailController.text;
      String notes = notsController.text;

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('Problems')
          .doc(currentUserEmail)
          .set({
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp
      });
      await FirebaseFirestore.instance
          .collection('Problems')
          .doc(currentUserEmail)
          .collection('nots')
          .add({
        'email': email,
        'notes': notes,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear text fields after saving
      emailController.clear();
      notsController.clear();

      // Show a success message or navigate to another page
      // For example, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إرسال الطلب بنجاح'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error sending request: $e');
      // Handle error, show an error message, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Color(0xFF49AA74),
                    height: 8,
                    endIndent: 10,
                    indent: 180,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  " البريد الإلكتروني",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 50,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            MyTextFilde(emailController, 'أدخل بريدك الإلكتروني', false,
                Icon(Icons.email_outlined), 1200),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                ),
                Text("ما المشكلة",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'regular',
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            Container(
              width: 1100,
              height: 100,
              child: TextField(
                controller: notsController,
                maxLines: null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'التعليقات والملاحظات',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(
                  'ارسل طلب',
                  ontap: sendRequest,
                  icon: Icons.send,
                )
              ],
            ),
            TailPart()
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
      title: Text('ريبيكايا'),
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
