import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart' as cc;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:last_roadi_app/models/user_model.dart';
import 'package:last_roadi_app/utiles/app_constants.dart';
import 'package:last_roadi_app/utiles/preference.dart';
import 'package:last_roadi_app/utiles/route_helper.dart';
import 'package:last_roadi_app/widgets/custom_snackbar.dart';

class AuthController extends GetxController implements GetxService {
  bool isLoading = false;
  bool _notification = true;
  bool _acceptTerms = true;
  Preference storage = Preference.shared;

  Future userLogin({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    update();
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      print(value.toString());
      //initialize var userId to accessed and global from everywhere
      storage.setString(AppConstants.USER_ID, value.user!.uid);
      storage.setString(AppConstants.IS_LOGIN, '1');

      await cc.CometChat.login(value.user!.uid, AppConstants.COMETCHAT_AUTH_KEY,
          onSuccess: (cc.User user) {
        debugPrint("Login Successful : $user");
      }, onError: (cc.CometChatException e) {
        debugPrint("Login failed with exception:  ${e.message}");
      });

      await userInfo(value.user!.uid).then((username) {
        isLoading = false;
        update();
        showCustomSnackBar('Login Successfully!', isError: false);
        Get.offAndToNamed(RouteHelper.getInitialRoute(username: username));
      });
    }).catchError((error) {
      isLoading = false;
      update();
      if (error is FirebaseAuthException) {
        // Get the code property from the error.
        String code = error.code;
        switch (error.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
          case "account-exists-with-different-credential":
          case "email-already-in-use":
            error = "Email already used. Go to login page.";
            print(error);
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_WRONG_PASSWORD":
          case "wrong-password":
            error = "Wrong email/password combination.";
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_USER_NOT_FOUND":
          case "user-not-found":
            error = "No user found with this email.";
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_USER_DISABLED":
          case "user-disabled":
            error = "User disabled.";
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_TOO_MANY_REQUESTS":
          case "operation-not-allowed":
            error = "Too many requests to log into this account.";
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
          case "operation-not-allowed":
            error = "Server error, please try again later.";
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_INVALID_EMAIL":
          case "invalid-email":
            error = "Email address is invalid.";
            showCustomSnackBar(error.toString());
            break;
          default:
            error = "Register failed. Please try again.";
            showCustomSnackBar(error.toString());
            break;
        }
        print(error.toString());
        showCustomSnackBar(error.toString());
      } else {
        showCustomSnackBar('Something went wrong!');
      }
    });
  }

  Future<void> createCometChatUserAndLogin(String uid, String username) async {
    final user = cc.User(uid: uid, name: username);

    await cc.CometChat.createUser(user, AppConstants.COMETCHAT_AUTH_KEY,
        onSuccess: (user) async {
      print('Done creating!');
      print(user);
      await cc.CometChat.login(uid, AppConstants.COMETCHAT_AUTH_KEY,
          onSuccess: (cc.User user) {
        debugPrint("Login Successful : $user");
      }, onError: (cc.CometChatException e) {
        debugPrint("Login failed with exception:  ${e.message}");
      });
    }, onError: (cc.CometChatException? err) {
      print(err);
    });
  }

  Future userRegister({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    update();

//store data on firebase
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user);
      if (value.user != null) {
        createUser(
          uId: value.user!.uid,
          name: name,
          email: email,
        );
      }
    }).catchError((error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          error = "Email already used. Go to login page.";
          print(error);
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          error = "Wrong email/password combination.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          error = "No user found with this email.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          error = "User disabled.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          error = "Too many requests to log into this account.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          error = "Server error, please try again later.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          error = "Email address is invalid.";
          showCustomSnackBar(error.toString());
          break;
        default:
          error = "Register failed. Please try again.";
          showCustomSnackBar(error.toString());
          break;
      }
      isLoading = false;
      update();
    });
  }

//function to create user
  Future createUser({
    required String name,
    required String email,
    required String uId,
  }) async {
    UserModel model = UserModel.withId(
      username: name,
      email: email,
      image: "assets/images/avatar.jpg",
      id: uId,
      isVerfied: false,
      date: DateTime.now().toIso8601String(),
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId.toString())
        .set(model.toMap())
        .then((value) {
      createCometChatUserAndLogin(uId, name);
      isLoading = false;
      update();
      storage.setString(AppConstants.IS_LOGIN, '1');
      storage.setString(AppConstants.USER_NAME, name);
      storage.setString(AppConstants.USER_ID, uId.toString());
      showCustomSnackBar('Registration Successfully!', isError: false);
      Get.offAndToNamed(RouteHelper.getInitialRoute());
      print('Done');
    }).catchError((error) {
      //if something error in regiestration
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          error = "Email already used. Go to login page.";
          print(error);
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          error = "Wrong email/password combination.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          error = "No user found with this email.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          error = "User disabled.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          error = "Too many requests to log into this account.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          error = "Server error, please try again later.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          error = "Email address is invalid.";
          showCustomSnackBar(error.toString());
          break;
        default:
          error = "Register failed. Please try again.";
          showCustomSnackBar(error.toString());
          break;
      }
      print(error.toString());
    });
  }

  Future signOut(context) async {
    storage
        .remove(
      AppConstants.USER_ID,
    )
        .then((value) async {
      userData = null;
      cc.CometChat.logout(
          onSuccess: (String sucess) {},
          onError: (cc.CometChatException err) {});
      storage.remove(AppConstants.USER_NAME);
      FirebaseAuth.instance.signOut();
      showCustomSnackBar("Signout Successfully", isError: false);
      Get.offAndToNamed(RouteHelper.getLoginRoute());
    });
  }

  UserModel? userData;

  bool isgetDataLoading = true;

  Future<String> userInfo(userId) async {
    try {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId ?? storage.getString("userId"))
          .get();

      userData = UserModel.fromMap(documentSnapshot.data()!);
      print("username: " + userData!.username!);

      await storage.setString(AppConstants.USER_NAME, userData!.username!);
      isgetDataLoading = false;
      update();

      return userData!.username!;
    } catch (error) {
      isgetDataLoading = false;
      update();
      print(error.toString());
      throw error; // Rethrow the error to handle it higher up in the call stack if needed.
    }
  }

  Future updateUserInfo(userId, {username, idOrPassport, phone}) async {
    isLoading = true;
    update();
    FirebaseFirestore.instance.collection("users").doc(userId).update({
      "username": username,
    }).then((value) {
      userInfo(userId);
      isLoading = false;
      update();
      showCustomSnackBar('profile updated successfully', isError: false);
      Get.offAndToNamed(RouteHelper.getSettingsRoute());
    }).catchError((error) {
      isLoading = false;
      update();
      print(error.toString());
    });
  }

  void changePassword(
      context, String currentPassword, String newPassword) async {
    isLoading = true;
    update();
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: FirebaseAuth.instance.currentUser!.email!,
            password: currentPassword)
        .then((value) async {
      await value.user!.updatePassword(newPassword);
      showCustomSnackBar('password changed successfully'.tr, isError: false);
      Navigator.pop(context);
    }).catchError((err) {
      showCustomSnackBar('current password is wrong'.tr);
    });
    isLoading = false;
    update();
  }
}
