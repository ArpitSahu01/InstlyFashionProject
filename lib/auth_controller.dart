import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instyl_fashion_project/screens/homescreen.dart';
import 'package:instyl_fashion_project/screens/onBoarding_screen.dart';

class AuthController extends GetxController{

  static AuthController instance = Get.find();

  // variables
  final _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user){
    user != null? Get.offAll(const HomeScreen()) : Get.offAll(const OnBoardingScreen());
  }

  Future<void> signOut() async{
    await _auth.signOut();
  }


}