import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/user/cart_screen.dart';
import 'package:e_recycling/user/choose_plastic.dart';
import 'package:e_recycling/user/home_screen.dart';
import 'package:e_recycling/user/pricing_screen.dart';
import 'package:e_recycling/user/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int _currentindex = 0;
  int _previousindex = 0;
  String _workerEmail = '';
  String _workerUid = '';
  String _userEmail = '';
  String _userUid = '';
  String _role = "null";
  String _name = "";
  String _email = "";

  String get workerEmail => _workerEmail;
  String get workerUid => _workerUid;
  String get userEmail => _userEmail;
  String get userUid => _userUid;

  var collection = FirebaseFirestore.instance.collection('User');

  setWorkerUidandEmail(String Uid) async {
    _workerUid = Uid;
    var docSnapshot = await collection.doc(Uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      _workerEmail = data?['Email'];
    }
    notifyListeners();
  }

  setUserUidandEmail(String Uid) async {
    _userUid = Uid;
    var docSnapshot = await collection.doc(Uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      _userEmail = data?['Email'];
    }
    notifyListeners();
  }

  int get currentIndex => _currentindex;
  YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: 'dron6aW4UKk&ab',
      params: YoutubePlayerParams(
        playlist: ['dron6aW4UKk&ab', 'dron6aW4UKk'], // Defining custom playlist
        startAt: Duration(seconds: 1),
        showControls: true,
        showFullscreenButton: true,
      ));
  int get previousindex => _previousindex;

  String get role => _role;
  String get name => _name;
  String get email => _email;
  setrole(String userRole) {
    _role = userRole;
    notifyListeners();
  }

  setuserName(String username) {
    _name = username;
    notifyListeners();
  }

  setuserEmail(String email) {
    _email = email;
    notifyListeners();
  }

  intilizeController() {
    _controller = YoutubePlayerController(
      initialVideoId: 'dron6aW4UKk&ab',
      params: YoutubePlayerParams(
        playlist: ['dron6aW4UKk&ab', 'dron6aW4UKk'], // Defining custom playlist
        startAt: Duration(seconds: 1),
        showControls: true,
        showFullscreenButton: true,
        enableCaption: true,
      ),
    );
    print("controller intilized succesfully \n");
    //notifyListeners();
  }

  YoutubePlayerController get controller => _controller;

  decideSpinnerOrVideo() {
    // if(controller.value.isReady){
    //   YoutubePlayerControllerProvider(
    //     // Provides controller to all the widget below it.
    //     controller: _controller,
    //     child: YoutubePlayerIFrame(
    //       aspectRatio: 16 / 9,
    //     ),
    //
    //   );
    //   //notifyListeners();
    // }
    // else{
    //   Container(
    //     height: 50,
    //     width: 50,
    //     child: CircularProgressIndicator(),
    //   );
    //   //notifyListeners();
    // }
    YoutubePlayerControllerProvider(
      // Provides controller to all the widget below it.
      controller: _controller,
      child: YoutubePlayerIFrame(
        aspectRatio: 16 / 9,
      ),
    );
    print("entered in decide spinner or video \n");
  }

  setCotrollervalue() {
    _controller.stop();
    notifyListeners();
  }

  closeController() {
    _controller.close();
    notifyListeners();
  }

  setCurrentIndex(int index, BuildContext context) {
    //_previousindex=index-1;
    _currentindex = index;
    if (_currentindex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }

    if (_currentindex == 1) {
      //notifyListeners();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PricingScreen()),
      );
    }
    if (_currentindex == 2) {
      //notifyListeners();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartScreen()),
      );
    }
    if (_currentindex == 3) {
      //notifyListeners();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Profile()),
      );
    }
    notifyListeners();
  }

  navSelector(BuildContext context) {
    _currentindex = 0;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );

    notifyListeners();
  }
}
