import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/payment/payment_repository.dart';
import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:e_recycling/user/custom_animation.dart';
import 'package:e_recycling/user/home_screen.dart';
import 'package:e_recycling/worker_side/worker_side_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:provider/src/provider.dart';

import '../main.dart';


String user_image="";

class PaymentUI extends StatefulWidget {
  const PaymentUI({Key? key}) : super(key: key);

  @override
  _PaymentUIState createState() => _PaymentUIState();
}

class _PaymentUIState extends State<PaymentUI> {
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController Cinic = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String phone="";
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
  Timer? _timer;
  List<String> li = [];
  String user_tokenId="";
  late Timer _timer2;
  int _start = 10;
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

//   updateValue2() async{
//
//     FirebaseFirestore.instance.collection('User')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .update({"Latitude":"default"}).then((value) =>{
//           EasyLoading.showSuccess("Created");
//           EasyLoading.EasyLoadingStatus.dismiss
//     });
//
// }
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
      "Price": context.read<WorkerSideProvider>().price,
      "Distance": context.read<WorkerSideProvider>().distance,
      "Woker_Assigned": "default",
      "Uid": "$uid",
      "User_Img":user_image,
      "Latitude": "$Latitude",
      "Longitude": "$Longtitude",
      "Name": "$name",
      "Plastic": plastic_wei,
      "Glass": glass_wei,
      "Metal": metal_wei,
      "Paper": paper_wei,
      "Organic": organic_wei,
      "Mix": "default",
      "Water": "default",
      "Worker_Name":"",
      "Worker_Img":"",
      "Payment_Status": "JazzCash",
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 100,
                width: 100,
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30,40,8,8),
                  child: Text("Pay",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 30, 20, 10),
                height: 450,
                width: 320,
                color: Color(0xFFFFFFFF),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text("Please Enter Mobile Account Details",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFAFAFAF),
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextField(
                        controller: phoneNumber,
                        keyboardType: TextInputType.number,
                        maxLength: 11,

                        decoration: InputDecoration(

                          labelText: 'Mobile Number',
                          hintText: 'Enter Your Account Number',

                            prefixIcon: Icon(Icons.phone,
                            color: Colors.red,

                            ),



                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextField(
                        maxLength: 6,
                        controller: Cinic,
                        keyboardType: TextInputType.number,

                        decoration: InputDecoration(

                          labelText: 'Last 6 digits of Cinic',
                          hintText: 'Cinic',
                            prefixIcon: Icon(Icons.person,
                            color: Colors.red,
                            )
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),

                    InkWell(
                      onTap: () async {
                        if(phoneNumber.text.trim().length==11 && Cinic.text.trim().length==6){
                          EasyLoading.show(status: "Creating request");
                          var a=await PaymentRepository().makeTransactionThroughMWallet(ppAmount: "${context.read<WorkerSideProvider>().price}", ppDescription: "", cnic: Cinic.text.trim(), mobileNumber: phoneNumber.text.trim());
                          print("staus code of response issssssssssssssssssssssss $a");
                          if(a=="200"){
                            updateValue();
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
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Alert"),
                                          content: Text("Congratulations Your request have been generated you will recieve notification soon"),
                                          actions: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                primary: Colors.red,
                                                backgroundColor: Colors.red,

                                              ),
                                              child: Text("OK",
                                                style: TextStyle(
                                                    color: Colors.white
                                                ),
                                              ),
                                              onPressed: () {
                                                sendNotification(li, "user created request", "New Request created");
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
                                    print("timer back to 0");
                                  });
                                } else {
                                  setState(() {
                                    _start--;
                                  });
                                }
                              },
                            );




                          }

                        }
                        else{
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Alert"),
                                content: Text("Jazz Cash payment Could Not be completed please try cash on delivery"),
                                actions: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.red,
                                      backgroundColor: Colors.red,

                                    ),
                                    child: Text("OK",
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
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
                          _scaffoldKey.currentState!
                              .showSnackBar(SnackBar(content: Text("Please Enter all fields correctly")));

                        }


                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(50)
                        ),
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Center(
                            child: Text(
                              'Pay',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white),
                            )),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
