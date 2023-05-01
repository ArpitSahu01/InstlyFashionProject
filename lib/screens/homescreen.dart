import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instyl_fashion_project/auth_controller.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1E6AC5),
        title: const Text("FlutterPhone Auth"),
        actions: [
          IconButton(
            onPressed: () {
              AuthController.instance.signOut();
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.purple,
                backgroundImage: NetworkImage("https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80"),
                radius: 50,
              ),
              const SizedBox(height: 20),
              Obx(()=> Text("USER NAME : ${AuthController.instance.userName}")),
              Obx(()=> Text("NAME : ${AuthController.instance.displayName}")),
            ],
          )),
    );
  }
}
