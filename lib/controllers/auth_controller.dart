import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instyl_fashion_project/models/user_model.dart';
import 'package:instyl_fashion_project/screens/homescreen.dart';
import 'package:instyl_fashion_project/screens/onBoarding_screen.dart';
import 'package:instyl_fashion_project/screens/otp_screen.dart';

import '../screens/user_register_screen.dart';

class AuthController extends GetxController {
  Rx<bool> isPhoneAuthLoading = false.obs;
  Rx<bool> isOtpLoading  = false.obs;
  Rx<bool> isUserRegister = false.obs;
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  String? _uid;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Rx<String> userName = "".obs;
  Rx<String> displayName = "".obs;
  Rx<String> phoneNumber = "".obs;

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
    phoneNumber.value = number;
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

Future<bool> checkExistingUser() async{
    final url = Uri.parse("http://user-service.pokee.app/v1/user/${_user.value!.uid}");
    final response = await http.get(url);
    final responseData = jsonDecode(response.body) as Map<String,dynamic>;
    print(responseData);
    if(responseData.containsKey("id")){
      print("EXISTING_USER");
      userName.value = responseData["user_name"];
      displayName.value = responseData["display_name"];
      Get.offAll(const HomeScreen());
      return true;
    }else{
      print("NEW_USER");
      Get.offAll(const UserRegistrationScreen());
      return false;
    }
}


storeUserData({
  required String firstName,
  required String lastName,
  required String nameUser,
}) async{
  isUserRegister.value = true;
  try{
    final url = Uri.parse("http://user-service.pokee.app/v1/user/");
    final response = await http.post(url,
        headers: {
          'Content-Type':'application/json'
        },
        body:jsonEncode({
          "id":uid,
          "first_name":firstName,
          "last_name":lastName,
          "user_name":nameUser,
          "phone_number":phoneNumber.value,
        }),

    );
    final responseData = jsonDecode(response.body);
    print(responseData);
    final userData = UserModel.fromJson({
      "id":uid,
      "first_name":firstName,
      "last_name":lastName,
      "user_name": nameUser,
      "phone_number":phoneNumber.value,
    });
    userName.value = userData.userName;
    displayName.value = "${userData.firstName} ${userData.lastName}";
     Get.offAll(HomeScreen());
    isUserRegister.value = false;
    print(responseData);
  }catch(e){
    print(e.toString());
  }finally{
    isUserRegister.value = false;
  }

}



}
