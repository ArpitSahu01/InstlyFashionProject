import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instyl_fashion_project/controllers/auth_controller.dart';

import '../widgets/custom_button.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  File? image;
  final usernameController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
  }

  // for selecting image
  void selectImage() async {
    // image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child:  SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
          child: Obx(
            ()=> AuthController().isUserRegister.value? const CircularProgressIndicator(): Center(
              child: Column(
                children: [
                  const SizedBox(height: 100,),
                  const Center(
                    child: Text("Register",style: TextStyle(
                      fontSize: 40,
                      color: Color(0xff1E6AC5),
                      fontWeight: FontWeight.w600
                    ),),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 15),
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        // user name
                        textFeld(
                          hintText: "User Name",
                          icon: Icons.account_circle,
                          inputType: TextInputType.name,
                          maxLines: 1,
                          controller: usernameController,
                        ),

                        // first name
                        textFeld(
                          hintText: "First Name",
                          icon: Icons.account_circle,
                          inputType: TextInputType.name,
                          maxLines: 1,
                          controller: firstnameController,
                        ),

                        // last name
                        textFeld(
                          hintText: "Last Name",
                          icon: Icons.account_circle,
                          inputType: TextInputType.name,
                          maxLines: 1,
                          controller: lastnameController,
                        ),

                        // email
                        textFeld(
                          hintText: "abc@example.com",
                          icon: Icons.email,
                          inputType: TextInputType.emailAddress,
                          maxLines: 1,
                          controller: emailController,
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: CustomButton(
                      text: "Register",
                      onPressed: () => storeData(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textFeld({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: const Color(0xff1E6AC5),
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0xffED7D3D),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Color(0xffED7D3D).withOpacity(0.4),
          filled: true,
        ),
      ),
    );
  }

  // store user data to database
  void storeData() {
    final firstName =firstnameController.text.trim();
    final lastName = lastnameController.text.trim();
    final userName = usernameController.text.trim();
    AuthController.instance.storeUserData(firstName: firstName, lastName: lastName, nameUser: userName);
  }
}
