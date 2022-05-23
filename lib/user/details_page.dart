import 'package:e_recycling/firebase_service/location%20vs%20service.dart';
import 'package:e_recycling/provider/detail_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double hei = 0;
double wid = 0;

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
 double  setfont(double height){
    if(height<700){
      return 17.5;
    }
    else if(height<750){
      return 17;
    }
    else{
      return 18.5;
    }
  }
  @override
  Widget build(BuildContext context) {
    hei = MediaQuery.of(context).size.height;
    wid = MediaQuery.of(context).size.width;
    DetailScreenProvider detailScreenProvider =
        Provider.of<DetailScreenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
            '${detailScreenProvider.detail[detailScreenProvider.index].name}'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<DetailScreenProvider>(
              builder: (context, notifier, child) => Container(
                width: MediaQuery.of(context).size.width / 0.6,
                height: MediaQuery.of(context).size.height / 3.266,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            '${notifier.detail[detailScreenProvider.index].image}'),
                        fit: BoxFit.contain)),
              ),
            ),
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
                  Flexible(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 8, 8),
                        child: Consumer<DetailScreenProvider>(
                          builder: (context, notifier, child) => Text(
                            '${notifier.detail[detailScreenProvider.index].description}',
                            style: TextStyle(
                              fontSize: setfont(hei),
                              wordSpacing: 2,
                              //color: Colors.white
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: hei / 142.2,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationVsService()),
                      );
                    },
                    child: Container(
                      height: hei / 14.22,
                      decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          borderRadius: BorderRadius.circular(50)),
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Center(
                          child: Text(
                        'Continue',
                        style: TextStyle(
                            fontSize: hei / 44.43, color: Colors.white),
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
