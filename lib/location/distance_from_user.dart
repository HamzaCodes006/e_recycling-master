import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/provider/location_provider.dart';
import 'package:e_recycling/user/choose_plastic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import 'distance.dart';

class DistanceInFireBase extends StatefulWidget {
  const DistanceInFireBase({Key? key}) : super(key: key);

  @override
  _DistanceInFireBaseState createState() => _DistanceInFireBaseState();
}

class _DistanceInFireBaseState extends State<DistanceInFireBase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  StreamBuilder<DocumentSnapshot>(
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
              if(snapshot.data!["Distance"]==1){
                String lat=snapshot.data!['Latitude'];
                double lat1=double.parse(lat);
                String long=snapshot.data!['Longitutde'];
                double lon1=double.parse(long);

                var a=CalDistance().calculateDistance(lat1,lon1);
                print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa is $a");

                  FirebaseFirestore.instance
                      .collection('User')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    'Distance': a
                  });


                return context.read<LocationProvider>().navToClassName(context);




              }
              else{
                return context.read<LocationProvider>().navToClassName(context); //this is the most imp part here class name decides which class to go

              }

              return Text("Good");
          }



        },
      ),
    );
  }


}
