import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instyl_fashion_project/auth_controller.dart';
import 'package:instyl_fashion_project/screens/homescreen.dart';
import 'package:instyl_fashion_project/screens/onBoarding_screen.dart';
import 'package:instyl_fashion_project/screens/otp_screen.dart';
import 'package:instyl_fashion_project/screens/phone_auth_screen.dart';
import 'package:instyl_fashion_project/screens/splash_screen.dart';
import 'package:instyl_fashion_project/screens/user_register_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
