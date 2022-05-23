import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/Chat/user_chat_screen.dart';
import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/src/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_screen.dart';

class AcceptedRequest extends StatefulWidget {
  @override
  _AcceptedRequestState createState() => _AcceptedRequestState();
}

class _AcceptedRequestState extends State<AcceptedRequest> {
  dynamic a = 1;

  // void initState() {
  //   FirebaseFirestore.instance
  //       .collection('User')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       FirebaseFirestore.instance
  //           .collection('User')
  //           .doc("${doc.id}")
  //           .collection("Request")
  //           .get()
  //           .then((QuerySnapshot querySnapshot) {
  //         querySnapshot.docs.forEach((doc) {
  //           print(doc["Latitude"]);
  //         });
  //       });
  //       // print(doc["Name"]);
  //     });
  //   });
  //   super.initState();
  // }
  // getValue(String Uid) async {
  //   var value;
  //   var collection = FirebaseFirestore.instance.collection('User');
  //   var docSnapshot =
  //   await collection.doc(Uid).get();
  //   if (docSnapshot.exists) {
  //     Map<String, dynamic>? data = docSnapshot.data();
  //     value = data?['Image'];
  //     // <-- The value you want to retrieve.
  //     // Call setState if needed.
  //
  //   }
  //   imgUrl=value;
  //   print("imageeeeeeeeeeeeeee urllllllllllllll isssssssssss $imgUrl");
  //   return value;
  //
  // }

  @override
  Widget build(BuildContext context) {
    // sizewidth = context
    //     .read<DetailScreenProvider>()
    //     .cart_width_icon(MediaQuery.of(context).size.width);
    // sizewidth = sizewidth / 2;
    // DetailScreenProvider detailScreenProvider =
    // Provider.of<DetailScreenProvider>(context);
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
          title: Text("Accepted Requests"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
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
                  stream: FirebaseFirestore.instance
                      .collection('User')
                      .doc("${document.id}")
                      .collection("Request")
                      .where("Status", isEqualTo: "assigned")
                      .snapshots(),
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
                        return InkWell(
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
                                  Text("Are You Sure You wanna mark request as complete"),
                                  actions: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.red,
                                        backgroundColor: Colors.red,
                                      ),
                                      child: Text(
                                        "YES",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        FirebaseFirestore.instance.collection('User')
                                            .doc(FirebaseAuth.instance.currentUser!.uid)
                                            .collection("Request")
                                            .doc(document.id)
                                            .update({"Status":"complete"}).then((value) => {
                                              Navigator.pop(context)
                                        });
                                        Navigator.pop(context);


                                      },
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.lightGreen,
                                        backgroundColor: Colors.lightGreen,
                                      ),
                                      child: Text(
                                        "NO",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
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
                                  height: 10,
                                ),
                                ListTile(
                                  leading: ClipOval(
                                    child: data["Worker_Img"]=="default"?Icon(

                                      Icons.person_pin,

                                      size: 40,
                                    ):Image.network(
                                      "${data['Worker_Img']}",
                                      height: 100,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(data['Worker_Name']),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "RS ${data['Price']}",
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                context
                                                    .read<
                                                        BottomNavigationProvider>()
                                                    .setWorkerUidandEmail(
                                                        data['Woker_Assigned']);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserChatScreen()));
                                              },
                                              child: Icon(
                                                Icons.message,
                                                color: Colors.green,
                                                size: 30,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 25,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                String number = "+923145223993";
                                                launch('tel://$number');
                                                await FlutterPhoneDirectCaller
                                                    .callNumber(number);
                                              },
                                              child: Icon(
                                                Icons.call,
                                                color: Colors.green,
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
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
        //bottomNavigationBar: BottomNavigationBarWorker(),
      ),
    );
  }
}
