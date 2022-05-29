

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/auth_screens_user/login.dart';
import 'package:firebase_admin_sdk/firebase_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../firebase_auth/authentication_service.dart';
import 'close_request.dart';

class ShowWorkers extends StatefulWidget {
  @override
  _ShowWorkersState createState() => _ShowWorkersState();
}

class _ShowWorkersState extends State<ShowWorkers> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('User').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workers"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                //MyHeaderDrawer(),
                Container(
                  color: Colors.lightGreen[700],
                  width: double.infinity,
                  height: 200,
                  padding: EdgeInsets.only(top: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('images/male.png'),
                          ),
                        ),
                      ),
                      Text(
                        "Muhammad Hamza",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        "Admin",
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 15,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ShowWorkers()),
                            );
                          },
                          child: Row(
                            children: const [
                              Expanded(
                                child: Icon(
                                  Icons.person_pin,
                                  size: 20,
                                  //color: Colors.redAccent,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Delete Worker',
                                  style: TextStyle(
                                    //color: Colors.purple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AdminCloseRequest()),
                            );
                          },
                          child: Row(
                            children: const [
                              Expanded(
                                child: Icon(
                                  Icons.list_alt_outlined,
                                  size: 20,
                                  //color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Close Requests',
                                  style: TextStyle(
                                    //color: Colors.orange,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),



                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Icon(
                                Icons.logout,
                                size: 20,
                                //color: Colors.teal,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 3,
                              child: InkWell(
                                onTap: () async {
                                  await context.read<AuthenticationService>().signOut(context);

                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Login()),
                                  );

                                },
                                child: Text(
                                  'Log Out',
                                  style: TextStyle(
                                    //color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return data["Role"]=="worker"?
              InkWell(
                onTap: (){
                  showDialog(
                    context:
                    context,
                    builder:
                        (BuildContext
                    context) {
                      return AlertDialog(
                        title:
                        Text("Alert"),
                        content:
                        Text("Are You Sure You wanna delete this worker?"),
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.red,
                              backgroundColor: Colors.red,
                            ),
                            child: Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async{

                              //
                              // var credential = Credentials.applicationDefault();
                              //
                              // credential ??= await Credentials.login(clientId: '111006224756979874008',clientSecret: '55813c5387811eeab2d35e6bb5995a892b8d413b');
                              //
                              // //
                              // // var app=FirebaseAdmin.instance.initializeApp(
                              // //     AppOptions(
                              // //         credential: credential,
                              // //         projectId: 'e-recycling-43cd1')
                              // // );
                              // var app = FirebaseAdmin.instance.initializeApp(AppOptions(
                              //   credential: credential
                              // ));
                              //
                              //
                              // var v=await app.auth().deleteUser(document.id);
                             // FirebaseAdmin.instance.initializeApp().auth().deleteUser(document.id);
                              FirebaseAdmin.instance.app()?.auth().deleteUser(document.id);



                              //sendNotification(li, "user created request", "New Request created");
                              // context
                              //     .read<BottomNavigationProvider>()
                              //     .setCurrentIndex(0,context);
                              FirebaseFirestore.instance.collection('User').doc(document.id).delete();
                              //FirebaseAuth.instance.currentUser?.delete();
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.red,
                              backgroundColor: Colors.red,
                            ),
                            child: Text(
                              "No",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              //sendNotification(li, "user created request", "New Request created");
                              // context
                              //     .read<BottomNavigationProvider>()
                              //     .setCurrentIndex(0,context);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );


                },
                child: Card(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        leading: ClipOval(
                          child: data["Image"]=="default"?Icon(
                            Icons.person,
                            size: 40,
                          ):Image.network(
                            "${data['Image']}",
                            height: 100,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(data['Name']),
                        subtitle: Padding(
                          padding:
                          const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Role : Worker",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        isThreeLine: true,
                        trailing: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 40,
                              width: 90,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(
                                      Radius.circular(20))),
                              child: InkWell(
                                onTap: () async {
                                  String number =
                                      "+923145223993";
                                  launch('tel://$number');
                                  await FlutterPhoneDirectCaller
                                      .callNumber(number);
                                },
                                child: Icon(
                                  Icons.call,
                                  color: Colors.green,
                                  size: 30,
                                ),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ):Container();
            }).toList(),
          );
        },
      ),
    );
  }
}
