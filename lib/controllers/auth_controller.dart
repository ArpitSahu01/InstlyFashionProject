import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instyl_fashion_project/screens/homescreen.dart';
import 'package:instyl_fashion_project/screens/onBoarding_screen.dart';
import 'package:instyl_fashion_project/screens/otp_screen.dart';

class AuthController extends GetxController {
  Rx<bool> isPhoneAuthLoading = false.obs;
  Rx<bool> isOtpLoading  = false.obs;
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  String? _uid;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? get uid => _uid;


  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(_firebaseAuth.currentUser);
    _user.bindStream(_firebaseAuth.userChanges());
    ever(_user, _initialScreen);
  }

  void _initialScreen(User? user) {
    if (user == null) {
      Get.offAll(const OnBoardingScreen());
    } else {
      Get.offAll(const HomeScreen());
    }
  }

  Future<void> signInWithPhone(BuildContext context, String number) async {
    isPhoneAuthLoading.value = true;
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async{
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("wrong code!")));
          },
          codeSent: (verificationId,forceResendingToken){
            isPhoneAuthLoading.value = false;
            Get.to(OtpScreen(verificationId: verificationId));
          },
          codeAutoRetrievalTimeout: (_){
          });
    } on FirebaseAuthException catch (e) {
      isPhoneAuthLoading.value = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Something went wrong!")));
    }
  }

  // verifing the OTP
void verifyOtp({
  required BuildContext context,
  required String verificationId,
  required String userOtp,
  required Function onSuccess,
}) async{

  isOtpLoading.value = true;
  try{
    PhoneAuthCredential creds =PhoneAuthProvider.credential(verificationId: verificationId, smsCode: userOtp);
    await _firebaseAuth.signInWithCredential(creds);
    if(_user.value != null){
      _uid = _user.value!.uid;
      onSuccess();
    }
    isOtpLoading.value = false;
  } on FirebaseAuthException catch (e){
  ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(e.message.toString())));
  isOtpLoading.value = false;
  }
}


void signOut() async{
    await _firebaseAuth.signOut();
}
}
