import 'package:e_recycling/provider/detail_screen_provider.dart';
import 'package:e_recycling/user/choose_swimming_pool_water.dart';
import 'package:e_recycling/user/choose_water.dart';
import 'package:e_recycling/user/packages_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../firebase_service/location vs service.dart';
import '../provider/bottom_navigation_provider.dart';
import '../provider/location_provider.dart';

double hei = 0;
double wid = 0;

class MoreServices extends StatefulWidget {
  @override
  _MoreServicesState createState() => _MoreServicesState();
}

class _MoreServicesState extends State<MoreServices> {
  late YoutubePlayerController _controller;
  @override
  Widget build(BuildContext context) {
    DetailScreenProvider detailScreenProvider =
        Provider.of<DetailScreenProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'images/recycle_3.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height / 8.2),
                    child: InkWell(
                      onTap: () {
                        //detailScreenProvider.setIndex(6, context);
                        context
                            .read<LocationProvider>()
                            .getClassName("Swimming Pool");
                        // context
                        //     .read<BottomNavigationProvider>()
                        //     .setCotrollervalue();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LocationVsService()),
                        );

                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'images/pure water.png',
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 7.0),
                              child: Text(
                                'Water',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height / 8.2),
                    child: InkWell(
                      onTap: (){
                        context
                            .read<LocationProvider>()
                            .getClassName("Mix");
                        // context
                        //     .read<BottomNavigationProvider>()
                        //     .setCotrollervalue();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LocationVsService()),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        'images/mix.jpg',
                                      ),
                                      fit: BoxFit.contain)),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 7.0),
                              child: Text(
                                'Mix',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height / 8.2),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Packages_page()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'images/packages.jpg',
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 7.0),
                              child: Text(
                                'Packages',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
