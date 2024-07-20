import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gp_project/components/my_button.dart';
import 'package:gp_project/pages/busniss_request_page.dart';
import 'package:gp_project/pages/card_page.dart';
import 'package:gp_project/pages/contact_page.dart';
import 'package:gp_project/pages/home_page.dart';
import 'package:gp_project/pages/profile_page.dart';
import 'package:gp_project/pages/shop_page.dart';
import 'package:gp_project/services/auth/auth_services.dart';
import 'package:gp_project/widgets/tail_part_kome.dart';

// ignore: must_be_immutable
class UserRequestPage extends StatefulWidget {
  String? type;
  UserRequestPage({Key? key, this.type});

  @override
  State<UserRequestPage> createState() => _UserRequestPageState();
}

class _UserRequestPageState extends State<UserRequestPage> {
  // Firebase references
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Define lists for types and sizes
  final List<String> types = ['بلاستيك', 'كرتون', 'علب', 'ورق', "(بلاستيك,كرتون,ورق,علب)خليط"];
 
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
  @override
  // ignore: override_on_non_overriding_member

  void initState() {
    super.initState();
    selectedType =
        widget.type; // Use widget.type to access the type passed to the widget
  }

  String? selectedType;
  // Selected type
  String? selectedSize;
  // Selected size
  String selectedGovernorate = 'أسيوط';

  String selectedCity = 'الحمامي';
  final TextEditingController notsController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();

