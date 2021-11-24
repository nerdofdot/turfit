import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turfit/turf_info_page.dart';
import 'slotdisplay_UI_for_each_turf.dart';
import 'loading_splash_screen.dart';
import 'authScreen.dart';
import 'phone_verification.dart';






void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
      home: LoadingForSplashScreen(),//base dart File
      routes: {
        "/slotsui":(context)=>ListForSlotsofTurf(),
        "/auth":(context)=> AuthScreen(),
        "/splashScreen":(context)=>LoadingForSplashScreen(),
        "/phonever":(context)=>PhoneAuth(),
        "/turfinfo":(context)=>TurfInfoPage(),
      },
      debugShowCheckedModeBanner: false,
    ));
  });


}


