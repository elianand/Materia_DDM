import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';


class LocalUserDataSource {

  // Dependencias
  final EncryptedSharedPreferences encryptedPrefs;

  LocalUserDataSource(this.encryptedPrefs);

  UserModel? userModel;
  String? oldEmail;
  String? oldPass;
    

  Future<Map<String, String>?> getUserSavedCredentialsForAutoLogin() async {

    final sharedPrefs = await SharedPreferences.getInstance();

    try {

      final isLoggedIn = sharedPrefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {

        final userEmail = await encryptedPrefs.getString('email');
        final password = await encryptedPrefs.getString('password');

        if (userEmail != "" && password != "") {

          return {
            'email': userEmail,
            'password': password,
          };
          
        }
      }
    }catch(e) {
      debugPrint('Error retrieving credentials: $e');
    }

    return null;
  }

  Future<bool> saveUserCredentials(String email, String password) async {

    final sharedPrefs = await SharedPreferences.getInstance();

    await encryptedPrefs.setString('email', email);
    await encryptedPrefs.setString('password', password);

    await sharedPrefs.setBool('isLoggedIn', true);

    return true;
  }

  Future<void> saveUserData(userModel) async {
    this.userModel = userModel;
  }

  Future<bool> isNeedCreateAccount() async {

    if(userModel != null) {
      if(userModel!.name == "") {
        return true;
      }else {
        return false;
      }
    }else {
      throw Exception('No user account');
    }
  }

  Future<void> saveCredentialsOldAccount(String email, String password, user) async {
    userModel = user;
    oldEmail = email;
    oldPass = password;
  }

  Future<UserModel?> getUserData() async {
    return userModel;
  }


  Future<Map<String, dynamic>> getCredentialsOldAccount() async {
    if(oldEmail == null || oldPass == null || userModel == null) {
      throw Exception('App error in creating account');
    }

    return {
      'email': oldEmail!,
      'password': oldPass!,
      'idComp': userModel!.idComp,
      'accessLevel': userModel!.accessLevel,
      'userId': userModel!.idUser,
    };
  }

  Future<void> userlogout() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool('isLoggedIn', false);

    userModel = null;
  }
}