import 'package:flutter/material.dart';
import 'package:gp_project/components/my_button.dart';
import 'package:gp_project/services/auth/auth)gete.dart';
import 'package:gp_project/widgets/divider.dart';
import 'package:gp_project/widgets/frist_part_hom.dart';
import 'package:gp_project/widgets/sec_part_home.dart';
import 'package:gp_project/widgets/tail_part_kome.dart';
import 'package:gp_project/widgets/thrd_part_home.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage('images/logo.png'))),
        ),
        title: Text(
          'ريسبيكايا',
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: "Marhey-Regular"),
        ),
        actions: [
          MyButton(
            width: 200,
            "تسجيل الدخول",
            ontap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthGete(),
                ),
              );
            },
            icon: Icons.login_outlined,
          )
        ],
      ),
      // Ensure MyAppbar is a valid widget
      body: SingleChildScrollView(
        child: Column(
          children: [
            Frist(), // Ensure Frist is a valid widget
            ContainerWithImages(), // Ensure ContainerWithImages is a valid widget
            SizedBox(height: 20),
            MyDivider(titel: 'خدماتنا'), // Ensure MyDivider is a valid widget
            SizedBox(height: 20),
            Container(
              height: 400,
              color: Color(0xFFA0EB68),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ServiceCard(
                        image:
                            AssetImage('images/1_j9BnLsdm0LWdsDAcGU5tRA.jpg'),
                        name: 'كرتون',
                        description:
                            'يمكنك وضع كرتون بأي حجم وكمية واستبدالها بالنقاط أو النقود',
                      ),
                    ),
                    Expanded(
                      child: ServiceCard(
                        image: AssetImage(
                            'images/istockphoto-1166983428-612x612.jpg'),
                        name: 'بلاستيك',
                        description:
                            'يمكنك وضع زجاجات بأي حجم وكمية واستبدالها بالنقاط أو النقود',
                      ),
                    ),
                    Expanded(
                      child: ServiceCard(
                        image: AssetImage('images/10941_pe_cans_768022.jpg'),
                        name: 'علب',
                        description:
                            'يمكنك وضع علب بأي حجم وكمية واستبدالها بالنقاط أو النقود',
                      ),
                    ),
                    Expanded(
                      child: ServiceCard(
                        image: AssetImage('images/Shutterstock_1777304945.jpg'),
                        name: 'ورق',
                        description:
                            'يمكنك وضع ورق بأي حجم وكمية واستبداله بالنقاط أو النقود',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            MyDivider(titel: 'الشركاء'),
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
            TailPart(), // Ensure TailPart is a valid widget
          ],
        ),
      ),
    );
  }
}
