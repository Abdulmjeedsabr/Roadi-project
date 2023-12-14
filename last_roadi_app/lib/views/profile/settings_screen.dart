import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:last_roadi_app/controller/auth_controller.dart';
import 'package:last_roadi_app/utiles/route_helper.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F8FA),
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.cairo(
            textStyle: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        elevation: 0.3,
        backgroundColor: Colors.white,
      ),
      body: GetBuilder<AuthController>(builder: (authController) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsetsDirectional.only(
              start: 15.0,
              end: 15.0,
              top: 20.0,
              bottom: 20.0,
            ),
            child: Column(
              children: [
                _itemList(context, icon: Icons.person, title: "Profile",
                    onPressed: () {
                  Get.toNamed(RouteHelper.getEditProfileRoute());
                }),
                const SizedBox(
                  height: 7,
                ),
                _itemList(context, icon: Icons.lock, title: "Change password",
                    onPressed: () {
                  Get.toNamed(RouteHelper.getChangePasswordRoute());
                }),
                const SizedBox(
                  height: 7,
                ),
                _itemList(context, icon: Icons.help, title: "Help support",
                    onPressed: () {
                  Get.toNamed(RouteHelper.getHelpSupportRoute());
                }),
                const SizedBox(
                  height: 7,
                ),
                const SizedBox(
                  height: 7,
                ),
                _itemList(context, icon: Icons.logout, title: "Logout",
                    onPressed: () {
                  authController.signOut(context);
                }),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _itemList(context, {icon, title, onPressed}) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey,
              size: 20,
            ),
            SizedBox(
              width: 14,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
