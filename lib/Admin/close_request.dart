import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/Admin/delete_worker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/bottom_navigation_provider.dart';

class AdminCloseRequest extends StatefulWidget {
  @override
  _AdminCloseRequestState createState() => _AdminCloseRequestState();
}

class _AdminCloseRequestState extends State<AdminCloseRequest> {
  @override
  Widget build(BuildContext context) {
    print(MediaQuery
        .of(context)
        .size
        .width);

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
                MaterialPageRoute(builder: (context) => ShowWorkers()),
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
                          onTap: () {
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
                                  Text(
                                      "Are You Sure You wanna mark request as complete"),
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
                                        FirebaseFirestore.instance.collection(
                                            'User')
                                            .doc('${data["Uid"]}')
                                            .collection("Request")
                                            .doc(document.id)
                                            .update({"Status": "complete"})
                                            .then((value) =>
                                        {
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
                                    child: data["Worker_Img"] == "default"
                                        ? Icon(

                                      Icons.person_pin,

                                      size: 40,
                                    )
                                        : Image.network(
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
