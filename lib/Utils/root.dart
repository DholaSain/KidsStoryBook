
import 'package:ustaadian/Controllers/authController.dart';
import 'package:ustaadian/Controllers/userController.dart';
import 'package:ustaadian/Screens/view/Home.dart';
import 'package:ustaadian/Screens/view/SplashScreen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Root extends GetWidget<AuthController> {
  

  @override
  Widget build(BuildContext context) {
    return GetX(
      initState: (_) async {
        Get.put<UserController>(UserController());
      },
      builder: (_) {
        if (Get.find<AuthController>().user?.uid != null) {
          return Home();
        } else {
          return SplashScreen();
        }
      },
    );
  }
}