  double totalPoints = 0;
  double totalcash = 0;

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
                                calculateTotalPoints();
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
                          child: TextFormField(
                            controller:
                                _sizeController, // Use a TextEditingController to get the text input
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'حدد الحجم (الحد الأدنى 1 كجم)',
                              prefixIcon: Icon(Icons.format_size),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedSize = value;
                                calculateTotalPoints();
                              });
                            },
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
                                // Reset selected city when governorate changes
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
                        maxLines:
                            null, // Allow multiple lines for comments and notes
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'التعليقات والملاحظات',
                          prefixIcon: Icon(Icons.note),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'مجمل النقاط: $totalPoints',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          'مجموع المبالغ النقدية: $totalcash',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("معلومات عن كميات الاصناف"),
                                  content: Text(
                                      "يحتوي 1 كيلو من العلب الكان علي عدد 70 الي 75 علبة* \n"
                                      "يحتوي 1 كيلو من العلب البلاسنيكية علي عدد 34 الي 38 علبة*\n"
                                      "يحتوي 1 كيلو من الورق علي عدد 15 الي 20 كتاب*\n"
                                      "يحتوي 1 كيلو من الكارتون علي عدد 6 الي 8 علبة كارتون صغيرة*"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('تم'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.info_outlined,
                            size: 35,
                          ),
                        ),
                        MyButton(
                          'ارسل طلب',
                          ontap: () {
                            _sendRequest();
                          },
                          icon: Icons.send,
                        )
                      ],
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
// تعديل الاسعار و التقاط للمسنخدم
  void calculateTotalPoints() {
    if (selectedSize != null && double.parse(selectedSize!) >= 1) {
      if (selectedType == 'بلاستيك') {
        totalPoints = double.parse(selectedSize!) * 20;
        totalcash = double.parse(selectedSize!) * 17;
      } else if (selectedType == 'كرتون') {
        totalPoints = double.parse(selectedSize!) * 10;
        totalcash = double.parse(selectedSize!) * 7;
      } else if (selectedType == 'علب') {
        totalPoints = double.parse(selectedSize!) * 70;
        totalcash = double.parse(selectedSize!) * 65;
      } else if (selectedType == 'ورق') {
        totalPoints = double.parse(selectedSize!) * 10;
        totalcash = double.parse(selectedSize!) * 7.5;
      } else if (selectedType == 'خليط') {
        totalPoints = double.parse(selectedSize!) * 18;
        totalcash = double.parse(selectedSize!) * 15;
      }
    } else {
      totalPoints = 0;
      totalcash = 0;
    }
  }

  void _sendRequest() async {
    // Get current user
    User? user = _auth.currentUser;
    if (user != null) {
      // Get current user's email
      String currentUserEmail = user.email!;

      // Show dialog to choose payment method
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('اختر وسيلة الدفع'),
            content: Text('هل تريد أن يتم الدفع لك نقدًا أم بالنقاط؟'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _sendRequestToFirestore(currentUserEmail, 'Cash');
                },
                child: Text('نقدي'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _sendRequestToFirestore(currentUserEmail, 'Points');
                },
                child: Text('نقاط'),
              ),
            ],
          );
        },
      );
    }
  }

  void _sendRequestToFirestore(
      String currentUserEmail, String paymentMethod) async {
    try {
      // Fetch user document from the "Users" collection
      DocumentSnapshot userSnapshot =
          await _firestore.collection('Users').doc(currentUserEmail).get();

      // Check if user document exists
      if (!userSnapshot.exists) {
        // If user document doesn't exist, show alert to update the profile
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('مطلوب تحديث الملف الشخصي'),
              content: Text('يرجى تحديث ملفك الشخصي قبل تقديم الطلب.'),
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
            );
          },
        );
        return; // Exit the function to prevent further processing
      }

      // Extract user data
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      // Check if all required fields are non-null
      List<String> requiredFields = [
        'address',
        'city',
        'email',
        'firstName',
        'governorate',
        'lastName',
        'phone',
      ];
      bool allFieldsFilled =
          requiredFields.every((field) => userData[field] != null);

      if (!allFieldsFilled) {
        // If any required field is null, show alert to update the profile
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('الملف الشخصي غير مكتمل'),
              content: Text('يرجى إكمال معلومات ملفك الشخصي قبل تقديم الطلب.'),
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
            );
          },
        );
        return; // Exit the function to prevent further processing
      }

      // Retrieve user's role
      DocumentSnapshot userRoleSnapshot =
          await _firestore.collection('Roles').doc(currentUserEmail).get();
      String userRole = userRoleSnapshot['role'];

      // Save data to Firestore
      await _firestore.collection('Request').doc(currentUserEmail).set({
        'Orders': 'Welcome',
        'role': userRole, // Add more fields as needed
      });

      // Check the number of documents in the "Items" subcollection
      QuerySnapshot itemsSnapshot = await _firestore
          .collection('Request')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .collection('Items')
          .get();
      int itemCount = itemsSnapshot.docs.length;

      // Save items in a subcollection named "Items"
      await _firestore
          .collection('Request')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .collection('Items')
          .add({
        'type': selectedType,
        'size': selectedSize,
        'governorate': selectedGovernorate,
        'city': selectedCity,
        'comments': notsController.text,
        'paymentMethod': paymentMethod,
        'totalPoints': totalPoints, // Add total points to Firestore
        'totalcash': totalcash,
        // Add more fields as needed
      });

      if (paymentMethod == 'Points') {
        // Update points in the Users collection
        final DocumentReference userRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUserEmail);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot userSnapshot = await transaction.get(userRef);

          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;

          int currentTotalPoints =
              userData.containsKey('totalPoints') ? userData['totalPoints'] : 0;

          transaction.update(userRef, {
            'totalPoints': currentTotalPoints + totalPoints,
          });
        });
        if (itemCount == 50) {
          try {
            int currentTotalPoints = userSnapshot.get('totalPoints');
            await _firestore.collection('Users').doc(currentUserEmail).update({
              'totalPoints': currentTotalPoints + totalPoints + 50,
            });
            await _firestore
                .collection('Notification')
                .doc(FirebaseAuth.instance.currentUser?.email)
                .set({
              'massege': 'لقد حصلت على 50 نقطة مقابل تقديم 50 طلبًا',
            });

            print('Points updated and notification sent successfully.');
          } catch (e) {
            print('Error updating points or sending notification: $e');
          }
        } else {
          await _firestore
              .collection("Notification")
              .doc(currentUserEmail)
              .set({
            'massege': 'سيصل إليك الممثل خلال يومين إلى ثلاثة أيام',
          });
        }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('تم اختيار طريقة الدفع'),
              content: Text('سوف نقوم بحساب النقاط وإضافتها إلى ملفك الشخصي.'),
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
      } else if (paymentMethod == 'Cash') {
        // Show message for cash payment
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('تم اختيار طريقة الدفع'),
              content: Text('سوف تتلقى الأموال مع الممثل.'),
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
    } catch (e) {
      print('Error sending request: $e');
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
