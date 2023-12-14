

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:last_roadi_app/controller/auth_controller.dart';

Future<void> init() async {
  // Repository
  Get.lazyPut(() => AuthController());
  
  
}
