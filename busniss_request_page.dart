// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_project/components/my_button.dart';
import 'package:gp_project/pages/card_page.dart';
import 'package:gp_project/pages/contact_page.dart';
import 'package:gp_project/pages/home_page.dart';
import 'package:gp_project/pages/profile_page.dart';
import 'package:gp_project/pages/shop_page.dart';
import 'package:gp_project/pages/user_request_page.dart';
import 'package:gp_project/paymob/paymob_manager.dart';
import 'package:gp_project/services/auth/auth_services.dart';
import 'package:gp_project/widgets/tail_part_kome.dart';
import 'package:url_launcher/url_launcher.dart';
 
class BusnissRequestPage extends StatefulWidget {
  String? rtype;
  BusnissRequestPage({Key? key, this.rtype});

  @override
  State<BusnissRequestPage> createState() => _BusnissRequestPageState();
}

class _BusnissRequestPageState extends State<BusnissRequestPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Define your types and their corresponding prices
  // للمصنع تعديل الاسعار من هنا
  Map<String, int> typePrices = {
    'بلاستيك': 18000,
    'كرتون': 10000,
    'علب': 63000,
    'ورق': 4800,
  };

  // Define lists for types and sizes
  final List<String> types = ['بلاستيك', 'كرتون', 'علب', 'ورق'];
  // Example sizes
  final List<int> sizes = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300, 310, 320, 330, 340, 350, 360, 370, 380, 390, 400, 410, 420, 430, 440, 450, 460, 470, 480, 490, 500, 510, 520, 530, 540, 550, 560, 570, 580, 590, 600, 610, 620, 630, 640, 650, 660, 670, 680, 690, 700, 710, 720, 730, 740, 750, 760, 770, 780, 790, 800, 810, 820, 830, 840, 850, 860, 870, 880, 890, 900, 910, 920, 930, 940, 950, 960, 970, 980, 990, 1000];
  final _authService = AuthServices();
  List<String> governorates = [
    "القاهرة",
    "الإسكندرية",
    "الجيزة",
    "أسوان",
    "أسيوط"
  ];

  Map<String, List<String>> cities = {
    "القاهرة": [
      "مدينة نصر",
      "المعادي",
      "مصر الجديدة",
      "الدقي",
      "شبرا",
      "المطرية",
      "مصر الجديدة",
      "مسطرد",
      "الفسطاط",
      "بولاق"
    ],
    'الإسكندرية': ['سموحة', 'ميامي', 'المنتزه', 'العجمي', 'سيدي بشر', 'الرمل'],
    "الجيزة": [
      "الدقي",
      "العجوزة",
      "إمبابة"
          "الصف",
      "العياط",
      "مدينة ست أكتوبر",
      "أوسيم"
    ],
    "أسوان": ["مدينة أسوان", " كوم أمبو", "إدفو", " أبو سمبل"],
    "أسيوط": [
      "محافظة أسيوط",
      "الزيتون",
      "القسيمة",
      "تل الأسد",
      "الجرجاوي",
      "ابنودة",
      "المنشية",
      "العبيد",
      "المعلقة",
      "العظيم",
      "الوداع",
      "العزيزية",
      "العز",
      "النصر",
      "الإصلاح",
      "الشرقية",
      "المنصورة",
      "الحمامي",
    ]
  };

  String? selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = widget.rtype;
  }

  String? selectedSize;
  String selectedGovernorate = 'أسيوط';

  String selectedCity = 'الحمامي';
  final TextEditingController notsController = TextEditingController();

  int totalMoney = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('images/zero-waste-concept-composition.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 500,
              width: double.infinity,
              color: Color(0xFFDFF9CD),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      children: [
                        // Adding SizedBox to create space between Text and Divider
                        Expanded(
                          child: Divider(
                            color: Color(0xFF49AA74),
                            height: 8,
                            endIndent: 20,
                            indent: 10,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          "للطلب",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedType,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'اختر صنف',
                              prefixIcon: Icon(Icons.category),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedType = value;
                                updateTotalMoney();
                              });
                            },
                            items: types.map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedSize,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'أختر الحجم',
                              prefixIcon: Icon(Icons.format_size),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedSize = value;
                                updateTotalMoney();
                              });
                            },
                            items: sizes.map((size) {
                              return DropdownMenuItem<String>(
                                value: size.toString(),
                                child: Text(size.toString()),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedGovernorate,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'اختر المحافظة',
                              prefixIcon: Icon(Icons.location_city),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedGovernorate = value!;
                                selectedCity = cities[selectedGovernorate]![0];
                              });
                            },
                            items: governorates.map((governorate) {
                              return DropdownMenuItem<String>(
                                value: governorate,
                                child: Text(governorate),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedCity,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'اختر مدينة',
                              prefixIcon: Icon(Icons.location_city),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedCity = value!;
                              });
                            },
                            items: cities[selectedGovernorate]!.map((city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyButton(
                          'ارسل طلب',
                          ontap: _sendRequest,
                          icon: Icons.send,
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'مجموع الأموال: $totalMoney',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            TailPart()
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
    );
  }

  void _sendRequest() async {
    // Get current user
    User? user = _auth.currentUser;
    if (user != null) {
      // Get current user's email
      String currentUserEmail = user.email!;

      // Show dialog to choose payment method and send request
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            
            title: Text('اختر وسيلة الدفع'),
            content: Text(
                "سيتم خصم  نسبه ١.٥ ٪من المبلغ المطلوب كماصريف شحن لا يوجد الغاء للطلب ولا استرجاع\nهل تريد أن يتم الدفع لك عبر  بطاقة الائتمان؟"),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text('الغاء'),
              ),
              Spacer(),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  _sendRequestToFirestore(currentUserEmail, 'Credit Card');
                },
                child: Text('بطاقة إئتمان'),
              ),
              
            ],
          );
        },
      );
    }
  }

  Future<void> _pay() async {
    PaymobManager().getPaymentKey(totalMoney, "EGP").then((String paymentKey) {
      launchUrl(
        Uri.parse(
            "https://accept.paymob.com/api/acceptance/iframes/845444?payment_token=$paymentKey"),
      );
    });
  }

  Future<void> _sendRequestToFirestore(
      String currentUserEmail, String paymentMethod) async {
    try {
      // Check if type and size fields are not empty
      if (selectedType!.isNotEmpty && selectedSize!.isNotEmpty) {
        // Retrieve user's role
        String userRole = await _getUserRole(currentUserEmail);

        // Save data to Firestore
        await _saveRequestToFirestore(
            currentUserEmail, userRole, paymentMethod);

        // Show payment confirmation message
      }
    } catch (e) {
      // Show error message if an unexpected error occurs
      print('Error sending request: $e');
      _showErrorDialog('Error', 'Type and size fields cannot be empty.');
    }
  }

  Future<String> _getUserRole(String currentUserEmail) async {
    DocumentSnapshot userRoleSnapshot =
        await _firestore.collection('Roles').doc(currentUserEmail).get();
    return userRoleSnapshot['role'];
  }

  Future<void> _saveRequestToFirestore(
      String currentUserEmail, String userRole, String paymentMethod) async {
    // Reference to the user document
    DocumentReference userDoc =
        _firestore.collection('Users').doc(currentUserEmail);

    // Fetch user document data
    DocumentSnapshot userSnapshot = await userDoc.get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      // Check if all required fields are not null
      bool isProfileComplete = userData['address'] != null &&
          userData['city'] != null &&
          userData['email'] != null &&
          userData['firstName'] != null &&
          userData['governorate'] != null &&
          userData['lastName'] != null &&
          userData['phone'] != null;

      if (isProfileComplete) {
        _pay();
        // Save the request if profile is complete
        await _firestore.collection('Request').doc(currentUserEmail).set({
          'Orders': 'Welcome',
          'role': userRole,
        });

        await _firestore
            .collection('Request')
            .doc(currentUserEmail)
            .collection('Items')
            .add({
          'type': selectedType,
          'size': selectedSize,
          'governorate': selectedGovernorate,
          'city': selectedCity,
          'comments': notsController.text,
          'paymentMethod': paymentMethod,
          'total-money': totalMoney,
        });

        await _firestore
            .collection('Notification')
            .doc(currentUserEmail)
            .set({'massege': 'سوف يصلك الطلب خلال يومين الى ثلاثة ايام'});

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUserEmail)
            .set({'total-money': totalMoney}, SetOptions(merge: true));
        _showPaymentConfirmationDialog(paymentMethod);
      } else {
        // Show alert message to update profile
        print("يرجى تحديث ملفك الشخصي ليشمل جميع الحقول المطلوبة.");
        // You can use a package like fluttertoast or showDialog to display an alert
        // For example, using showDialog:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Profile Incomplete'),
            content: Text('يرجى تحديث ملفك الشخصي بجميع الحقول المطلوبة.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('نعم'),
              ),
            ],
          ),
        );
      }
    } else {
      // Handle case where user document does not exist
      print("User document does not exist. Please update your profile.");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('الملف الشخصي غير مكتمل'),
          content: Text('يرجى إكمال ملفك الشخصي أولاً.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfilePage(),
                    ));
              },
              child: Text('نعم'),
            ),
          ],
        ),
      );
    }
  }

  void _showPaymentConfirmationDialog(String paymentMethod) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تم اختيار طريقة الدفع'),
          content: Text(
            paymentMethod == 'Credit Card'
                ? 'سوف تصلك رسالة من البنك بالمبلغ الإجمالي المخفض'
                : 'You will receive a message from Google Pay with the total discounted amount.',
          ),
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
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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
  }

  void updateTotalMoney() {
    if (selectedType != null && selectedSize != null) {
      int price = typePrices[selectedType!] ?? 0;
      int size = int.parse(selectedSize!);
      setState(() {
        totalMoney = price * size;
      });
    }
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
