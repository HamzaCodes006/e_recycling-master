
import 'package:e_recycling/auth_screens_user/login.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'button_widget.dart';
import 'home_screen.dart';


class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
    child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Don't be a litter bag",
          body: 'Help to Keep Your Community Clean.',
          image: buildImage('images/slider_pic2.jpeg'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Trash PickUp',
          body: 'Available right at your fingerprints',
          image: buildImage('images/service2.jpg'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Pure Water',
          body: "Pure Water is the World's First and Foremost Medicine",
          image: buildImage('images/saaf.jpg'),
          decoration: getPageDecoration(),
        ),
        // PageViewModel(
        //   title: 'Today a reader, tomorrow a leader',
        //   body: 'Start your journey',
        //   footer: ButtonWidget(
        //     text: 'Start Reading',
        //     onClicked: () => goToHome(context),
        //   ),
        //   image: buildImage('assets/learn.png'),
        //   decoration: getPageDecoration(),
        // ),
      ],
      done: Text('Pick Trash', style: TextStyle(fontWeight: FontWeight.w600,
      color: Colors.white,
        fontSize: 16
      )),
      onDone: () => goToHome(context),
      showSkipButton: true,
      skip: Text('Skip',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16
      ),
      ),
      onSkip: () => goToHome(context),
      next: Row(
        children: [

          Text("Hello we",
          style: TextStyle(
            color: Colors.lightGreen
          ),
          ),
          Icon
            (Icons.arrow_forward,
            color: Colors.white,
            size: 25,
          ),
        ],
      ),
      dotsDecorator: getDotDecoration(),
      onChange: (index) => print('Page $index selected'),
      globalBackgroundColor: Colors.lightGreen,

      nextFlex: 0,
      // isProgressTap: false,
      // isProgress: false,
      // showNextButton: false,
      // freeze: true,
      // animationDuration: 1000,
    ),
  );

  void goToHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => Login()),
  );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Colors.white,
    activeColor: Colors.blue,
    size: Size(15, 10),
    activeSize: Size(22, 10),
    spacing: EdgeInsets.all(5),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    bodyTextStyle: TextStyle(fontSize: 20),

    imagePadding: EdgeInsets.all(24),
    pageColor: Colors.white,
  );
}
