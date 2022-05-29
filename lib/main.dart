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
import 'package:firebase_admin_sdk/firebase_admin.dart';
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
 const Map<String,dynamic> firebaseAdminSDK={
"type":"service_account",
   "project_id": "e-recycling-43cd1",
   "client_email": "firebase-adminsdk-dgt0b@e-recycling-43cd1.iam.gserviceaccount.com",
   "client_id": "111006224756979874008",
   "private_key_id": "55813c5387811eeab2d35e6bb5995a892b8d413b",
   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCiTbDhqHh0xoQ/\nZymMvNQkR8zliMQqNzsws0MIkNvzxmjYSfxZFZAzGj7xdsrq4VQYu72QXTtv4h//\n/KaiM8yLBbZPozcYwmeaVtYPQFOs7WjgwP41Mq0Y9KJTQEHA3d+jxmAcjhkKYQEY\n3S4RROynvUYb7yc6YIXd/dnuUjwhH8n+IdO7Yy8bmHooh3Dw+pvEq28EnMf+Ciy+\n6NLN3T1EiQ38rvTJ1TKaRDSLrym3uLdG5rhlN84SM3UItOacu33tM5herW1vY4Ve\naoYM5k1jyvB1JjXzMjfKZHwzNXVMY5H5247ljOEVbCN6YSO0tAKruXaOvvAend5m\nuHkuS2WZAgMBAAECggEAIIyCF48osQqKxQhUTdQkmy4HClU2Od0fsrGQlOwwICA/\nMHkN8XOgmo795oDTSu1rZxZnescnv1VS44xwgoDu2UaI/EmYKA/8pPgbL63P2hM2\ngDRUBqkmC6Yr05REW4BjdD25UqCwpuMzTCA3N+FhsHYF1F5OuKdY0V8yUFgPlPiw\nQPDCI4FKgJxfcdtHLj6F+GRMI+Tx1YRvcw90jRrhF9C7/cLbT3N7+rPqZ//Kfo6I\n0za4fsA2PNpc+3Yo56tZBV3SwK7wPxRvcJUJ8UrSC9Z4yM72NCoSX0cIBRhXG6/x\nSNBVltaBrRvy73TlzoTbhSF6EkXngNq5DDk/YcWL/QKBgQDT4fD6mhb6sHH1T5BW\nidSC5JoTyAXwIqcMSaGdQ1/3R8/iubarfoVdpmM9oGg2ChPXaRvist/45ZWAw//X\nxtorF/OVgLqXjnCahl+Chr6R0+77tEEnKAXHtt02sVz5l7Og8HXUVJ+YoidfabrC\n5WJ+Mle6EkKZZnvHORyRhICH8wKBgQDEGQQCFle3VRqO7sQ+xxp77DyCZz6X68hQ\n3vLMgSGqDUh0Cpp1itVxYJF98UrCjEITCkUBujLOHzlQdh7MEWtt0M/kqohUsy6C\nk9xLkSA/GpdcmuDoojmxIExTPJ0XN9AAwp8fa4vw8WB2ed+jdKKalPtz/mya1rWU\nijisBWYrQwKBgCTv8ZOugy0Gz4cFbNM5SfvboGSsbSSU1exVdcA1u6gfM8WBvK+e\n6d8On6Rhr2kkTpsx7rORnWwFkg+Vm6dhOi1jCorYmy7KnSTDIileFiDUAoiMvwL1\nfjR3046yUtQMNztqUBBJBF2WfyiqBO3vEUGQwyxj/IpDjHaJpUpVABczAoGAWKGJ\n2zun97fiYhnu3wT0pnAWxUXO17F8/3hVOzNeONL6HWCxgVD3ud/QwqCtjpMARkTM\n/cPftKQOLpzEvK1e5eqMHCkrp0S5T9Fur0Tv0zW8leF2qA6yjqkvdiueQOE8BSvx\n6aydOpCObd4Vw3YzDDUsFbg39B/5QCLdDHsAO6sCgYEAsiU8H7FkGIomy5+UgWDn\nUsDqiNDMik61Y0IoYMBh9jTWV2uFdr5kzKeBiZtg2OplQ527bp5kTKsuX0gM5b0j\nXFWRLJc/WzdJgtUniairRP3Nju8riVqv8tXmZeSXLtUMIVrS6mrbqwfVL61NCzW0\nuSoVZBpkGsG2jERsMhXMK7o=\n-----END PRIVATE KEY-----\n",

 };

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   FirebaseApp firebaseApp=await Firebase.initializeApp();
  FirebaseAdmin.instance.initializeApp(AppOptions(
    projectId: firebaseApp.options.projectId,
    databaseUrl: firebaseApp.options.databaseURL,
    storageBucket: firebaseApp.options.storageBucket,
    credential: FirebaseAdmin.instance.certFromMap(
      firebaseAdminSDK,
    ),
  ));
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
