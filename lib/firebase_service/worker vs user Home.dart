import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:e_recycling/user/home_screen.dart';
import 'package:e_recycling/worker_side/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';


class WorkerVsUserHomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('User')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return Text("loading");
            default:
              if(snapshot.data!['Role']=='user'){

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => HomePage()),
                // );
                return HomePage();


              }
              if (snapshot.data!['Role'] == 'worker') {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => WorkerHomePage()),
                // );
                return WorkerHomePage();
              }
              return Text("Good");
          }



        },
      ),
    );
  }
}
