
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:last_roadi_app/controller/auth_controller.dart';
import 'package:last_roadi_app/models/user_model.dart';
import 'package:last_roadi_app/utiles/preference.dart';
import 'package:last_roadi_app/widgets/custom_button.dart';
import 'package:last_roadi_app/widgets/custom_snackbar.dart';
import 'package:last_roadi_app/widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

  UserModel? model;
  Preference storage = Preference.shared;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            "Change Password".tr,
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
        body: Container(
          // color: Colors.grey,

          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: GetBuilder<AuthController>(builder: (authController) {
              return SingleChildScrollView(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        hintText: 'Current password'.tr,
                        controller: _currentPasswordController,
                        inputAction: TextInputAction.done,
                        obscureText: _isObscure ? true : false,
                        textColor: Colors.black,
                        inputType: _isObscure
                            ? TextInputType.visiblePassword
                            : TextInputType.text,
                        prefixIcon: Icons.lock,
                        isPassword: true,
                        divider: true,
                        suffixIcon: IconButton(
                          onPressed: () {
                            print(_isObscure);
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      CustomTextField(
                        hintText: 'Password'.tr,
                        controller: _passwordController,
                        inputAction: TextInputAction.done,
                        obscureText: _isObscure ? true : false,
                        inputType: _isObscure
                            ? TextInputType.visiblePassword
                            : TextInputType.text,
                        prefixIcon: Icons.lock,
                        isPassword: true,
                        textColor: Colors.black,
                        divider: true,
                        suffixIcon: IconButton(
                          onPressed: () {
                            print(_isObscure);
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      CustomTextField(
                        hintText: 'Confirm password'.tr,
                        controller: _confirmPasswordController,
                        obscureText: _isObscure ? true : false,
                        inputAction: TextInputAction.done,
                        textColor: Colors.black,
                        inputType: _isObscure
                            ? TextInputType.visiblePassword
                            : TextInputType.text,
                        prefixIcon: Icons.lock,
                        isPassword: true,
                        suffixIcon: IconButton(
                          onPressed: () {
                            print(_isObscure);
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        onSubmit: (text) => _update(authController),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      !authController.isLoading
                          ? Container(
                              margin: const EdgeInsets.all(10),
                              child: CustomButton(
                                buttonText: 'update'.tr,
                                onPressed: () => _update(authController),
                              ),
                            )
                          : Center(child: CircularProgressIndicator()),
                      SizedBox(
                        height: 20,
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
    String _currentPassword = _currentPasswordController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();

    if (_currentPassword.isEmpty) {
      showCustomSnackBar('current password is wrong'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password should be'.tr);
    } else if (_password != _confirmPassword) {
      showCustomSnackBar('confirm password does not matched'.tr);
    } else {
      authController.changePassword(context, _currentPassword, _password);
    }
  }
}
