import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/provider/detail_screen_provider.dart';
import 'package:e_recycling/user/choose_metal.dart';
import 'package:e_recycling/user/choose_water.dart';
import 'package:e_recycling/user/choose_swimming_pool_water.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

double hei = 0;
double wid = 0;

class ChooseGeneralPurposeWater extends StatefulWidget {
  const ChooseGeneralPurposeWater({Key? key}) : super(key: key);

  @override
  _ChooseGeneralPurposeWaterState createState() =>
      _ChooseGeneralPurposeWaterState();
}

class _ChooseGeneralPurposeWaterState extends State<ChooseGeneralPurposeWater> {
  @override
  Widget build(BuildContext context) {
    DetailScreenProvider detailScreenProvider =
        Provider.of<DetailScreenProvider>(context);
    hei = MediaQuery.of(context).size.height;
    wid = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
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
                  'images/trash_pickup.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              leading: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.green,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
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
      ),
    );
  }

  Widget buildImages(BuildContext context) {
    DetailScreenProvider detailScreenProvider =
        Provider.of<DetailScreenProvider>(context);
    print(context.watch<DetailScreenProvider>().slider_value);
    print("state rebuild");
    return SliverToBoxAdapter(
        child: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 1.366,
          width: MediaQuery.of(context).size.width / 0.6,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              //color: Colors.lightGreen,
              color: Color(0xFFF1F3F4),
              boxShadow: [
                BoxShadow(offset: Offset(0, -10), blurRadius: 25),
              ]),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: Text(
                          '${context.watch<DetailScreenProvider>().slider_value} Gallons',
                          style: TextStyle(
                            fontSize: hei / 47.4,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                        child: Text(
                          'General Purpose Water',
                          style: TextStyle(
                              //color: Colors.lightGreen
                              fontSize: hei / 47.4),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
                        child: Text(
                          '1 Gallon = Rs 50',
                          style: TextStyle(
                              fontSize: hei / 47.4,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreen),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Text(
                          ' x Distance',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: context
                          .watch<DetailScreenProvider>()
                          .slider_value
                          .toDouble(),
                      onChanged: (double value) {
                        context
                            .read<DetailScreenProvider>()
                            .setSliderValue(value);
                      },
                      inactiveColor: Color(0xFFA7A7A7),
                      activeColor: Colors.lightGreen,
                      min: 0,
                      max: 20,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Column(
                      children: [
                        // customCard('images/bottle_image5.jpg','Plastic',Colors.lightGreen),
                        customCard(
                          'images/swimming_pool_water_icon.jpg',
                          'Swimming Pool Water',
                          Colors.white,
                          () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ChooseSwimmingPoolWater();
                            }));
                          },
                        ),
                        Card(
                          color: Colors.lightGreen,
                          child: Row(
                            children: [
                              ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                  Colors.lightGreen,
                                  BlendMode.darken,
                                ),
                                child: Image.asset(
                                  'images/general_purpose_water.jpg',

                                  //color: Colors.lightGreen,
                                  height: context
                                      .read<DetailScreenProvider>()
                                      .chooseImageAsset(
                                          MediaQuery.of(context).size.height,
                                          MediaQuery.of(context).size.width),
                                  width: context
                                      .read<DetailScreenProvider>()
                                      .chooseImageAsset(
                                          MediaQuery.of(context).size.height,
                                          MediaQuery.of(context).size.width),

                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'General Purpose Water',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              )
                            ],
                          ),
                        ),
                        customCard(
                          'images/pure water.png',
                          'Drinking Water',
                          Colors.white,
                          () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ChooseWaterAndCalculate();
                            }));
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: hei / 14.22,
                    width: wid / 1.44,
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('User')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('Cart')
                            .doc('GeneralPurposeWater')
                            .update({
                              'weight': context
                                  .read<DetailScreenProvider>()
                                  .slider_value
                            })
                            .then((value) => ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                    content:
                                        Text("Added To Cart Successfully"))))
                            .catchError((error) =>
                                print("Failed to update Value: $error"));
                      },
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightGreen),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    ));
  }
}

class customCard extends StatelessWidget {
  String image;
  String text;
  Color color;
  Function onTap;

  customCard(this.image, this.text, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: on_tap,
      child: Card(
        color: color,
        child: Row(
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.darken,
              ),
              child: Image.asset(
                image,

                //color: Colors.lightGreen,
                height: context.read<DetailScreenProvider>().chooseImageAsset(
                    MediaQuery.of(context).size.height,
                    MediaQuery.of(context).size.width),
                width: context.read<DetailScreenProvider>().chooseImageAsset(
                    MediaQuery.of(context).size.height,
                    MediaQuery.of(context).size.width),

                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '$text',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                //color: Colors.white
              ),
            ),
            SizedBox(
              width: 15,
            )
          ],
        ),
      ),
    );
  }

  void on_tap() {
    onTap();
  }
}
