// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp_project/components/my_button.dart';
import 'package:gp_project/components/my_textfilde.dart';
import 'package:gp_project/pages/Transactions.dart';
import 'package:gp_project/pages/busniss_request_page.dart';
import 'package:gp_project/pages/card_page.dart';
import 'package:gp_project/pages/contact_page.dart';
import 'package:gp_project/pages/home_page.dart';
import 'package:gp_project/pages/user_request_page.dart';
import 'package:gp_project/services/auth/auth_services.dart';
import 'package:gp_project/widgets/tail_part_kome.dart';
import 'shop_page.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController statController = TextEditingController();
  String? gfNameController;
  String? glNameController;
  String? gemailController;
  String? gaddressController;
  String? gphoneController;
  String? gcityController;
  String? gstatController;
  String? profileImage;
  String? points;
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

  String selectedGovernorate = 'أسيوط';

  String selectedCity = 'الحمامي';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(context),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser?.email)
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
                  }

                  // If no data exists, create a default user map
                  var user = snapshot.hasData && snapshot.data!.exists
                      ? snapshot.data!.data() as Map<String, dynamic>
                      : {
                          'totalPoints': 0,
                          'firstName': 'firstName',
                          'lastName': 'lastName',
                          'email': 'email',
                          'address': 'address',
                          'phone': 'phone',
                          'governorate': '',
                          'city': ''
                        };

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Icon(
                          Icons.person,
                          size: 150,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${user['totalPoints'] != null ? 'مجمل النقاط: ${user['totalPoints']}' : 'مجموع الأموال: ${user['total-money'] ?? "0"}'}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[300],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 81),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyTextFilde(
                            fNameController,
                            user['firstName'] ?? 'الاسم الأول',
                            false,
                            Icon(Icons.abc),
                            500,
                          ),
                          MyTextFilde(
                            lNameController,
                            user['lastName'] ?? 'اسم العائلة',
                            false,
                            Icon(Icons.abc),
                            500,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      MyTextFilde(
                        emailController,
                        user['email'] ?? 'بريد إلكتروني',
                        false,
                        Icon(Icons.email),
                        1050,
                      ),
                      SizedBox(height: 16.0),
                      MyTextFilde(
                        addressController,
                        user['address'] ?? 'عنوان',
                        false,
                        Icon(Icons.location_on_outlined),
                        1050,
                      ),
                      SizedBox(height: 32.0),
                      MyTextFilde(
                        phoneController,
                        user['phone'] ?? 'هاتف',
                        false,
                        Icon(Icons.phone),
                        1050,
                      ),
                      SizedBox(height: 32.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 500,
                            child: DropdownButtonFormField<String>(
                              value: selectedGovernorate,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: user['governorate'] ?? 'محافظة',
                                prefixIcon: Icon(Icons.location_city),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedGovernorate = value!;
                                  selectedCity =
                                      cities[selectedGovernorate]![0];
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
                          SizedBox(width: 40),
                          Container(
                            width: 500,
                            child: DropdownButtonFormField<String>(
                              value: selectedCity,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: user['city'] ?? "مدينة",
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
                      SizedBox(height: 50),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Roles')
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(); // Return an empty container while loading
                            } else {
                              if (snapshot.hasError) {
                                return Container(); // Return an empty container on error
                              } else {
                                final role = snapshot.data?.get('role') ?? '';
                                if (role == 'Business') {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MyButton('تحديث',
                                          ontap: updateProfile, width: 200),
                                      MyButton(
                                        'السجل',
                                        ontap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TransactionsPage(),
                                            ),
                                          );
                                        },
                                        width: 200,
                                      ),
                                      SizedBox(width: 20),
                                      MyButton('حفظ',
                                          ontap: saveProfile, width: 200),
                                    ],
                                  );
                                } else {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MyButton('حفظ',
                                          ontap: saveProfile, width: 200),
                                      SizedBox(width: 20),
                                      MyButton('تحديث',
                                          ontap: updateProfile, width: 200),
                                    ],
                                  );
                                }
                              }
                            }
                          }),
                      SizedBox(height: 100),
                      TailPart(),
                    ],
                  );
                })),
      ),
    );
  }

  void saveProfile() async {
    try {
      // Check that all required fields are not empty
      if (fNameController.text.isEmpty ||
          lNameController.text.isEmpty ||
          emailController.text.isEmpty ||
          addressController.text.isEmpty ||
          phoneController.text.isEmpty ||
          selectedCity == null ||
          selectedGovernorate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('يرجى ملء جميع الحقول')),
        );
        return;
      }

      // Validate phone number
      String phoneNumber = phoneController.text;
      if (phoneNumber.length != 11) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('يجب أن يكون رقم الهاتف مكونًا من 11 رقمًا')),
        );
        return;
      }
      String phonePrefix = phoneNumber.substring(0, 3);
      if (phonePrefix != '010' &&
          phonePrefix != '011' &&
          phonePrefix != '012' &&
          phonePrefix != '015') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('بداية رقم الهاتف غير صالحة')),
        );
        return;
      }

      // Validate email format and domain
      final emailPattern =
          RegExp(r'^[\w-\.]+@(gmail\.com|outlook\.com|hotmail\.com)$');
      if (!emailPattern.hasMatch(emailController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تنسيق البريد الإلكتروني أو المجال غير صالح')),
        );
        return;
      }

      // Update user profile data in Firestore
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDocRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email);
        final userDoc = await userDocRef.get();
        final userData =
            userDoc.exists ? userDoc.data() as Map<String, dynamic> : {};

        // Merge existing data with new data
        final newData = {
          'firstName': fNameController.text,
          'lastName': lNameController.text,
          'email': emailController.text,
          'address': addressController.text,
          'phone': phoneController.text,
          'city': selectedCity,
          'governorate': selectedGovernorate,
          // 'profileImageUrl': imageUrl,
          // Add more fields as needed
        };

        // Explicitly cast dynamic maps to maps with string keys
        final Map<String, dynamic> mergedData =
            Map<String, dynamic>.from(userData)..addAll(newData);

        // Update document in Firestore
        await userDocRef.set(mergedData);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('تم حفظ الملف الشخصي')));
        emailController.clear();
        fNameController.clear();
        lNameController.clear();
        addressController.clear();
        phoneController.clear();
      }
    } catch (e) {
      print('Error saving profile: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('فشل في حفظ الملف الشخصي')));
    }
  }

  void updateProfile() async {
    try {
      // Validate phone number if it has been changed
      String? phoneNumber;
      if (phoneController.text.isNotEmpty) {
        phoneNumber = phoneController.text;
        if (phoneNumber.length != 11) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('يجب أن يكون رقم الهاتف مكونًا من 11 رقمًا')),
          );
          return;
        }
        String phonePrefix = phoneNumber.substring(0, 3);
        if (phonePrefix != '010' &&
            phonePrefix != '011' &&
            phonePrefix != '012' &&
            phonePrefix != '015') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('بداية رقم الهاتف غير صالحة')),
          );
          return;
        }
      }

      // Validate email format and domain if it has been changed
      String? email;
      if (emailController.text.isNotEmpty) {
        email = emailController.text;
        final emailPattern =
            RegExp(r'^[\w-\.]+@(gmail\.com|outlook\.com|hotmail\.com)$');
        if (!emailPattern.hasMatch(email)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('تنسيق البريد الإلكتروني أو المجال غير صالح')),
          );
          return;
        }
      }

      // Update user profile data in Firestore
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDocRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email);
        final userDoc = await userDocRef.get();
        final userData =
            userDoc.exists ? userDoc.data() as Map<String, dynamic> : {};

        // Create a map to hold the new data
        final Map<String, dynamic> newData = {};

        if (fNameController.text.isNotEmpty) {
          newData['firstName'] = fNameController.text;
        }
        if (lNameController.text.isNotEmpty) {
          newData['lastName'] = lNameController.text;
        }
        if (email != null) {
          newData['email'] = email;
        }
        if (addressController.text.isNotEmpty) {
          newData['address'] = addressController.text;
        }
        if (phoneNumber != null) {
          newData['phone'] = phoneNumber;
        }
        if (selectedCity != null) {
          newData['city'] = selectedCity;
        }
        if (selectedGovernorate != null) {
          newData['governorate'] = selectedGovernorate;
        }
        newData['lastUpdated'] = FieldValue.serverTimestamp();

        // Explicitly cast dynamic maps to maps with string keys
        final Map<String, dynamic> mergedData =
            Map<String, dynamic>.from(userData)..addAll(newData);

        // Update document in Firestore
        await userDocRef.set(mergedData);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('تم تجديث الملف الشخصي')));
        emailController.clear();
        fNameController.clear();
        lNameController.clear();
        addressController.clear();
        phoneController.clear();
      }
    } catch (e) {
      print('Error saving profile: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('فشل في تحديث الملف الشخصي')));
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
