import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_project/components/my_button.dart';
import 'package:gp_project/components/my_textfilde.dart';
import 'package:gp_project/pages/register_page.dart';
import 'package:gp_project/pages/welcome_page.dart';
import 'package:gp_project/services/auth/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  String? rool;

  void login() async {
    final _authService = AuthServices();
    try {
      await _authService.signinWithEmailPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      String errorMessage = "كلمة المرور أو البريد الإلكتروني غير صحيح";
      if (e is FirebaseAuthException) {
        if (e.code == "wrong-password") {
          errorMessage = "كلمة سر خاطئة.";
        }
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(errorMessage),
        ),
      );
    }
  }

  void forgotpw() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text("User tapped forgot password"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomePage(),
                  ));
            },
            icon: Icon(Icons.home)),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              'images/login.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 25,
                ),
                //email
                MyTextFilde(
                    emailController,
                    "ادخل اسم المستخدم",
                    false,
                    labelText: 'اسم المستخدم',
                    Icon(
                      Icons.email_outlined,
                      color: Colors.black,
                    ),
                    500),
                SizedBox(height: 15),
                //password
                MyTextFilde(
                    passwordController,
                    "أدخل كلمة المرور",
                    true,
                    labelText: ' كلمة المرور',
                    Icon(
                      Icons.key_rounded,
                      color: Colors.black,
                    ),
                    500),
                SizedBox(height: 25),
                //sing in
                MyButton(
                  ontap: login,
                  "تسجيل الدخول",
                  icon: Icons.login,
                  width: 250,
                ),
                SizedBox(height: 8),
                //sing up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ));
                      },
                      child: Text(
                        "سجل الان",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "ليس عضوا؟",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
