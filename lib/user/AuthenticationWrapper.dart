import 'package:e_recycling/auth_screens_user/login.dart';
import 'package:e_recycling/auth_screens_user/register.dart';
import 'package:e_recycling/auth_screens_user/signinorregister.dart';
import 'package:e_recycling/firebase_service/worker%20vs%20user%20Home.dart';
import 'package:e_recycling/user/boarding_screen.dart';
import 'package:e_recycling/worker_side/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'home_screen.dart';

class AuthenticationWrapper extends StatelessWidget with ChangeNotifier{
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    notifyListeners();

    if (firebaseUser != null) {
      notifyListeners();
      return WorkerVsUserHomeScreen();

    }
    notifyListeners();
    return OnBoardingPage();

  }
}






