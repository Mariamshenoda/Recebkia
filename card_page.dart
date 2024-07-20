import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gp_project/components/my_button.dart';
import 'package:gp_project/model/shopdata.dart';
import 'package:gp_project/pages/busniss_request_page.dart';
import 'package:gp_project/pages/contact_page.dart';
import 'package:gp_project/pages/home_page.dart';
import 'package:gp_project/pages/profile_page.dart';
import 'package:gp_project/pages/shop_page.dart';
import 'package:gp_project/pages/user_request_page.dart';
import 'package:gp_project/services/auth/auth_services.dart';
import 'package:gp_project/widgets/tail_part_kome.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late String? currentUserEmail = '';

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

  void fetchCurrentUser() async {
    final _authService = AuthServices();
    User? currentUser = await _authService.getCurrentUser();
    if (currentUser != null) {
      setState(() {
        currentUserEmail = currentUser.email ?? '';
      });
    }
  }

  void deleteCartItem(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Orders")
          .doc(currentUserEmail)
          .collection("Items")
          .doc(documentId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تمت إزالة العنصر من سلة التسوق'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل في إزالة العنصر من سلة التسوق'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void updateQuantity(String documentId, int newQuantity) async {
    try {
      await FirebaseFirestore.instance
          .collection("Orders")
          .doc(currentUserEmail)
          .collection("Items")
          .doc(documentId)
          .update({'quantity': newQuantity});
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<void> handleCheckout() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserEmail)
          .get();

      if (userDoc.exists) {
        int userTotalPoints = userDoc['totalPoints'];
        double totalCartPoints = await calculateTotalCartPoints();

        if (userTotalPoints >= totalCartPoints) {
          int updatedTotalPoints = (userTotalPoints - totalCartPoints) as int;

          await FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUserEmail)
              .update({'totalPoints': updatedTotalPoints});
          await FirebaseFirestore.instance
              .collection('Notification')
              .doc(currentUserEmail)
              .set({'massege': 'سوف يصلك الطلب خلال 45 دقيقة'});

          await clearCart();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'تم إتمام عملية الدفع بنجاح! إجمالي نقاطك الجديدة: $updatedTotalPoints'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('نقاط غير كافية للدفع.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('لم يتم العثور على المستخدم.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error during checkout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشلت عملية الدفع. يرجى المحاولة مرة أخرى.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<double> calculateTotalCartPoints() async {
    double totalCartPoints = 0.0;

    QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
        .collection('Orders')
        .doc(currentUserEmail)
        .collection('Items')
        .get();

    for (DocumentSnapshot document in cartSnapshot.docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      double price = data['price'] ?? 0;
      int quantity = data['quantity'] ?? 1;
      totalCartPoints += price * quantity;
    }

    return totalCartPoints;
  }

  Future<void> clearCart() async {
    QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
        .collection('Orders')
        .doc(currentUserEmail)
        .collection('Items')
        .get();

    for (DocumentSnapshot document in cartSnapshot.docs) {
      await document.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Shope>(
      builder: (context, shope, child) {
        return Scaffold(
          appBar: MyAppbar(context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          MyButton(
                            "العودة إلى التسوق",
                            ontap: () {
                              Navigator.pop(context);
                            },
                          ),
                          MyButton(
                            "مواصلة التسوق",
                            ontap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShopPage(),
                                ),
                              );
                            },
                            width: 200,
                          ),
                        ],
                      ),
                      const Text(
                        "عربة التسوق",
                        style: TextStyle(
                          fontFamily: "Product Sans",
                          letterSpacing: .5,
                          fontWeight: FontWeight.w600,
                          fontSize: 34,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                    "هل أنت متأكد أنك تريد مسح عربة التسوق؟"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("إلغاء"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await clearCart();
                                    },
                                    child: const Text("نعم"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text(
                            "امسح الكل",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                      ),
                      const Expanded(flex: 1, child: Text("كمية")),
                      const SizedBox(width: 20),
                      const Expanded(flex: 1, child: Text("السعر الكلي")),
                      const SizedBox(width: 50),
                      const Expanded(flex: 1, child: Text("منتج")),
                    ],
                  ),
                ),
                const Divider(endIndent: 30, indent: 30),
                Container(
                  height: 300,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .doc(currentUserEmail)
                        .collection('Items')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "سلة التسوق الخاصة بك فارغة......🥺",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document =
                              snapshot.data!.docs[index];
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          String documentId = document.id;
                          String name = data['name'];
                          double price = data['price'];
                          String imageUrl = data['imageUrl'];
                          int quantity = data['quantity'] ?? 1;

                          return Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: IconButton(
                                                onPressed: () async {
                                                  deleteCartItem(documentId);
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (quantity > 1) {
                                                          quantity--;
                                                          updateQuantity(
                                                              documentId,
                                                              quantity);
                                                        }
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.remove),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    '$quantity',
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        quantity++;
                                                        updateQuantity(
                                                            documentId,
                                                            quantity);
                                                      });
                                                    },
                                                    icon: const Icon(Icons.add),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 190,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                '$price  نقطة',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: AssetImage(imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const Divider(endIndent: 30, indent: 30),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Orders")
                      .doc(currentUserEmail)
                      .collection("Items")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading...');
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    double totalPrice = 0;
                    for (DocumentSnapshot document in snapshot.data!.docs) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      double price = data['price'] ?? 0;
                      int quantity = data['quantity'] ?? 1;
                      totalPrice += price * quantity;
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            " نقطة",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Colors.teal[900],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            totalPrice.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Colors.teal[900],
                            ),
                          ),
                          const Text(
                            ":المجموع ",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(endIndent: 30, indent: 30),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyButton(
                      "تأكيد الطلب",
                      ontap: () {
                        handleCheckout();
                      },
                      icon: Icons.shopify_sharp,
                      width: 250,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Divider(),
                const TailPart(),
              ],
            ),
          ),
        );
      },
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
