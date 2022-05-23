import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/firebase_service/location%20vs%20service.dart';
import 'package:e_recycling/location/user_location.dart';
import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:e_recycling/provider/location_provider.dart';
import 'package:e_recycling/user/choose_plastic.dart';
import 'package:e_recycling/user/pricing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBarV2 extends StatefulWidget {
  @override
  _BottomNavBarV2State createState() => _BottomNavBarV2State();
}

class _BottomNavBarV2State extends State<BottomNavBarV2> {
  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationProvider bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 80,
      child: Stack(
        overflow: Overflow.visible,
        children: [
          CustomPaint(
            size: Size(size.width, 80),
            painter: BNBCustomPainter(),
          ),
          Center(
            heightFactor: 0.6,
            child: FloatingActionButton(
                backgroundColor: Colors.lightGreen,
                child: Image.asset('images/recycle_logo.png'),
                elevation: 0.1,
                onPressed: () {
                  context.read<LocationProvider>().getClassName("Paper");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LocationVsService()),
                  );
                  context.read<BottomNavigationProvider>().setCotrollervalue();

                }),
          ),
          Container(
            width: size.width,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<BottomNavigationProvider>(
                  builder: (context, notifier, child) => IconButton(
                    icon: Icon(
                      Icons.home,
                      color: notifier.currentIndex == 0
                          ? Colors.lightGreen
                          : Colors.grey.shade400,
                    ),
                    onPressed: () {
                      // setBottomBarIndex(0);
                      context
                          .read<BottomNavigationProvider>()
                          .setCurrentIndex(0,context);
                      context.read<BottomNavigationProvider>().setCotrollervalue();
                    },
                    splashColor: Colors.white,
                  ),
                ),
                Consumer<BottomNavigationProvider>(
                  builder: (context, notifier, child) => IconButton(
                      icon: Icon(
                        Icons.monetization_on,
                        color: notifier.currentIndex == 1
                            ? Colors.lightGreen
                            : Colors.grey.shade400,
                      ),
                      onPressed: () {
                        //setBottomBarIndex(1);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PricingScreen()),
                        );
                        context
                            .read<BottomNavigationProvider>()
                            .setCurrentIndex(1,context);
                        context.read<BottomNavigationProvider>().setCotrollervalue();
                      }),
                ),
                Container(
                  width: size.width * 0.20,
                ),
                Consumer<BottomNavigationProvider>(
                  builder: (context, notifier, child) => IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: notifier.currentIndex == 2
                            ? Colors.lightGreen
                            : Colors.grey.shade400,
                      ),
                      onPressed: () {
                        //setBottomBarIndex(2);
                        context
                            .read<BottomNavigationProvider>()
                            .setCurrentIndex(2,context);
                        context.read<BottomNavigationProvider>().setCotrollervalue();
                      }),
                ),
                Consumer<BottomNavigationProvider>(
                  builder: (context, notifier, child) => IconButton(
                      icon: Icon(
                        Icons.person_pin,
                        color: notifier.currentIndex == 3
                            ? Colors.lightGreen
                            : Colors.grey.shade400,
                      ),
                      onPressed: () {
                        //setBottomBarIndex(3);
                        context
                            .read<BottomNavigationProvider>()
                            .setCurrentIndex(3,context);
                        context.read<BottomNavigationProvider>().setCotrollervalue();
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

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
