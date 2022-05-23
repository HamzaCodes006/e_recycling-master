import 'dart:async';
import 'dart:convert';

import 'package:e_recycling/payment/payment_ui.dart';
import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:e_recycling/provider/detail_screen_provider.dart';
import 'package:e_recycling/worker_side/worker_side_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';
import 'custom_animation.dart';
import 'home_screen.dart';
import 'package:http/http.dart';

double hei = 0;
double wid = 0;
double sizewidth = 0;
double tot = 0;
int dis = 0;
double entire = 0;
String user_image="";

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var payment_Method = "JazzCash";
  late Timer _timer2;
  int _start = 10;
  String phone="";
  String user_tokenId="";
  Timer? _timer;
  List<String> li = [];
  Future<Response> sendNotification(
      List<String> tokenIdList, String contents, String heading) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id":
        kAppId, //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids":
        tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF9976D2",

        "small_icon": "ic_stat_onesignal_default",

        "large_icon":
        "https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    );
  }
  void initState(){
    FirebaseFirestore.instance
        .collection('User')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
       if(doc['Role']=="worker"){
         li.add(doc["token_id"]);
       }
      });
    });
    super.initState();
  }

  void initstate() {

    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');

      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    //EasyLoading.showSuccess('Use in initState');
  }
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('User')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Cart')
      .where('weight', isGreaterThan: 0)
      .snapshots();

  updateValue() async{
    var uid = FirebaseAuth
        .instance.currentUser!.uid;
    var name, Latitude, Longtitude;
    var collection = FirebaseFirestore
        .instance
        .collection('User');
    var docSnapshot = await collection
        .doc(FirebaseAuth.instance
        .currentUser!.uid)
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data =
      docSnapshot.data();
      name = data?['Name'];
      Latitude = data?['Latitude'];
      Longtitude =
      data?['Longitutde'];
      user_image=data?['Image'];
      phone=data?['Phone'];
      user_tokenId=data?['token_id'];
      // <-- The value you want to retrieve.
      // Call setState if needed.
    }

    var car = FirebaseFirestore
        .instance
        .collection('User')
        .doc(FirebaseAuth.instance
        .currentUser!.uid)
        .collection('Cart');
    var doc = await car
        .doc("PLASTIC")
        .get();
    var plastic_wei,
        metal_wei,
        paper_wei,
        organic_wei,
        water_wei,
        mix_wei,
        glass_wei;
    if (doc.exists) {
      Map<String, dynamic>? data =
      doc.data();
      plastic_wei = data?["weight"];
    }
    var doc2 =
    await car.doc("GLASS").get();
    if (doc2.exists) {
      Map<String, dynamic>? data =
      doc2.data();
      glass_wei = data?["weight"];
    }
    var doc3 =
    await car.doc("METAL").get();
    if (doc3.exists) {
      Map<String, dynamic>? data =
      doc3.data();
      metal_wei = data?["weight"];
    }
    var doc4 =
    await car.doc("PAPER").get();
    if (doc4.exists) {
      Map<String, dynamic>? data =
      doc4.data();
      paper_wei = data?["weight"];
    }
    var doc5 = await car
        .doc("ORGANIC")
        .get();
    if (doc5.exists) {
      Map<String, dynamic>? data =
      doc5.data();
      organic_wei = data?["weight"];
    }

    Map<String, dynamic> request = {
      "Price": entire,
      "Distance": dis,
      "Woker_Assigned": "default",
      "Uid": "$uid",
      "Latitude": "$Latitude",
      "Longitude": "$Longtitude",
      "Name": "$name",
      "User_Img":user_image,
      "Plastic": plastic_wei,
      "Glass": glass_wei,
      "Metal": metal_wei,
      "Paper": paper_wei,
      "Organic": organic_wei,
      "Mix": "default",
      "Water": "default",
      "Worker_Name":"",
      "Worker_Img":"",
      "Payment_Status": "$payment_Method",
      "Points":2,
      "User_Phone":phone,
      "Worker_Phone":"",
      "User_tokenId":user_tokenId,
      "Status":"unassigned"
    };
    var db = FirebaseFirestore
        .instance
        .collection('User')
        .doc(FirebaseAuth.instance
        .currentUser!.uid)
        .collection('Request');

    db.add(request);

      FirebaseFirestore
          .instance
          .collection("User")
          .doc(FirebaseAuth
          .instance
          .currentUser!
          .uid)
          .collection("Cart")
          .doc("PLASTIC")
          .update({
        "weight": 0,
      });
      FirebaseFirestore
          .instance
          .collection("User")
          .doc(FirebaseAuth
          .instance
          .currentUser!
          .uid)
          .collection("Cart")
          .doc("GLASS")
          .update({
        "weight": 0,
      });
      FirebaseFirestore
          .instance
          .collection("User")
          .doc(FirebaseAuth
          .instance
          .currentUser!
          .uid)
          .collection("Cart")
          .doc("METAL")
          .update({
        "weight": 0,
      });
      FirebaseFirestore
          .instance
          .collection("User")
          .doc(FirebaseAuth
          .instance
          .currentUser!
          .uid)
          .collection("Cart")
          .doc("ORGANIC")
          .update({
        "weight": 0,
      });
      FirebaseFirestore
          .instance
          .collection("User")
          .doc(FirebaseAuth
          .instance
          .currentUser!
          .uid)
          .collection("Cart")
          .doc("PAPER")
          .update({
        "weight": 0,
      });
      FirebaseFirestore
          .instance
          .collection("User")
          .doc(FirebaseAuth
          .instance
          .currentUser!
          .uid)
          .update({
        "Latitude": "default",
        "Longitutde": "default",
        "Distance": 1
      });


    return "please do as expected pleaseeeeeee";
  }

  calPrice() async {
    var db = FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Total');
    double total = 0.0;
    double price_with_dis = 0;

    await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Cart')
        .where('price', isGreaterThan: 0)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("${doc['price']}");
        total = total + (doc['price'] * doc['weight']);
      });



      //return total;
    });
    var value;
    var collection = FirebaseFirestore.instance.collection('User');
    var docSnapshot =
        await collection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      value = data?['Distance'].round();
      // <-- The value you want to retrieve.
      // Call setState if needed.
    }
    print("distance isssssss exactly $value");

    setState(() {
      dis = value * 5;
      entire = tot + dis;
      tot = total;
    });

    Map<String, dynamic> total_of_cart = {
      "total": entire,
    };
    db
        .doc('total')
        .update(total_of_cart)
        .then((value) => print("value updated successfully as expected"));

    context.read<WorkerSideProvider>().updatePrice(entire);
    context.read<WorkerSideProvider>().updateDistance(value);

    print("price with distance is $dis");
  }

  @override
  Widget build(BuildContext context) {
    calPrice();
    sizewidth = context
        .read<DetailScreenProvider>()
        .cart_width_icon(MediaQuery.of(context).size.width);
    sizewidth = sizewidth / 2.3;
    DetailScreenProvider detailScreenProvider =
        Provider.of<DetailScreenProvider>(context);
    hei = MediaQuery.of(context).size.height;
    wid = MediaQuery.of(context).size.width;
    print(MediaQuery.of(context).size.width);
    return WillPopScope(
        onWillPop: () async {

          return false;
        },
        child: Scaffold(
          body: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
            Consumer<DetailScreenProvider>(
              builder: (context, notifier, child) => SliverAppBar(
                backgroundColor: Colors.white,

                expandedHeight: notifier.responsive_detailPage_expandedHeight(
                    MediaQuery.of(context).size.height),
                floating: true,
                pinned: true,

                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    'images/cart4.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () {
                    context
                        .read<BottomNavigationProvider>()
                        .navSelector(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => HomePage()),
                    // );
                  },
                ),
//           actions: [
//             Icon(Icons.settings),
//             SizedBox(width: 12),
//
// ]
              ),
            ),
            buildImages(context),
          ]),
        ));
  }

  Widget buildImages(BuildContext context) {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return Column(
              children: [
                Container(
                  // height: MediaQuery
                  //     .of(context)
                  //     .size
                  //     .height / 1.366,
                  // width: MediaQuery
                  //     .of(context)
                  //     .size
                  //     .width / 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      //color: Colors.lightGreen,
                      color: Color(0xFFF1F3F4),
                      boxShadow: [
                        BoxShadow(offset: Offset(0, -10), blurRadius: 25),
                      ]),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 40, 0, 0),
                      child: ListView(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Card(
                              color: Color(0xFFF1F3F4),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.lightGreen, width: 1),
                              ),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: Image.asset(
                                      data['Image'],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          //margin: EdgeInsets.only(right: 120),
                                          child: Text(
                                            "${data['weight']} Kg",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.lightGreen),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          width: wid / 6.923,
                                          child: Text(
                                            data['Name'],
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),

                                        // SizedBox(
                                        //   height: 20,
                                        // )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: sizewidth / 1.7),
                                  Container(
                                    // margin: EdgeInsets.only(right: 20),

                                    child: Column(
                                      children: [
                                        // SizedBox(
                                        //   height: 10,
                                        // ),
                                        Text(
                                          '${data['weight']} Kg = Rs ${data['price'] * data['weight']}',
                                          style: TextStyle(
                                              color: Colors.lightGreen,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "RS $dis",
                                          style: TextStyle(
                                              color: Colors.lightGreen,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        // Text("= Rs 420",
                                        //   style: TextStyle(
                                        //       color: Colors.lightGreen,
                                        //       fontWeight: FontWeight.bold),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: sizewidth / 1.2),
                                  InkWell(
                                    onTap: () async {
                                      String a = data['Name'];
                                      if(data['Name']=='GeneralPurposeWater' || data['Name']=="SwimmingPoolWater" || data["Name"]=='Water'){
                                        a=data['Name'];

                                      }
                                      else{
                                        a = a.toUpperCase();
                                      }

                                      FirebaseFirestore.instance
                                          .collection('User')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection('Cart')
                                          .doc(a)
                                          .get()
                                          .then((DocumentSnapshot
                                              documentSnapshot) {
                                        if (documentSnapshot.exists) {
                                          print(
                                              'Document exists on the database');
                                          FirebaseFirestore.instance
                                              .collection('User')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .collection('Cart')
                                              .doc(a)
                                              .update({'weight': 0})
                                              .then((value) =>
                                                  print("Value Updated"))
                                              .catchError((error) => print(
                                                  "Failed to update Value: $error"));
                                        } else {
                                          // print("${data['Name']}");
                                          //print(a);
                                          print(
                                              'Document does not exists on the database');
                                        }
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.delete_forever,
                                        color: Colors.lightGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 80,
                ),
                Container(
                  height: 230,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Color(0xFFF1F3F4),
                      boxShadow: [
                        BoxShadow(offset: Offset(0, -10), blurRadius: 20),
                      ]),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "SUB-TOTAL",
                              ),
                            ),
                            Container(
                                child: Text(
                              'Rs $tot',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                                // StreamBuilder<DocumentSnapshot>(
                                //     stream: FirebaseFirestore.instance
                                //     .collection('User')
                                // .doc(FirebaseAuth.instance.currentUser!.uid)
                                // .collection('Cart')
                                // .snapshots(),
                                //     builder: (BuildContext context,
                                //         AsyncSnapshot<DocumentSnapshot>
                                //             snapshot) {
                                //       if (snapshot.hasError) {
                                //         return Text('Something went wrong');
                                //       }
                                //
                                //       if (snapshot.connectionState ==
                                //           ConnectionState.waiting) {
                                //         return Text("Loading");
                                //       }
                                //       return Text(
                                //         "${snapshot.data!['total']} Rs",
                                //         style: TextStyle(
                                //           fontWeight: FontWeight.bold,
                                //           fontSize: 15,
                                //         ),
                                //       );
                                //     }),
                                )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "TAX",
                                style: TextStyle(),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Rs 0",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "Distance Price",
                              ),
                            ),
                            Container(
                              child: dis==5?Text("Rs 0",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ):
                              Text(
                                "Rs $dis",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "TOTAL",
                              ),
                              margin: EdgeInsets.only(left: 10),
                            ),
                            Container(
                              child: entire==5?
                                  Text("Rs 0",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ):
                              Text(
                                "Rs $entire",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: 100,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFF7FAD39),
                                ),
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      Color activeColor = Colors.white;
                                      Color inactiveColor = Colors.white;

                                      return AlertDialog(
                                        content: StatefulBuilder(
                                          // You need this, notice the parameters below:
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return Container(
                                              height: 250,
                                              width: 500,
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        activeColor =
                                                            Colors.deepPurple;
                                                        inactiveColor =
                                                            Colors.white;
                                                        payment_Method =
                                                            "JazzCash";
                                                      });
                                                    },
                                                    child: Card(
                                                      child: Container(
                                                        color: activeColor,
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              'images/JazzCash_logo.png',
                                                              height: 100,
                                                              width: 80,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                            SizedBox(
                                                              width: 7,
                                                            ),
                                                            Text(
                                                              "Pay with JazzCash",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        inactiveColor =
                                                            Colors.deepPurple;
                                                        activeColor =
                                                            Colors.white;
                                                        payment_Method = "Cash";
                                                      });
                                                    },
                                                    child: Card(
                                                      child: Container(
                                                        height: 100,
                                                        width: 300,
                                                        color: inactiveColor,
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              'images/cash.jpg',
                                                              height: 100,
                                                              width: 80,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              "On Arrival Payment",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Colors.red,
                                              backgroundColor: Colors.red,
                                            ),
                                            child: Text(
                                              "Proceed",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: ()  {
                                              setState((){
                                                if(payment_Method=="JazzCash"){
                                                  Navigator
                                                      .push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PaymentUI()),
                                                  );
                                                }
                                                else{
                                                  updateValue();
                                                  EasyLoading.show(status: "Creating request");
                                                  const oneSec = const Duration(seconds: 1);
                                                  _timer = new Timer.periodic(
                                                    oneSec,
                                                        (Timer timer) {
                                                      if (_start == 0) {
                                                        setState(() {
                                                          timer.cancel();
                                                          EasyLoading.showSuccess("Created");
                                                          EasyLoading.dismiss();
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
                                                                Text("Congratulations Your request have been generated with on cash payment"),
                                                                actions: [
                                                                  TextButton(
                                                                    style: TextButton.styleFrom(
                                                                      primary: Colors.red,
                                                                      backgroundColor: Colors.red,
                                                                    ),
                                                                    child: Text(
                                                                      "OK",
                                                                      style: TextStyle(color: Colors.white),
                                                                    ),
                                                                    onPressed: () {
                                                                      //sendNotification(li, "user created request", "New Request created");
                                                                      context
                                                                          .read<BottomNavigationProvider>()
                                                                          .setCurrentIndex(0,context);
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder: (context) => HomePage()),
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                          sendNotification(li, "User created request", "New Request created");
                                                          print("timer back to 0");
                                                        });
                                                      } else {
                                                        setState(() {
                                                          _start--;
                                                        });
                                                      }
                                                    },
                                                  );

                                                  //sendNotification(li, "User created request", "New Request created");

                                                }

                                                //print("$a"); //causing the issue neeed to solve
                                              });


                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  //await updateValue();
                                },
                                child: Text(
                                  'CHECK OUT',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
