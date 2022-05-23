import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/user/choose_plastic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'distance.dart';
import 'distance_from_user.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({Key? key}) : super(key: key);

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  final snackBar = SnackBar(
    content: const Text('Please Turn on Location'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FireMap(),
    );
  }
}

class FireMap extends StatefulWidget {
  const FireMap({Key? key}) : super(key: key);

  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
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
  Marker marker = Marker(
    markerId: const MarkerId('default'),
  );
  var ic=Icon(
    Icons.pin_drop,
    color: Colors.red,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(24.142, -110.321), zoom: 15),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            mapType: MapType.hybrid,
            compassEnabled: true,
            markers: {
              marker,
            },
          ),

          Positioned(
              bottom: 50,
              right: 10,
              child: Column(
                children: [
                  FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.pin_drop,
                        color: Colors.red,
                      ),

                      onPressed: () async {

                        a = await _determinePosition();
                        var _newposition = CameraPosition(
                            target: LatLng(a.latitude, a.longitude), zoom: 15);
                        mapController.animateCamera(
                            CameraUpdate.newCameraPosition(_newposition));
                        setState(() {
                          _addMarker(a.latitude, a.longitude);
                        });
                        // await FirebaseFirestore.instance.collection('User')
                        // .doc(FirebaseAuth.instance.currentUser!.uid)
                        // .update({
                        //   'Latitude':"${a.latitude}",
                        //   'Longitutde':"${a.longitude}"
                        // });
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                      if(a==1){
                        _scaffoldKey.currentState!
                            .showSnackBar(SnackBar(content: Text("Please Select Location First")));
                      }
                      else{
                        await FirebaseFirestore.instance.collection('User')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({
                          'Latitude':"${a.latitude}",
                          'Longitutde':"${a.longitude}"
                        });


                      // var z=await CalDistance().calculateDistance();
                      // print("zzzzzzzzzzzzzzz isssssssssssssssssssssss $z");
                      // setState(() {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => DistanceInFireBase()),
                      //   );
                      // });

                      }


                  })
                ],
              ),
          ),

        ],

      ),
    );
  }

  _addMarker(double lat, double long) {
    setState(() {
      marker = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: LatLng(lat, long),
      );
    });
    ic=Icon(
      Icons.four_g_mobiledata_outlined,
      color: Colors.red,
    );
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
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
}
