import 'package:e_recycling/auth_screens_user/register.dart';
import 'package:e_recycling/firebase_service/firebase_service.dart';
import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:e_recycling/user/home_screen.dart';
import 'package:e_recycling/worker_side/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseBetween extends StatefulWidget {
  @override
  _ChooseBetweenState createState() => _ChooseBetweenState();
}

class _ChooseBetweenState extends State<ChooseBetween> {
  double hei=0;
  double wid=0;
  @override
  Widget build(BuildContext context) {
    hei=MediaQuery.of(context).size.height;
    wid=MediaQuery.of(context).size.width;
    print(hei);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  context.read<BottomNavigationProvider>().setrole("user");

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                child: Card(

                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.lightGreen
                    )
                  ),
                child: Column(
                children: [
                  Image.asset('images/user_pic1.jpg',
                    height: hei/2.466,
                    fit: BoxFit.contain,
                  ),

                  Text('Continue as a User',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.green
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
                ),
              ),
              ),
              InkWell(
                onTap: (){
                  context.read<BottomNavigationProvider>().setrole("worker");

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.lightGreen
                      )
                  ),
                  child: Column(
                    children: [
                      Image.asset('images/worker_pic1.jpg',
                      height: hei/2.466,
                        fit: BoxFit.contain,
                      ),

                      Text('Continue as a Worker',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.green
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
