import 'package:e_recycling/provider/detail_screen_provider.dart';
import 'package:e_recycling/user/package_provider.dart';
import 'package:e_recycling/worker_side/worker_side_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Packages_page extends StatefulWidget {
  @override
  _Packages_pageState createState() => _Packages_pageState();
}

class _Packages_pageState extends State<Packages_page> {
  @override
  Widget build(BuildContext context) {
    PackagesProvider packagesProvider = Provider.of<PackagesProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                  Color(0xFF8BC34A),
                  Color(0xFFAED581),
                  Color(0xFF9CCC65)
                ]),
                //color: Colors.lightGreen[400]
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 80,
                  ),
                  Header(),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            //topRight: Radius.circular(60),
                          )),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          ListView.builder(
                            itemCount:
                                context.watch<PackagesProvider>().li.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return Card(
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
                                        '${context.watch<PackagesProvider>().li[index].image}',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            //margin: EdgeInsets.only(right: 120),
                                            child: Text(
                                              '${context.watch<PackagesProvider>().li[index].name}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.lightGreen),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            //margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              'Valid for = ${context.watch<PackagesProvider>().li[index].valid_for}',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: 20,
                                          // )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                    width:context.read<DetailScreenProvider>().cart_width_icon(MediaQuery.of(context).size.width),
                                    ),

                                    Container(
                                      // margin: EdgeInsets.only(right: 20),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Rs ${context.watch<PackagesProvider>().li[index].price}',
                                            style: TextStyle(
                                                color: Colors.lightGreen,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          // Text('x 5'),
                                          // SizedBox(
                                          //   height: 20,
                                          // )
                                        ],
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: context.read<DetailScreenProvider>().cart_screen_icon(MediaQuery.of(context).size.height),
                                    // ),
                                    //
                                    // Container(
                                    //   alignment: Alignment.centerRight,
                                    //   child: Icon(
                                    //     Icons.delete_forever,
                                    //     color: Colors.lightGreen,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              "Packages",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
