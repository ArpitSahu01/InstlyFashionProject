import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instyl_fashion_project/screens/homescreen.dart';
import 'package:instyl_fashion_project/screens/onBoarding_screen.dart';
import 'package:instyl_fashion_project/screens/user_register_screen.dart';

class AuthController extends GetxController {

  static AuthController instance = Get.find();
  var verificationId = ''.obs;
  var checking = false.obs;
  var isOtpLoading = false.obs;
  var displayName = "".obs;
  var userName = "".obs;

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

  _setInitialScreen(User? user) {
    if(checking.value == false){
      user != null ? Get.offAll(const HomeScreen()) : Get.offAll(const OnBoardingScreen());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> phoneAuthentication(String phoneNumber) async {
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async{
            await _auth.signInWithCredential(credential);
        },
        verificationFailed: (e){
          if(e.code == 'invalid-phone-number'){
            Fluttertoast.showToast(msg: "Invalid phone number");
          }else{
            Fluttertoast.showToast(msg: "Something went wrong!");
          }
        },
        codeSent: (verificationId,resentCode){
            this.verificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId){
          this.verificationId.value = verificationId;
        });
  }

  Future<bool> verifyOtp(String otp) async{
try{
  checking.value = true;
  var credentials = await _auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId.value, smsCode: otp));
  return credentials.user != null ?  true:  false;

}on FirebaseAuthException catch (e){
  checking.value = false;
  Fluttertoast.showToast(msg: e.toString());
  return false;
}
  }

  Future<void> checkUser() async{
    isOtpLoading.value = true ;
    final url = Uri.parse("http://user-service.pokee.app/v1/user/${firebaseUser.value!.uid}");
    final response = await http.get(url);
    final data = jsonDecode(response.body) as Map<String,dynamic>;
    if(!data.containsKey("id")){
      Get.offAll(const UserRegistrationScreen());
      isOtpLoading.value = false;
    }else{
      displayName.value = data["display_name"];
      userName.value = data["user_name"];
      checking.value = true;
      Get.offAll(const HomeScreen());
    }
    isOtpLoading.value = false ;
  }
  

}
