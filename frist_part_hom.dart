import 'package:flutter/material.dart';

class Frist extends StatelessWidget {
  const Frist({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 400,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "images/5215764.jpg",
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width / 2,
                  height: 395,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 80.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 140.0),
                              child: Text(
                                "مرحباً بكم في ريسبيكايا",
                                // textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 34,
                                  color: const Color.fromARGB(255, 15, 110, 18),
                                ),
                              ),
                            ),
                            SizedBox(height: 3),
                            Padding(
                              padding: const EdgeInsets.only(left: 140.0),
                              child: Text(
                                "وجهتك المثالية لإعادة التدوير!",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    letterSpacing: 1.5,
                                    fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "هل تساءلت يومًا عن الرحلة وراء كل زجاجة بلاستيكية تستخدمها؟\n رميها في سلة المهملات؟ أو كيف تتحول الصحف القديمة إلى صحف جديدة؟\n المنتجات؟ في ريبيكايا، نعتقد أن كل جهد في إعادة التدوير\n إن هذه العملية تحدث فرقًا هائلاً في مستقبل كوكبنا.",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
