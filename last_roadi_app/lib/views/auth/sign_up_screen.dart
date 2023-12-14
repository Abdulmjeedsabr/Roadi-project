import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:last_roadi_app/controller/auth_controller.dart';
import 'package:last_roadi_app/utiles/app_constants.dart';
import 'package:last_roadi_app/utiles/route_helper.dart';
import 'package:last_roadi_app/widgets/custom_button.dart';
import 'package:last_roadi_app/widgets/custom_snackbar.dart';
import 'package:last_roadi_app/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  String _countryDialCode = '+966';
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
                          SizedBox(
                            height: 30,
                          ),
                          Image.asset(Resources.logo_without_bg,
                              width: 200, height: 200),
                          const SizedBox(height: 25),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Column(children: [
                              CustomTextField(
                                hintText: 'Username',
                                controller: _usernameController,
                                inputType: TextInputType.text,
                                prefixIcon: Icons.person,
                                divider: true,
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
                                hintText: 'Email',
                                controller: _emailController,
                                inputType: TextInputType.emailAddress,
                                prefixIcon: Icons.email,
                                divider: true,
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
                              ),
                              CustomTextField(
                                hintText: 'Confirm password',
                                controller: _confirmPasswordController,
                                focusNode: _confirmPasswordFocus,
                                obscureText: _isObscure ? true : false,
                                inputAction: TextInputAction.done,
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
                                onSubmit: (text) =>
                                    _register(authController, _countryDialCode),
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
                                      buttonText: 'Sign Up',
                                      onPressed: () => _register(
                                          authController, _countryDialCode),
                                    )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: CustomButton(
                                      border: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 3),
                                      buttonText: 'Sign In',
                                      transparent: true,
                                      onPressed: () => Get.toNamed(
                                          RouteHelper.getLoginRoute()),
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

  void _register(AuthController authController, String countryCode) async {
    String _username = _usernameController.text.trim();
    String _email = _emailController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();

    if (_username.isEmpty) {
      showCustomSnackBar('Enter Your name');
    } else if (_email.isEmpty) {
      showCustomSnackBar('enter email address');
    } else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter a valid email address');
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter password');
    } else if (_password.length < 6) {
      showCustomSnackBar('password should be more than 6 characters');
    } else if (_password != _confirmPassword) {
      showCustomSnackBar('confirm password does not matched');
    } else {

      authController
          .userRegister(
              name: _username,
              email: _email,
              password: _password)
          .then((status) async {});
    }
  }

}
