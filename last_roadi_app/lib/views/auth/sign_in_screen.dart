import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:last_roadi_app/controller/auth_controller.dart';
import 'package:last_roadi_app/utiles/app_constants.dart';
import 'package:last_roadi_app/utiles/route_helper.dart';
import 'package:last_roadi_app/widgets/custom_button.dart';
import 'package:last_roadi_app/widgets/custom_snackbar.dart';
import 'package:last_roadi_app/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController idOrPassportController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage('assets/image/bg.webp'),
                      fit: BoxFit.fill)),
              child: GetBuilder<AuthController>(builder: (authController) {
                return Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(Resources.logo_without_bg,
                              width: 200, height: 200),
                          const SizedBox(height: 25),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Column(children: [
                              CustomTextField(
                                hintText: 'Email',
                                controller: idOrPassportController,
                                inputType: TextInputType.emailAddress,
                                prefixIcon: Icons.email,
                                divider: true,
                                textColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      style: BorderStyle.solid,
                                      width: 10),
                                ),
                                activeBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      style: BorderStyle.solid,
                                      width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2),
                                ),
                              ),
                              CustomTextField(
                                hintText: 'Password',
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                inputAction: TextInputAction.done,
                                obscureText: _isObscure ? true : false,
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
                                    color: Colors.white,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      style: BorderStyle.solid,
                                      width: 10),
                                ),
                                activeBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      style: BorderStyle.solid,
                                      width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2),
                                ),
                                onSubmit: (text) => _login(authController),
                              ),
                            ]),
                          ),
                          SizedBox(height: 10.0),
                          !authController.isLoading
                              ? Container(
                                  margin: EdgeInsets.all(10),
                                  child: Row(children: [
                                    Expanded(
                                        child: CustomButton(
                                            border: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 3),
                                            buttonText: 'Sign In',
                                            onPressed: () =>
                                                _login(authController))),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: CustomButton(
                                      buttonText: 'Sign Up',
                                      transparent: true,
                                      border: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2),
                                      onPressed: () => Get.toNamed(
                                          RouteHelper.getRegisterRoute()),
                                    )),
                                  ]),
                                )
                              : Center(child: CircularProgressIndicator()),
                          SizedBox(height: 30),
                        ]),
                  ),
                );
              }),
            ),
          )),
    );
  }

  void _login(AuthController authController) async {
    String _email = idOrPassportController.text.trim();
    String _password = _passwordController.text.trim();

    if (_email.isEmpty) {
      showCustomSnackBar('enter_email');
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password');
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be');
    } else {
      authController
          .userLogin(email: _email, password: _password)
          .then((status) async {});
    }
  }
}
