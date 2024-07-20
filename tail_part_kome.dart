import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TailPart extends StatelessWidget {
  const TailPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 45.0, top: 15),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('images/logo.png'))),
                    ),
                    Text(
                      'ريسبيكايا',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 100.0, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF79F21E),
                      ),
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("We will add it soon 🔜"),
                            ),
                          );
                        },
                        icon: FaIcon(FontAwesomeIcons.facebookF),
                        color: Colors.black,
                        iconSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF79F21E),
                      ),
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("We will add it soon 🔜"),
                            ),
                          );
                        },
                        icon: FaIcon(FontAwesomeIcons.twitter),
                        color: Colors.black,
                        iconSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF79F21E),
                      ),
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("We will add it soon 🔜"),
                            ),
                          );
                        },
                        icon: FaIcon(FontAwesomeIcons.linkedin),
                        color: Colors.black,
                        iconSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF79F21E),
                      ),
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("We will add it soon 🔜"),
                            ),
                          );
                        },
                        icon: FaIcon(FontAwesomeIcons.instagram),
                        color: Colors.black,
                        iconSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 35.0, top: 15),
                child: Text(
                  "روابط سريعة",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Product Sans",
                      fontSize: 20),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "خدمات",
                  style: TextStyle(color: Colors.black),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "مَلَفّ",
                  style: TextStyle(color: Colors.black),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "معلومات عنا",
                  style: TextStyle(color: Colors.black),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "اتصل بنا",
                  style: TextStyle(color: Colors.black),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 100.0, top: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 100.0),
                  child: Text(
                    "عنوان",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Product Sans",
                        fontSize: 20),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "المكتب الرئيسي لوكالة التصميم.\nطريق المطار\nالامارات العربية المتحدة",
                  textDirection: TextDirection.rtl,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
