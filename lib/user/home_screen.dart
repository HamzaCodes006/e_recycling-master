import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/Chat/user_chat_screen.dart';
import 'package:e_recycling/firebase_auth/authentication_service.dart';
import 'package:e_recycling/image_processing/dummy_face_detect.dart';
import 'package:e_recycling/location/user_location.dart';
import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:e_recycling/provider/detail_screen_provider.dart';
import 'package:e_recycling/provider/location_provider.dart';
import 'package:e_recycling/user/accepted_request.dart';
import 'package:e_recycling/user/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth_screens_user/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'bottom_navigation_bar.dart';

double hei = 0;
double wid = 0;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //late YoutubePlayerController _controller;
  var workerUid;
  var email = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final List<String> imgList = [
    'images/slider_pic1.jpeg',
    'images/slider_pic2.jpeg',
    'images/slider_pic3.jpeg',
    'images/slider_pic4.jpeg',
  ];
  @override
  void initState() {
    // TODO: implement initState
    // FirebaseFirestore.instance
    //     .collection('User')
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .collection('Request')
    //     .snapshots()
    //     .map((event) {
    //   event.docs.map((e) {
    //     print(e.id);
    //   });
    // });

    // //.where('Status', isEqualTo: 'assigned')
    // //     .get()
    // //     .then((value) {
    // //   print('/asfnasidnasdakldkadjasn');
    // //   value.docs.map((e) {
    // //     print(e.id);
    // //     workerUid = e.get('Woker_Assigned');
    // //     print('////////////////////////%%%%%%%$workerUid');
    // //   });
    // // });
    // if (workerUid != null) {
    //   FirebaseFirestore.instance
    //       .collection('User')
    //       .doc(workerUid)
    //       .get()
    //       .then((value) {
    //     email = value.get('Email');
    //     print('worker email: $email');
    //   });
    // }
    context.read<BottomNavigationProvider>().intilizeController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    print(MediaQuery.of(context).size.width);
    hei = MediaQuery.of(context).size.height;
    wid = MediaQuery.of(context).size.width;
    DetailScreenProvider detailScreenProvider =
        Provider.of<DetailScreenProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(),
        drawer: Container(
          width: MediaQuery.of(context).size.width / 1.14,
          child: Drawer(
            child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                          image: AssetImage(
                            'images/trash_pickup.jpg',
                          ),
                          fit: BoxFit.cover),
                    ),
                    child: Text(''),
                  ),
                  ListTile(
                    title: const Text('Accepted Request'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AcceptedRequest()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profile()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Location'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GetLocation()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Face Recognition'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DummyFaceCheck()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Log Out'),
                    onTap: () {
                      context.read<AuthenticationService>().signOut(context);
                    },
                  ),
                ]),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                    child: CarouselSlider(
                  options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 2000)),
                  items: imgList
                      .map((item) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Center(
                                  child: Image.asset(item,
                                      fit: BoxFit.cover, width: 1000)),
                            ),
                          ))
                      .toList(),
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height/2.63,

                  decoration: BoxDecoration(
                      color: Color(0xFFF1F3F4),
                      border: Border.all(color: Colors.white)),
                  child: Column(
                    children: [
                      Consumer<DetailScreenProvider>(
                        builder: (context, notifier, child) => SizedBox(
                          height: notifier.responsive_home(
                              MediaQuery.of(context).size.height,
                              MediaQuery.of(context).size.width),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Consumer<DetailScreenProvider>(
                                builder: (context, notifier, child) => InkWell(
                                  onTap: () {
                                    detailScreenProvider.setIndex(0, context);
                                    context
                                        .read<LocationProvider>()
                                        .getClassName("Plastic");
                                    context
                                        .read<BottomNavigationProvider>()
                                        .setCotrollervalue();
                                  },
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                    'images/bottle_image5.jpg',
                                                  ),
                                                  fit: BoxFit.cover)),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 7.0),
                                          child: Text(
                                            'Plastic',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Consumer<DetailScreenProvider>(
                                builder: (context, notifier, child) => InkWell(
                                  onTap: () {
                                    detailScreenProvider.setIndex(1, context);
                                    context
                                        .read<LocationProvider>()
                                        .getClassName("Organic");
                                    context
                                        .read<BottomNavigationProvider>()
                                        .setCotrollervalue();
                                  },
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                    'images/organic_icon.jpg',
                                                  ),
                                                  fit: BoxFit.cover)),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 7.0),
                                          child: Text(
                                            'Organic',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Consumer<DetailScreenProvider>(
                                builder: (context, notifier, child) => InkWell(
                                  onTap: () {
                                    detailScreenProvider.setIndex(2, context);
                                    context
                                        .read<LocationProvider>()
                                        .getClassName("Glass");
                                    context
                                        .read<BottomNavigationProvider>()
                                        .setCotrollervalue();
                                  },
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                    'images/glass_image3.jpg',
                                                  ),
                                                  fit: BoxFit.cover)),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 7.0),
                                          child: Text(
                                            'Glass',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Consumer<DetailScreenProvider>(
                                builder: (context, notifier, child) => InkWell(
                                  onTap: () {
                                    detailScreenProvider.setIndex(3, context);
                                    context
                                        .read<LocationProvider>()
                                        .getClassName("Metal");
                                    context
                                        .read<BottomNavigationProvider>()
                                        .setCotrollervalue();
                                  },
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                    'images/metal.png',
                                                  ),
                                                  fit: BoxFit.cover)),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 7.0),
                                          child: Text(
                                            'Metal',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Consumer<DetailScreenProvider>(
                                builder: (context, notifier, child) => InkWell(
                                  onTap: () {
                                    detailScreenProvider.setIndex(4, context);
                                    context
                                        .read<LocationProvider>()
                                        .getClassName("Paper");
                                    context
                                        .read<BottomNavigationProvider>()
                                        .setCotrollervalue();
                                  },
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                    'images/paper.jpg',
                                                  ),
                                                  fit: BoxFit.cover)),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 7.0),
                                          child: Text(
                                            'Paper',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Consumer<DetailScreenProvider>(
                                builder: (context, notifier, child) => InkWell(
                                  onTap: () {
                                    detailScreenProvider.setIndex(5, context);
                                    context
                                        .read<BottomNavigationProvider>()
                                        .setCotrollervalue();
                                  },
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: AssetImage(
                                              'images/service2.jpg',
                                            ),
                                            fit: BoxFit.cover,
                                          )),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 7.0),
                                          child: Text(
                                            'More Services',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 0.4,
                      height: MediaQuery.of(context).size.height / 3.03,
                      child: YoutubePlayerControllerProvider(
                        // Provides controller to all the widget below it.
                        controller:
                            context.read<BottomNavigationProvider>().controller,
                        child: YoutubePlayerIFrame(
                          aspectRatio: 16 / 9,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBarV2(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Color(0xFF150047)),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 18,
        ),
        onPressed: () => _scaffoldKey.currentState!.openDrawer(),
      ),
      title: Text(
        'Home Screen',
        style: TextStyle(color: Colors.lightGreen),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            size: 20,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  void dispose() {
    super.dispose();
    //context.read<BottomNavigationProvider>().controller?.close();
  }
}
