import 'package:e_recycling/payment/payment_ui.dart';

import 'package:e_recycling/provider/bottom_navigation_provider.dart';
import 'package:e_recycling/provider/detail_screen_provider.dart';
import 'package:e_recycling/provider/location_provider.dart';
import 'package:e_recycling/user/AuthenticationWrapper.dart';
import 'package:e_recycling/user/boarding_screen.dart';
import 'package:e_recycling/user/choose_general_purpose_water.dart';

import 'package:e_recycling/user/custom_animation.dart';
import 'package:e_recycling/user/more_services.dart';
import 'package:e_recycling/user/cart_screen.dart';
import 'package:e_recycling/user/choose_glass.dart';
import 'package:e_recycling/user/choose_metal.dart';
import 'package:e_recycling/user/choose_paper.dart';
import 'package:e_recycling/user/choose_plastic.dart';
import 'package:e_recycling/user/choose_water.dart';
import 'package:e_recycling/user/details_page.dart';
import 'package:e_recycling/user/home_screen.dart';
import 'package:e_recycling/user/choose_organic.dart';
import 'package:e_recycling/user/package_provider.dart';
import 'package:e_recycling/user/packages.dart';
import 'package:e_recycling/user/packages_page.dart';
import 'package:e_recycling/user/pricing_screen.dart';
import 'package:e_recycling/user/timer.dart';
import 'package:e_recycling/worker_side/request_detail_page.dart';
import 'package:e_recycling/worker_side/requests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'auth_screens_user/register.dart';
import 'package:e_recycling/user/user_profile.dart';
import 'package:e_recycling/user/choose_swimming_pool_water.dart';
import 'package:e_recycling/worker_side/HomeScreen.dart';
import 'package:e_recycling/worker_side/worker_side_provider.dart';
import 'package:provider/provider.dart';

import 'auth_screens_user/signinorregister.dart';
import 'package:flutter/material.dart';

import 'firebase_auth/authentication_service.dart';
import 'firebase_service/choose_between.dart';

import 'firebase_service/worker vs user Home.dart';
import 'location/distance_from_user.dart';
import 'location/geo_locator.dart';

import 'location/user_location.dart';
import 'nas_academy.dart';
import 'user/check.dart';
import 'auth_screens_user/login.dart';
import 'global.dart' as globals;

const kAppId = "c7d0fb78-0427-4c2c-9cd0-bd1666eb345d";

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  configLoading();
  configOneSignel();
}

void configOneSignel() {
  OneSignal.shared.setAppId('c7d0fb78-0427-4c2c-9cd0-bd1666eb345d');
  OneSignal.shared.setNotificationOpenedHandler((openedResult) {
    var data = openedResult.notification.additionalData;
    // globals.appNavigator.currentState!
    //     .push(MaterialPageRoute(builder: (context) => HomePage()));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DetailScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BottomNavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PackagesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WorkerSideProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        builder: EasyLoading.init(),
        home: AuthenticationWrapper(),
        routes: {
          'registerpage': (context) => Register(),
        },
      ),
    );
  }
}
