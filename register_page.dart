import 'package:flutter/material.dart';
import 'package:gp_project/components/my_button.dart';
import 'package:gp_project/components/my_textfilde.dart';
import 'package:gp_project/pages/home_page.dart';
import 'package:gp_project/pages/login_page.dart';
import 'package:gp_project/services/auth/auth_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  String? role;

  String? validateEmail(String value) {
    String pattern = r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'أدخل عنوان بريد إلكتروني صالح';
    }

    List<String> emailParts = value.split('@');
    String domain = emailParts[1];
    List<String> domainParts = domain.split('.');
    if (domainParts.length < 2 || domainParts.last.length < 2) {
      return 'أدخل عنوان بريد إلكتروني صالح';
    }

    if (domain != 'gmail.com' &&
        domain != 'yahoo.com' &&
        domain != 'outlook.com' &&
        domain != 'icloud.com') {
      return 'مسموح فقط بـ gmail.com، وyahoo.com، وicloud.com، وoutlook.com!';
    }

    return null;
  }

  String? validatePassword(String value) {
    if (value.length < 8 || !value.contains(RegExp(r'[a-zA-Z]'))) {
      return 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل وتحتوي على حرف واحد على الأقل.';
    }
    return null;
  }

  void register() async {
    final authService = AuthServices();
    final String? emailError = validateEmail(emailController.text);
    final String? passwordError = validatePassword(passwordController.text);

    if (role == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "الرجاء اختيار دورك",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      );
      return;
    }

    if (emailError != null || passwordError != null) {
      String errorMessage = emailError ?? '';
      if (passwordError != null) {
        errorMessage += '\n' + passwordError;
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            errorMessage,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      );
      return;
    }
    try {
      await authService.signupWithEmailPassword(
        emailController.text,
        passwordController.text,
        role!,
      );

      // Navigate to home page after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomePage(), // Replace HomePage with your actual home page widget
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              'images/signup.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: role == "Business"
                                ? MaterialStateProperty.all(Colors.green)
                                : MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () {
                            setState(() {
                              role = "Business";
                            });
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.admin_panel_settings_rounded,
                                  size: 50,
                                ),
                                Text(
                                  "عمل",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: role == "User"
                                ? MaterialStateProperty.all(Colors.green)
                                : MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () {
                            setState(() {
                              role = "User";
                            });
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.person_2_rounded,
                                  size: 50,
                                ),
                                Text(
                                  "مستخدم",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "تسجيل",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    MyTextFilde(
                      nameController,
                      "أدخل الاسم الكامل",
                      false,
                      labelText: 'الاسم الكامل',
                      Icon(
                        Icons.abc_rounded,
                        color: Colors.black,
                      ),
                      500,
                    ),
                    SizedBox(height: 15),
                    MyTextFilde(
                      emailController,
                      "أدخل البريد الإلكتروني",
                      false,
                      labelText: 'بريد إلكتروني',
                      Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                      ),
                      500,
                    ),
                    SizedBox(height: 15),
                    MyTextFilde(
                      passwordController,
                      "أدخل كلمة المرور",
                      true,
                      labelText: 'كلمة المرور',
                      Icon(
                        Icons.key_rounded,
                        color: Colors.black,
                      ),
                      500,
                    ),
                    SizedBox(height: 25),
                    MyButton(
                      ontap: register,
                      "تسجيل",
                      icon: Icons.login,
                      width: 250,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            "تسجيل الدخول الآن",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "عضوا فعلا؟",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
