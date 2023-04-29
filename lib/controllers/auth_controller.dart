import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instyl_fashion_project/screens/homescreen.dart';
import 'package:instyl_fashion_project/screens/onBoarding_screen.dart';


class AuthController extends GetxController{

  static AuthController instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(_firebaseAuth.currentUser);
    _user.bindStream(_firebaseAuth.userChanges());
    ever(_user,_initialScreen);
  }

  void _initialScreen(User? user){

    if(user == null){
      Get.offAll(const OnBoardingScreen());
    }else{
      Get.offAll(const HomeScreen());
    }

  }


}