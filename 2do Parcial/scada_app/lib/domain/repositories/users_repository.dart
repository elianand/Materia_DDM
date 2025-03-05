import '../../data/models/user_model.dart';


abstract class UserRepository {

  /// --------- Para el login -----------------

  Future<bool> loginWithCredentials(String email, String password);
  Future<bool> isUserLoggedIn();
  Future<bool> saveUserCredentials(String email, String password);
  Future<UserModel?> getUserData();
  Future<bool> checkUserForAutoLogin();
  Future<bool> isNeedCreateAccount();
  Future<void> saveCredentialsOldAccount(String email, String password);

  Future<bool> createUserWithCredentials(String email, String password, String name, 
    String username, String lastname, String country, String phoneNum, String age);
  
  Future<void> userLogout();

  /// --------- Para el login -----------------


  /// --------- Para las companias -----------------
  Future<int?> getUserIdComp();

  /// --------- Para las maquinas -----------------
  Future<bool> isUserAdminLvl();
}