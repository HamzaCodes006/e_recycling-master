import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class FirebaseService {
  void insertData(BuildContext context, String name, String email, String role,
      String phone, String tokenId) async {
    var db = FirebaseFirestore.instance.collection('User');

    print(
        "email from provider package isssssssssss  sssssssssss${context.read<BottomNavigationProvider>().role}");

    Map<String, dynamic> ourData = {
      "Name": "$name",
      "Email": "$email",
      "Role": "$role",
      "Image": "default",
      "Phone": "$phone",
      "Latitude": "default",
      "Longitutde": "default",
      "Distance": 1,
      "token_id": tokenId
    };
    Map<String, dynamic> myCart_Plastic = {
      "Name": "Plastic",
      "price": 22,
      "price_with_distance": 0,
      "Image": "images/bottle_image5.jpg",
      "weight": 0
    };
    Map<String, dynamic> myCart_Metal = {
      "Name": "Metal",
      "price": 22,
      "price_with_distance": 0,
      "Image": "images/metal.png",
      "weight": 0
    };
    Map<String, dynamic> myCart_Glass = {
      "Name": "Glass",
      "price": 22,
      "price_with_distance": 0,
      "Image": "images/glass_image3.jpg",
      "weight": 0
    };
    Map<String, dynamic> myCart_Organic = {
      "Name": "Organic",
      "price": 22,
      "price_with_distance": 0,
      "Image": "images/organic_icon.jpg",
      "weight": 0
    };
    Map<String, dynamic> myCart_Paper = {
      "Name": "Paper",
      "price": 22,
      "price_with_distance": 0,
      "Image": "images/paper.jpg",
      "weight": 0
    };
    Map<String, dynamic> myCart_Water = {
      "Name": "Water",
      "price": 30,
      "price_with_distance": 0,
      "Image": "images/pure water.png",
      "weight": 0
    };
    Map<String, dynamic> myCart_SwimmingPoolWater = {
      "Name": "SwimmingPoolWater",
      "price": 100,
      "price_with_distance": 0,
      "Image": "images/swimming_pool_water_icon.jpg",
      "weight": 0
    };
    Map<String, dynamic> myCart_GeneralPurposeWater = {
      "Name": "GeneralPurposeWater",
      "price": 50,
      "price_with_distance": 0,
      "Image": "images/general_purpose_water.jpg",
      "weight": 0
    };
    Map<String, dynamic> myCart_Mix = {
      "Name": "Mix",
      "price": 22,
      "price_with_distance": 0,
      "Image": "images/mix.jpg",
      "weight": 0
    };
    await db.doc(FirebaseAuth.instance.currentUser!.uid).set(ourData);
    var db_cart = FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Cart');
    await db_cart.doc("PLASTIC").set(myCart_Plastic);
    await db_cart.doc("METAL").set(myCart_Metal);
    await db_cart.doc("GLASS").set(myCart_Glass);
    await db_cart.doc("ORGANIC").set(myCart_Organic);
    await db_cart.doc("PAPER").set(myCart_Paper);
    await db_cart.doc("Water").set(myCart_Water);
    await db_cart.doc("SwimmingPoolWater").set(myCart_SwimmingPoolWater);
    await db_cart.doc("GeneralPurposeWater").set(myCart_GeneralPurposeWater);
    await db_cart.doc("Mix").set(myCart_Mix);

    print("value inserted successfully");
  }
}
// Try Now
