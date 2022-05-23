import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowWorkers extends StatefulWidget {
  @override
  _ShowWorkersState createState() => _ShowWorkersState();
}

class _ShowWorkersState extends State<ShowWorkers> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('User').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  FirebaseAuth.instance.currentUser?.delete();

                },
                child: Card(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        leading: ClipOval(
                          child: Image.network(
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
