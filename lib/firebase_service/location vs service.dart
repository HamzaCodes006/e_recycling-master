import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/location/distance_from_user.dart';
import 'package:e_recycling/location/user_location.dart';
import 'package:e_recycling/user/choose_plastic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LocationVsService extends StatefulWidget {
  const LocationVsService({Key? key}) : super(key: key);

  @override
  _LocationVsServiceState createState() => _LocationVsServiceState();
}

class _LocationVsServiceState extends State<LocationVsService> {
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
              if(snapshot.data!['Latitude']=='default' && snapshot.data!['Longitutde']=='default'){
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => GetLocation()),
                // );
                return GetLocation();


              }
              if (snapshot.data!['Latitude'] != 'default' && snapshot.data!['Longitutde']!='default') {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => DistanceInFireBase()),
                //
                // );

                return DistanceInFireBase();
              }
              return Text("Good");
          }



        },
      ),
    );
  }
}
