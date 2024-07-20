import 'package:flutter/material.dart';
import 'package:gp_project/model/product.dart';

class Shope extends ChangeNotifier {
  //list of  Medicine items in the restaurant
  final List<Product> _menu = [
    //antibiotics
    Product(
      name: "حواء اورزو 400 جرام",
      imageUrl: "images/shop/6224008559061-removebg-preview.png",
      price: 20,
    ),
    Product(
      name: "جل الاستحمام فا أكتيف سبورت – 250 مل",
      imageUrl: "images/shop/4015000624206-removebg-preview.png",
      price: 150,
    ),
    Product(
      name: "معكرونة سباغيتي على شكل نجمة - 1 كجم",
      imageUrl: "images/shop/6221022222407-removebg-preview.png",
      price: 150,
    ),
    Product(
      name: "مربى الفراولة فيتراك - 245 جرام",
      imageUrl: "images/shop/6221024008276-removebg-preview.png",
      price: 150,
    ),
    Product(
      name: "مربى الجزر فيتراك 340 جرام",
      imageUrl: "images/shop/6221024009488-removebg-preview.png",
      price: 150,
    ),
    Product(
      name: "شربات المانجو من فيتراك - 1 لتر",
      imageUrl: "images/shop/6221024120107-removebg-preview.png",
      price: 150,
    ),
    Product(
      name: "مربى التوت الأزرق من فيتراك 430 جرام",
      imageUrl: "images/shop/6221024992407-removebg-preview.png",
      price: 150,
    ),
    Product(
      name: "برسيل كلاسيك بلاك – 900 مل",
      imageUrl: "images/shop/6221143071014-removebg-preview.png",
      price: 150,
    ),
    Product(
      name: "جل الطاقة برائحة اللافندر - 1 لتر",
      imageUrl: "images/shop/6221143083604-removebg-preview.png",
      price: 150,
    ),
    Product(
      name: "جل الاستحمام لوكس ماجيكال بيوتي - 500 مل",
      imageUrl: "images/shop/6221155054746-removebg-preview.png",
      price: 50,
    ),
    Product(
      name: "سمن نباتي كريستالي 2.5 كجم",
      imageUrl: "images/shop/6222000503976-1-removebg-preview.png",
      price: 80,
    ),
    Product(
      name: "سكر الدوحة الأبيض 1 كيلو",
      imageUrl: "images/shop/ضحي-1-removebg-preview.png",
      price: 20,
    ),
    Product(
      name: "عسل ايزيس 250 جرام بنسبة زيادة 40%",
      imageUrl: "images/shop/6222003006252-removebg-preview.png",
      price: 25,
    ),
    Product(
      name: "زبدة جانا 1 كيلو",
      imageUrl: "images/shop/6223000263457-1-removebg-preview.png",
      price: 30,
    ),
    Product(
      name: "زيت سليت آباد 1 لتر",
      imageUrl: "images/shop/6223000263624-removebg-preview.png",
      price: 35,
    ),
    Product(
      name: "زيت الذرة عافية 1.6 لتر",
      imageUrl: "images/shop/6223000263648-1-removebg-preview.png",
      price: 30,
    ),
    Product(
      name: "زيت هنادي المخلوط 1 لتر",
      imageUrl: "images/shop/6223000263693-removebg-preview.png",
      price: 90,
    ),
    Product(
      name: "زيت الذرة الأردوازي 750 مل",
      imageUrl: "images/shop/6223000263778-removebg-preview.png",
      price: 100,
    ),
    Product(
      name: "سمن روابي 850 جرام",
      imageUrl: "images/shop/6223000263853-removebg-preview.png",
      price: 80,
    ),
    Product(
      name: "زيت حلوه 2.25 لتر",
      imageUrl: "images/shop/6223000264010-removebg-preview.png",
      price: 120,
    ),
    Product(
      name: "تايجر",
      imageUrl: "images/shop/71SWKLZMk7L.jpg",
      price: 15,
    ),
    Product(
      name: "بيج شبيس",
      imageUrl: "images/shop/images (1).jpeg",
      price: 30,
    ),
    Product(
      name: "المراعي",
      imageUrl: "images/shop/عصير-المراعي.png",
      price: 55,
    ),
    Product(
      name: "إيلانو",
      imageUrl: "images/shop/images.jpeg",
      price: 50,
    ),
    // Product(
    //   name: "",
    //   imageUrl: "images/shop/6223000762042-removebg-preview.png",
    //   price: 150,
    // ),
    // Product(
    //   name: "",
    //   imageUrl: "images/shop/6223001030409-removebg-preview.png",
    //   price: 150,
    // ),
    // Product(
    //   name: "",
    //   imageUrl: "images/shop/6223001086017-removebg-preview.png",
    //   price: 150,
    // ),
    // Product(
    //   name: "",
    //   imageUrl: "images/shop/6223001353478-1-removebg-preview.png",
    //   price: 150,
    // ),
    // Product(
    //   name: "",
    //   imageUrl: "images/shop/6223001353478-1-removebg-preview.png",
    //   price: 150,
    // ),
    // Product(
    //   name: "",
    //   imageUrl: "images/shop/6223001510833-removebg-preview.png",
    //   price: 150,
    // ),
  ];

  List<Product> get menu => _menu;

  String _formatPrice(double price) {
    return "point: $price";
  }

  List<Product> searchMedicine(String query) {
    // Convert the query to lowercase for case-insensitive search
    final String queryLower = query.toLowerCase();

    // Filter the _menu list based on whether the name contains the query
    List<Product> searchResult = _menu
        .where((product) => product.name.toLowerCase().contains(queryLower))
        .toList();

    // Sort the search result alphabetically by product name
    searchResult.sort((a, b) => a.name.compareTo(b.name));

    return searchResult;
  }
}
