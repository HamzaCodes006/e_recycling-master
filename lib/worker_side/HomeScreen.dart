import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/Chat/worker_chat_screen.dart';
import 'package:e_recycling/firebase_auth/authentication_service.dart';
import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:e_recycling/provider/detail_screen_provider.dart';
import 'package:e_recycling/worker_side/request_detail_page.dart';
import 'package:e_recycling/worker_side/worker_side_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:url_launcher/url_launcher.dart';
import 'bottom_navigation_bar_worker.dart';

class WorkerHomePage extends StatefulWidget {
  @override
  _WorkerHomePageState createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('User').snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // context.read<WorkerSideProvider>().navBack(context);
        return false;
      },
      child: Scaffold(
        body: CustomScrollView(slivers: [
          Consumer<DetailScreenProvider>(
            builder: (context, notifier, child) => SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: notifier.responsive_detailPage_expandedHeight(
                    MediaQuery.of(context).size.height),
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    'images/b.png',
                    fit: BoxFit.cover,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.lightGreen,
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => HomePage()),
                    // );
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  InkWell(
                      onTap: () {
                        context.read<AuthenticationService>().signOut(context);
                      },
                      child: Icon(
                        Icons.logout,
                        color: Colors.white,
                      )),
                  SizedBox(width: 12),
                ]),
          ),
          buildImages(context),
        ]),
        bottomNavigationBar: BottomNavigationBarWorker(),
      ),
    );
  }

  Widget buildImages(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Text("SCHEDULE",
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 3,
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),
          ),
          StreamBuilder<QuerySnapshot>(
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
                padding: EdgeInsets.all(8),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> da =
                      document.data()! as Map<String, dynamic>;
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('User')
                        .doc("${document.id}")
                        .collection("Request")
                        .where("Woker_Assigned",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                        padding: EdgeInsets.all(0),
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          // var a= getValue(data["Uid"]);
                          // print("checkiiiinggg aaaaa isssss $imgUrl");
                          return data["Status"] == "assigned"
                              ? Card(
                                  child: Column(
                                    children: [
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      ListTile(
                                        leading: ClipOval(
                                          child: Image.network(
                                            "${data['User_Img']}",
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
                                            "${data['Distance']} Km "
                                            "\nRs ${data["Price"]}",
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
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      //print(data['Uid']);
                                                      context
                                                          .read<
                                                              BottomNavigationProvider>()
                                                          .setUserUidandEmail(
                                                              data['Uid']);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              WorkerChatScreen(),
                                                        ),
                                                      );
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
                                                      // String number =
                                                      //     "+92";
                                                     String number=data["User_Phone"];

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
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                )
                              : Container();
                        }).toList(),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
