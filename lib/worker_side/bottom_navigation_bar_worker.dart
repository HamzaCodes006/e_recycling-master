import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:e_recycling/worker_side/worker_side_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_recycling/user/choose_plastic.dart';
import 'package:e_recycling/user/home_screen.dart';

import 'package:provider/provider.dart';

class BottomNavigationBarWorker extends StatefulWidget {
  @override
  _BottomNavigationBarWorkerState createState() =>
      _BottomNavigationBarWorkerState();
}

class _BottomNavigationBarWorkerState extends State<BottomNavigationBarWorker> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    WorkerSideProvider workerSideProvider =
        Provider.of<WorkerSideProvider>(context);
    print(context.watch<WorkerSideProvider>().selectedIndex);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 80,
      child: Stack(
        overflow: Overflow.visible,
        children: [
          // CustomPaint(
          //   size: Size(size.width, 80),
          //   painter: BNBCustomPainter(),
          // ),
          // Center(
          //   heightFactor: 0.6,
          //   child: FloatingActionButton(
          //       backgroundColor: Colors.lightGreen,
          //       child: Image.asset('images/recyle_logo2.jpg'),
          //       elevation: 0.1,
          //       onPressed: () {
          //         context.read<BottomNavigationProvider>().setCotrollervalue();
          //
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => ChoosePlasticAndCalculate()),
          //         );
          //
          //       }),
          // ),
          Container(
            width: size.width,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                //color: Colors.lightGreen,
                color: Color(0xFFF1F3F4),
                boxShadow: [
                  BoxShadow(offset: Offset(0, -1), blurRadius: 1),
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<WorkerSideProvider>(
                  builder: (context, notifier, child) => IconButton(
                    icon: Icon(
                      Icons.home,
                      color: notifier.selectedIndex == 0
                          ? Colors.lightGreen
                          : Colors.grey.shade400,
                    ),
                    onPressed: () {
                      // setBottomBarIndex(0);
                      context.read<WorkerSideProvider>().onItemTapped(0);
                      context.read<WorkerSideProvider>().navTo(context);
                    },
                    splashColor: Colors.white,
                  ),
                ),
                Consumer<WorkerSideProvider>(
                  builder: (context, notifier, child) => IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: notifier.selectedIndex == 1
                            ? Colors.lightGreen
                            : Colors.grey.shade400,
                      ),
                      onPressed: () {
                        //setBottomBarIndex(1);
                        context.read<WorkerSideProvider>().onItemTapped(1);
                        context.read<WorkerSideProvider>().navTo(context);
                        // FirebaseFirestore.instance
                        //     .collection('User')
                        //     .get()
                        //     .then((QuerySnapshot querySnapshot) {
                        //   querySnapshot.docs.forEach((doc) {
                        //     // print(doc["Name"]);
                        //     FirebaseFirestore.instance
                        //     .collection('User')
                        //     .doc(doc.id)
                        //         .collection('Request')
                        //         .get()
                        //         .then((QuerySnapshot querySnapshot) {
                        //       querySnapshot.docs.forEach((doc) {
                        //         print(doc["Name"]);
                        //
                        //
                        //       });
                        //     });
                        //
                        //   });
                        // });
                      }),
                ),
                // Container(
                //   width: size.width * 0.20,
                // ),
                Consumer<WorkerSideProvider>(
                  builder: (context, notifier, child) => IconButton(
                      icon: Icon(
                        Icons.history,
                        color: notifier.selectedIndex == 2
                            ? Colors.lightGreen
                            : Colors.grey.shade400,
                      ),
                      onPressed: () {
                        //setBottomBarIndex(2);
                        context.read<WorkerSideProvider>().onItemTapped(2);
                        context.read<WorkerSideProvider>().navTo(context);
                      }),
                ),
                Consumer<WorkerSideProvider>(
                  builder: (context, notifier, child) => IconButton(
                      icon: Icon(
                        Icons.account_circle,
                        color: notifier.selectedIndex == 3
                            ? Colors.lightGreen
                            : Colors.grey.shade400,
                      ),
                      onPressed: () {
                        //setBottomBarIndex(3);
                        context.read<WorkerSideProvider>().onItemTapped(3);
                        context.read<WorkerSideProvider>().navTo(context);
                      }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


