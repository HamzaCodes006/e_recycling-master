import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:e_recycling/provider/detail_screen_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bottom_navigation_bar.dart';
import 'home_screen.dart';

double hei = 0;
double wid = 0;

class PricingScreen extends StatefulWidget {
  const PricingScreen({Key? key}) : super(key: key);

  @override
  _PricingScreenState createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  @override
  Widget build(BuildContext context) {
    DetailScreenProvider detailScreenProvider =
        Provider.of<DetailScreenProvider>(context);
    hei = MediaQuery.of(context).size.height;
    wid = MediaQuery.of(context).size.width;
    print(MediaQuery.of(context).size.width);
    return
      WillPopScope(
        onWillPop: () async{
      context.read<BottomNavigationProvider>().navSelector(context);
      return true;
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
                'images/pricing.png',
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                context.read<BottomNavigationProvider>().navSelector(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
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
       bottomNavigationBar: BottomNavBarV2(),
     )
    );
  }

  Widget buildImages(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
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
                  BoxShadow(offset: Offset(0, -20), blurRadius: 25),
                ]),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 30, 0, 0),
                    child: Card(
                      color: Color(0xFFF1F3F4),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.lightGreen, width: 1),
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              'images/bottle_image5.jpg',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  //margin: EdgeInsets.only(right: 120),
                                  child: Text(
                                    '1 Kg',
                                    style: TextStyle(
                                        fontSize: hei/50.61,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightGreen),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Plastic',
                                    style: TextStyle(fontSize: hei/49.61),
                                  ),
                                ),
                                // SizedBox(
                                //   height: 20,
                                // )
                              ],
                            ),
                          ),
                          SizedBox(
                              width:context.read<DetailScreenProvider>().cart_width_icon(wid)
                          ),
                          // SizedBox(
                          //   width: context
                          //       .read<DetailScreenProvider>()
                          //       .cart_screen_icon(
                          //           MediaQuery.of(context).size.height),
                          // ),
                          Container(
                            // margin: EdgeInsets.only(right: 20),
                            child: Flexible(
                              child: Text(
                                '  1Kg = Rs 22',
                                style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: hei/50.61,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 30, 0, 0),
                    child: Card(
                      color: Color(0xFFF1F3F4),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.lightGreen, width: 1),
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              'images/bottle_image5.jpg',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  //margin: EdgeInsets.only(right: 120),
                                  child: Text(
                                    '1 Kg',
                                    style: TextStyle(
                                        fontSize: hei/50.61,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightGreen),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Plastic',
                                    style: TextStyle(fontSize: hei/49.61),
                                  ),
                                ),
                                // SizedBox(
                                //   height: 20,
                                // )
                              ],
                            ),
                          ),
                          SizedBox(
                              width:context.read<DetailScreenProvider>().cart_width_icon(wid)
                          ),
                          // SizedBox(
                          //   width: context
                          //       .read<DetailScreenProvider>()
                          //       .cart_screen_icon(
                          //           MediaQuery.of(context).size.height),
                          // ),
                          Container(
                            // margin: EdgeInsets.only(right: 20),
                            child: Flexible(
                              child: Text(
                                '  1Kg = Rs 22',
                                style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: hei/50.61,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 30, 0, 0),
                    child: Card(
                      color: Color(0xFFF1F3F4),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.lightGreen, width: 1),
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              'images/bottle_image5.jpg',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  //margin: EdgeInsets.only(right: 120),
                                  child: Text(
                                    '1 Kg',
                                    style: TextStyle(
                                        fontSize: hei/50.61,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightGreen),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Plastic',
                                    style: TextStyle(fontSize: hei/49.61),
                                  ),
                                ),
                                // SizedBox(
                                //   height: 20,
                                // )
                              ],
                            ),
                          ),
                          SizedBox(
                              width:context.read<DetailScreenProvider>().cart_width_icon(wid)
                          ),
                          // SizedBox(
                          //   width: context
                          //       .read<DetailScreenProvider>()
                          //       .cart_screen_icon(
                          //           MediaQuery.of(context).size.height),
                          // ),
                          Container(
                            // margin: EdgeInsets.only(right: 20),
                            child: Flexible(
                              child: Text(
                                '  1Kg = Rs 22',
                                style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: hei/50.61,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 30, 0, 0),
                    child: Card(
                      color: Color(0xFFF1F3F4),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.lightGreen, width: 1),
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              'images/bottle_image5.jpg',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  //margin: EdgeInsets.only(right: 120),
                                  child: Text(
                                    '1 Kg',
                                    style: TextStyle(
                                        fontSize: hei/50.61,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightGreen),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Plastic',
                                    style: TextStyle(fontSize: hei/49.61),
                                  ),
                                ),
                                // SizedBox(
                                //   height: 20,
                                // )
                              ],
                            ),
                          ),
                          SizedBox(
                              width:context.read<DetailScreenProvider>().cart_width_icon(wid)
                          ),
                          // SizedBox(
                          //   width: context
                          //       .read<DetailScreenProvider>()
                          //       .cart_screen_icon(
                          //           MediaQuery.of(context).size.height),
                          // ),
                          Container(
                            // margin: EdgeInsets.only(right: 20),
                            child: Flexible(
                              child: Text(
                                '  1Kg = Rs 22',
                                style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: hei/50.61,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 30, 0, 0),
                    child: Card(
                      color: Color(0xFFF1F3F4),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.lightGreen, width: 1),
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              'images/bottle_image5.jpg',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  //margin: EdgeInsets.only(right: 120),
                                  child: Text(
                                    '1 Kg',
                                    style: TextStyle(
                                        fontSize: hei/50.61,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightGreen),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Plastic',
                                    style: TextStyle(fontSize: hei/49.61),
                                  ),
                                ),
                                // SizedBox(
                                //   height: 20,
                                // )
                              ],
                            ),
                          ),
                          SizedBox(
                              width:context.read<DetailScreenProvider>().cart_width_icon(wid)
                          ),
                          // SizedBox(
                          //   width: context
                          //       .read<DetailScreenProvider>()
                          //       .cart_screen_icon(
                          //           MediaQuery.of(context).size.height),
                          // ),
                          Container(
                            // margin: EdgeInsets.only(right: 20),
                            child: Flexible(
                              child: Text(
                                '  1Kg = Rs 22',
                                style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: hei/50.61,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 30, 0, 0),
                    child: Card(
                      color: Color(0xFFF1F3F4),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.lightGreen, width: 1),
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              'images/bottle_image5.jpg',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  //margin: EdgeInsets.only(right: 120),
                                  child: Text(
                                    '1 Kg',
                                    style: TextStyle(
                                        fontSize: hei/50.61,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightGreen),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Plastic',
                                    style: TextStyle(fontSize: hei/49.61),
                                  ),
                                ),
                                // SizedBox(
                                //   height: 20,
                                // )
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   width: wid/4.1
                          // ),
                          SizedBox(
                              width:context.read<DetailScreenProvider>().cart_width_icon(wid)
                          ),
                          Container(

                            child: Flexible(
                              child: Text(
                                '  1Kg = Rs 22',
                                style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: hei/50.61,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
