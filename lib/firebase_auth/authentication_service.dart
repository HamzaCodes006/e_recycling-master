import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/auth_screens_user/login.dart';
import 'package:e_recycling/auth_screens_user/register.dart';
import 'package:e_recycling/firebase_service/choose_between.dart';
import 'package:e_recycling/firebase_service/firebase_service.dart';
import 'package:e_recycling/firebase_service/worker%20vs%20user%20Home.dart';
import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:e_recycling/user/AuthenticationWrapper.dart';
import 'package:e_recycling/user/home_screen.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class AuthenticationService  {
  final FirebaseAuth _firebaseAuth;


  AuthenticationService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();


  /// This won't pop routes so you could do something like
  /// Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  /// after you called this method if you want to pop all routes.
  Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );

  }




  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future<String?> signIn({required String email, required String password,required BuildContext context}) async {

    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WorkerVsUserHomeScreen()),
      );
      var status = await OneSignal.shared.getDeviceState();
      String? tokenId = status!.userId;
      FirebaseFirestore.instance.collection("User").doc(FirebaseAuth.instance.currentUser!.uid).update({"token_id":"$tokenId"});



      return "Signed in";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');}
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );

      return e.message;

    }
  }

  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future<String?> signUp({required name,required String email, required String password,required String phone,required BuildContext context}) async {
    try {
      var a = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      context.read<BottomNavigationProvider>().setuserEmail(email);
      context.read<BottomNavigationProvider>().setuserName(name);
      var status = await OneSignal.shared.getDeviceState();
      String? tokenId = status!.userId;

      FirebaseService().insertData(context,name,email,context.read<BottomNavigationProvider>().role,phone,tokenId!);


      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => ChooseBetween()),
      // );

      return "Signed up";

    } on FirebaseAuthException catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Register()),
      );

      return e.message;
    }
  }

}
