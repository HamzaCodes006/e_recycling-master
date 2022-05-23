import 'package:e_recycling/firebase_auth/authentication_service.dart';
import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:e_recycling/user/home_screen.dart';
import 'package:e_recycling/worker_side/HomeScreen.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController name = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool valid = false;
  double hei=0;

  @override
  Widget build(BuildContext context) {
    //TODO update what details you want
    //test feild state
    String email = "";
    String password = "";

    String city = "";
    String phonenumber = "";

   hei=MediaQuery.of(context).size.height;
   print(hei);

    //for showing loading
    bool loading = false;

    // this below line is used to make notification bar transparent
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    double  select_layout(var height){
    if(height<700){
      return 255;
    }
    else{
      return 290;
    }


    }

    return WillPopScope(
      onWillPop: () async {
        // context.read<WorkerSideProvider>().navBack(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Image.asset(
                //TODO update this
                'images/recycle_one.jpg',
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
              // Container(
              //   height: double.infinity,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //           begin: Alignment.bottomCenter,
              //           end: Alignment.topCenter,
              //           colors: [
              //             Colors.black.withOpacity(.9),
              //             Colors.black.withOpacity(.1),
              //           ])),
              // ),
              Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Text(
                      //   'Welcome',
                      //   style: TextStyle(
                      //     fontSize: 27.0,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 4,
                      // ),
                      // Text(
                      //   //TODO update this
                      //   'Join Mr BookWorm!',
                      //   style: TextStyle(
                      //     fontSize: 16.0,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: Stack(
                          children: <Widget>[
                            Container(
                                width: double.infinity,
                                margin: EdgeInsets.fromLTRB(30, select_layout(hei), 30, 0),
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 20),
                                      height: 22,
                                      width: 22,
                                      child: Icon(
                                        Icons.email,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                                height: 50,
                                margin: EdgeInsets.fromLTRB(30, select_layout(hei), 30, 0),
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      hintText: 'Email',
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(color: Colors.black)),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Stack(
                        children: <Widget>[
                          Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    height: 22,
                                    width: 22,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                              height: 50,
                              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                              child: TextField(
                                controller: name,

                                textAlign: TextAlign.center,
                                decoration: InputDecoration(

                                    hintText: 'Name',
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.black)),
                                style:
                                    TextStyle(fontSize: 16, color: Colors.black),
                              )),
                        ],
                      ),

                      //city
                      SizedBox(
                        height: 16,
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    height: 22,
                                    width: 22,
                                    child: Icon(
                                      Icons.phone,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                              height: 50,
                              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: phoneController,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    hintText: 'Mobile Number',
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.black)),
                                style:
                                    TextStyle(fontSize: 16, color: Colors.black),
                              )),
                        ],
                      ),

                      //TODO remove unwanted containers

                      SizedBox(
                        height: 16,
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    height: 22,
                                    width: 22,
                                    child: Icon(
                                      Icons.vpn_key,
                                      color: Colors.lightGreen,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                              height: 50,
                              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.black),
                                ),
                                style:
                                    TextStyle(fontSize: 16, color: Colors.black),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          String email = emailController.text.trim();
                          valid = EmailValidator.validate(email);
                          if(valid==false){
                            _scaffoldKey.currentState!
                                .showSnackBar(SnackBar(content: Text("Please Enter a valid Email")));

                          }
                          else if(phoneController.text.trim().length<11){
                            _scaffoldKey.currentState!
                                .showSnackBar(SnackBar(content: Text("Please Enter a valid Mobile Number")));
                          }
                          else if(passwordController.text.trim().length<6){
                            _scaffoldKey.currentState!
                                .showSnackBar(SnackBar(content: Text("Please Enter a Password of minimum length 6")));
                          }
                          else if(name.text.trim().isEmpty){
                            _scaffoldKey.currentState!
                                .showSnackBar(SnackBar(content: Text("Please Enter Name")));
                          }

                          else{

                          context.read<AuthenticationService>().signUp(name:name.text.trim(),email: emailController.text.trim(), password: passwordController.text.trim(),phone:phoneController.text.trim(),context: context)
                              .then((value) {
                            if(value == "Signed up") {
                              if (context
                                  .read<BottomNavigationProvider>()
                                  .role == "user") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomePage()),
                                );
                              }
                              else if (context
                                  .read<BottomNavigationProvider>()
                                  .role == "worker") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      WorkerHomePage()),
                                );
                              }
                            }
                            else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Register()),
                              );
                            }

                          });
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Center(
                              child: Text(
                            'Register',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50)),
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Center(
                            child: Text(
                          "Already have an account",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Center(
                              child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
