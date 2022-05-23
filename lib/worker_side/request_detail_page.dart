import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/user/cart_screen.dart';
import 'package:e_recycling/worker_side/HomeScreen.dart';
import 'package:e_recycling/worker_side/worker_side_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

double hei=0;
double wid=0;
int total=0;
double lat=0;
double long=0;
class RequestDetail extends StatefulWidget {
  @override
  _RequestDetailState createState() => _RequestDetailState();
}

class _RequestDetailState extends State<RequestDetail> {
  final snackBar = SnackBar(
    content: const Text('Please Turn on Location'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  late GoogleMapController mapController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  dynamic a=1;
  double totalDist=0;
  double calculateDistance(double lat1,double lon1){
    double lat2=context.read<WorkerSideProvider>().userLat;
    double lon2=context.read<WorkerSideProvider>().userLong;

    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p))/2;
    totalDist=12742* asin(sqrt(a));
   total=totalDist.round();


    return   totalDist;
  }
  Marker marker = Marker(
    markerId: const MarkerId('default'),
  );
  Marker user_marker = Marker(
    markerId: const MarkerId('default2'),
  );
  var ic=Icon(
    Icons.pin_drop,
    color: Colors.red,
  );
  @override
  Widget build(BuildContext context) {
    hei=MediaQuery.of(context).size.height;
    wid=MediaQuery.of(context).size.width;
    print("worker sideeeeee imageeeee after getting issssssss ${context.read<WorkerSideProvider>().worker_img}");
    WorkerSideProvider workerSideProvider=Provider.of<WorkerSideProvider>(context);
    print(wid);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
            color: Colors.black,),

          onPressed: () {
            context.read<WorkerSideProvider>().navBack(context);

          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    height: hei/1.7,
                    width: wid,
                    color: Colors.orange,
                    child: Stack(
                      children: [
                        GoogleMap(

                          initialCameraPosition:
                          CameraPosition(target: LatLng(context.read<WorkerSideProvider>().userLat, context.read<WorkerSideProvider>().userLong), zoom: 15),
                          onMapCreated: _onMapCreated,
                          mapType: MapType.hybrid,
                          zoomControlsEnabled: false,
                          compassEnabled: true,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          markers: {
                            marker,
                            user_marker
                          },

                        ),

                        Positioned(
                          bottom: 50,
                          right: 10,
                          child: FloatingActionButton(onPressed: ()async {
                            a = await _determinePosition();
                            lat=a.latitude;
                            long=a.longitude;
                            var _newposition = CameraPosition(
                                target: LatLng(a.latitude, a.longitude), zoom: 15);
                            mapController.animateCamera(
                                CameraUpdate.newCameraPosition(_newposition));
                            setState(() {
                              double dist=calculateDistance(a.latitude, a.longitude);
                              print("total distance isss $dist");
                              _addMarker(a.latitude, a.longitude);
                            });

                          },
                            child: Icon(
                              Icons.pin_drop,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],

                    ),




                  ),
                  Container(
                    width: wid,
                    height: MediaQuery.of(context).size.height/3.333,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        //color: Colors.lightGreen,
                        color: Color(0xFFF1F3F4),
                        //color: Colors.blue,
                        boxShadow: [
                          BoxShadow(offset: Offset(0, -1), blurRadius: 1),
                        ]),
                    child: Column(
                      children: [
                  //       FloatingActionButton(onPressed: (){
                  //
                  //       },
                  //   child: Icon(
                  //   Icons.pin_drop,
                  //   color: Colors.red,
                  // ),
                  //       ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(8,20,0,0),
                          child: Container(
                            child: Text('Distance from you = $total Km',
                              style: TextStyle(
                                  fontSize: hei/44.78
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: hei/50.7,
                        ),
                        SizedBox(
                          height: hei/14.22,
                          width: wid/1.44,

                          child: ElevatedButton(


                              onPressed: () async {
                                print("document iddddddddddd isssss ${context.read<WorkerSideProvider>().document_id}");
                                String  name="";
                                var img;
                                var collection = FirebaseFirestore.instance.collection('User');
                                var docSnapshot =
                                    await collection.doc(FirebaseAuth.instance.currentUser!.uid)
                                        .get();
                                if (docSnapshot.exists) {
                                  Map<String, dynamic>? data = docSnapshot.data();
                                  print(data?['Name']);
                                  name = data?['Name'];
                                  img=data?[Image];
                                  // <-- The value you want to retrieve.
                                  // Call setState if needed.
                                }
                                Map<String,dynamic> data={
                                 "Worker_Name":name,
                                  "Worker_Img":context.read<WorkerSideProvider>().worker_img,
                                  "Woker_Assigned":FirebaseAuth.instance.currentUser!.uid,
                                  "Status":"assigned",
                                  "work_lat":a.latitude,
                                  "work_long":a.longitude

                                };
                                FirebaseFirestore.instance.collection('User')
                                .doc(context.read<WorkerSideProvider>().userId)
                                 .collection('Request')
                                    .doc(context.read<WorkerSideProvider>().document_id)
                                    .update(data).then((value) => {

                                Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => WorkerHomePage()),
                                ),
                                context.read<WorkerSideProvider>().onItemTapped(0)

                                });




                              },
                              child: Text('Accept'),
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
                        SizedBox(
                          height: hei/60,
                        ),
                        SizedBox(
                          height: hei/14.22,
                          width: wid/1.44,
                          child: ElevatedButton(


                              onPressed: () {  },
                              child: Text('Decline'),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.white)
                                      )
                                  )
                              )

                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )


            ],
          ),
        ),
      ),

    );
  }
  // _addMarker(double lat, double long) {
  //   setState(() {
  //     marker = Marker(
  //       markerId: const MarkerId('origin'),
  //       infoWindow: const InfoWindow(title: 'Origin'),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  //       position: LatLng(33.858346850877666, 72.41525223734821),
  //     );
  //   });
  //   ic=Icon(
  //     Icons.four_g_mobiledata_outlined,
  //     color: Colors.red,
  //   );
  // }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      marker = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: LatLng(context.read<WorkerSideProvider>().userLat, context.read<WorkerSideProvider>().userLong),
      );
    });
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
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
  _addMarker(double lat, double long) {
    setState(() {

      user_marker = Marker(
        markerId: const MarkerId('origin1'),
        infoWindow: const InfoWindow(title: 'Origin1'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: LatLng(lat, long),
      );
    });
    ic=Icon(
      Icons.four_g_mobiledata_outlined,
      color: Colors.red,
    );
  }
}
