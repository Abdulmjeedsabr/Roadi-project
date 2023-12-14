import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:last_roadi_app/controller/auth_controller.dart';
import 'package:last_roadi_app/models/user_model.dart';
import 'package:last_roadi_app/utiles/app_constants.dart';
import 'package:last_roadi_app/utiles/preference.dart';
import 'package:last_roadi_app/widgets/custom_button.dart';
import 'package:last_roadi_app/widgets/custom_snackbar.dart';
import 'package:last_roadi_app/widgets/custom_text_field.dart';

class UpdateUserInfoScreen extends StatefulWidget {
  const UpdateUserInfoScreen({Key? key}) : super(key: key);
  @override
  State<UpdateUserInfoScreen> createState() => _UpdateUserInfoScreenState();
}

class _UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  UserModel? model;
  Preference storage = Preference.shared;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  _loadProfileData() async {
    userId = storage.getString(AppConstants.USER_ID);
    final authController = Get.find<AuthController>();

    try {
      await authController.userInfo(userId);
      final userData = authController.userData;

      if (userData != null) {
        // Use the null-aware operator to avoid null pointer errors.
        _usernameController.text = userData.username ?? '';
        _emailController.text = userData.email ?? '';
      }
    } catch (error) {
      // Handle errors or display a message if needed.
      print('Error loading profile data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: GoogleFonts.cairo(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: true,
          elevation: 0.3,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.grey[50],
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: GetBuilder<AuthController>(builder: (authController) {
              return authController.isgetDataLoading
                  ? CircularProgressIndicator()
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        width: context.width > 700 ? 700 : context.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 30.0,
                            ),
                            CustomTextField(
                              hintText: 'Username',
                              controller: _usernameController,
                              inputType: TextInputType.text,
                              prefixIcon: Icons.person,
                              textColor: Colors.black,
                              divider: true,
                            ),
                            CustomTextField(
                              hintText: 'email',
                              controller: _emailController,
                              inputType: TextInputType.emailAddress,
                              prefixIcon: Icons.email,
                              textColor: Colors.black,
                              isEnabled: false,
                              divider: false,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            !authController.isLoading
                                ? Container(
                                    margin: const EdgeInsets.all(10),
                                    child: CustomButton(
                                      buttonText: 'Update',
                                      onPressed: () => _update(authController),
                                    ),
                                  )
                                : Center(child: CircularProgressIndicator()),
                            const SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    );
            }),
          ),
        ));
  }

  void _update(AuthController authController) async {
    String _username = _usernameController.text.trim();

    if (_username.isEmpty) {
      showCustomSnackBar('enter your first');
    } else {

      authController
          .updateUserInfo(userId,
              username: _username)
          .then((status) async {});
    }
  }
}
