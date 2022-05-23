import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:e_recycling/provider/detail_screen_provider.dart';
import 'package:e_recycling/worker_side/HomeScreen.dart';
import 'package:e_recycling/worker_side/request_detail_page.dart';
import 'package:e_recycling/worker_side/worker_side_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'bottom_navigation_bar_worker.dart';

double sizewidth = 0;
String imgUrl="";

class Requests extends StatefulWidget {
  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  dynamic a=1;
  void initState() {
    FirebaseFirestore.instance
        .collection('User')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        FirebaseFirestore.instance
            .collection('User')
            .doc("${doc.id}")
            .collection("Request")
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            print(doc["Latitude"]);
          });
        });
        // print(doc["Name"]);
      });
    });
    super.initState();
  }
  getValue(String Uid) async {
    var value;
    var collection = FirebaseFirestore.instance.collection('User');
    var docSnapshot =
        await collection.doc(Uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      value = data?['Image'];
      // <-- The value you want to retrieve.
      // Call setState if needed.

    }
    imgUrl=value;
    print("imageeeeeeeeeeeeeee urllllllllllllll isssssssssss $imgUrl");
    return value;

  }

  @override
  Widget build(BuildContext context) {
    sizewidth = context
        .read<DetailScreenProvider>()
        .cart_width_icon(MediaQuery.of(context).size.width);
    sizewidth = sizewidth / 2;
    DetailScreenProvider detailScreenProvider =
        Provider.of<DetailScreenProvider>(context);
    print(MediaQuery.of(context).size.width);

    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('User').snapshots();

    return WillPopScope(
      onWillPop: () async {

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text("Requests"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              context.read<WorkerSideProvider>().onItemTapped(0);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WorkerHomePage()),
              );
            },
          ),
        ),

        body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> da =
                    document.data()! as Map<String, dynamic>;
                return StreamBuilder<QuerySnapshot>(
                  stream:FirebaseFirestore.instance.collection('User').doc("${document.id}").collection("Request").where("Status",isEqualTo:"unassigned" ).snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return ListView(
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {

                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                     // var a= getValue(data["Uid"]);
                     // print("checkiiiinggg aaaaa isssss $imgUrl");
                        return Card(
                          child:Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              ListTile(
                                leading: ClipOval(

                                  child: data["User_Img"]=="default"?Icon(
                                    Icons.person_pin
                                  ):Image.network("${data['User_Img']}",
                                    height: 100,
                                    width: 50,
                                    fit: BoxFit.cover,

                                  ),

                                ),
                                title: Text(data['Name']),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text("${data['Distance']} Km "
                                      "\nRs ${data["Price"]}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                ),
                                isThreeLine: true,
                                trailing: SizedBox(
                                  height: MediaQuery.of(context).size.height/20.76,
                                  width: MediaQuery.of(context).size.width/3.22,


                                  child: ElevatedButton(


                                      onPressed: ()async {
                                        var a=document.id;
                                        print("document id issssss $a");
                                        context.read<WorkerSideProvider>().setUserId(data['Uid']);
                                        var b= await getValue(FirebaseAuth.instance.currentUser!.uid);
                                        print("image urllll of workerrrr issssss $b");
                                        context.read<WorkerSideProvider>().setWorkerImg(b);

                                        context.read<WorkerSideProvider>().setDocumentId(a);

                                        context.read<WorkerSideProvider>().getLoc(data['Latitude'], data['Longitude']);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => RequestDetail()),
                                        );
                                      },
                                      child: Text('View'),
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(18.0),
                                                  side: BorderSide(color: Colors.white)
                                              )
                                          )
                                      )

                                  ),
                                ),




                              ),

                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),


                        );
                      }).toList(),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBarWorker(),
      ),
    );
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
