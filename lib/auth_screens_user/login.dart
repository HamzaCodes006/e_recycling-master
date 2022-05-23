import 'package:e_recycling/firebase_auth/authentication_service.dart';
import 'package:e_recycling/firebase_service/choose_between.dart';
import 'package:email_validator/email_validator.dart';

import 'register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool valid=false;

  @override
  Widget build(BuildContext context) {

    //test feild state
    String email = "";
    String password = "";
    //for showing loading

    // this below line is used to make notification bar transparent
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return WillPopScope(
      onWillPop: () async {
        // context.read<WorkerSideProvider>().navBack(context);
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: <Widget>[
            Image.asset(
              //TODO update this
              'images/recycle_one.jpg',
              fit: BoxFit.fill,
              height: double.infinity,
              width: double.infinity,
            ),
            // Container(
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
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Text(
                  //   'Welcome',
                  //   style: TextStyle(
                  //     fontSize: 27.0,
                  //     color: Color(0xFF7FAD39),
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
                  //     color: Color(0xFF7FAD39),
                  //   ),
                  // ),
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
                                  Icons.email,
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
                            controller: emailController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                hintText: 'Email',
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Colors.black
                                )
                            ),
                            style: TextStyle(fontSize: 16,
                                color: Colors.black),
                          )),
                    ],
                  ),
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
                            controller: passwordController,
                            textAlign: TextAlign.center,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              //focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Colors.black
                              ),
                            ),
                            style: TextStyle(fontSize: 16,
                                color: Colors.black),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: (){
                      String email = emailController.text.trim();
                      valid = EmailValidator.validate(email);
                      if(valid==false){
                        _scaffoldKey.currentState!
                            .showSnackBar(SnackBar(content: Text("Please Enter a valid Email")));

                      }
                      else if(passwordController.text.trim().length<6){
                        _scaffoldKey.currentState!
                            .showSnackBar(SnackBar(content: Text("Please Enter a Password of minimum length 6")));
                      }
                      else {
                        context.read<AuthenticationService>().signIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            context: context
                        );
                      }


                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50)
                    ),
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Center(
                        child: Text(
                          "Don't have an account",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white),
                        )),
                  ),
                  InkWell(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChooseBetween()),
                      );
                    },
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Center(
                          child: Text(
                            "Create account",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
