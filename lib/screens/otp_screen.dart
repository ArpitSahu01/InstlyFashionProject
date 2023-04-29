import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instyl_fashion_project/controllers/auth_controller.dart';
import 'package:pinput/pinput.dart';

import '../widgets/custom_button.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:  Obx(
            ()=> Center(
            child: AuthController.instance.isOtpLoading.value ? const CircularProgressIndicator(): Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Verification",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffED7D3D),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter the OTP send to your phone number",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xffED7D3D),
                        ),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onCompleted: (value) {
                      setState(() {
                        otpCode = value;
                      });
                    },
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: CustomButton(
                      text: "Verify",
                      onPressed: () {
                        if (otpCode != null) {
                          verifyOtp(context, otpCode!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter 6-Digit Code")));
                          // showSnackBar(context, "Enter 6-Digit code");
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Didn't receive any code?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Resend New Code",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1E6AC5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // verify otp
  void verifyOtp(BuildContext context, String userOtp) {
    AuthController.instance.verifyOtp(
        context: context,
        verificationId: widget.verificationId,
        userOtp: userOtp,
        onSuccess: (){
          // checking user existing in database
        },
    );
  }
}
