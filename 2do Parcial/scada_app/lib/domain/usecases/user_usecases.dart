import '../../data/models/user_model.dart';
import '../repositories/users_repository.dart';

// Caso de uso de LoginUser
class UserLoginWithCredentials {

  final UserRepository repository;

  UserLoginWithCredentials(this.repository);

  Future<bool> call(String email, String password) async {
    return await repository.loginWithCredentials(email, password);
  }
}

// Caso de uso de CheckIfUserLoggedIn
class IsUserLoggedIn {
  
  final UserRepository repository;

  IsUserLoggedIn(this.repository);

  Future<bool> call() async {
    return await repository.isUserLoggedIn();
  }
}

class CheckUserSession {
  
  final UserRepository repository;

  CheckUserSession(this.repository);

  Future<bool> call() async {
    return await repository.isUserLoggedIn();
  }
}

class NeedCreateAccount {
  
  final UserRepository repository;

  NeedCreateAccount(this.repository);

  Future<bool> call() async {
    return await repository.isNeedCreateAccount();
  }
}

class SaveUserCredentials {
  
  final UserRepository repository;

  SaveUserCredentials(this.repository);

  Future<bool> call(String email, String password) async {
    return await repository.saveUserCredentials(email, password);
  }
}

class SaveCredentialsOldAccount {
  
  final UserRepository repository;

  SaveCredentialsOldAccount(this.repository);

  Future<void> call(String email, String password) async {
    await repository.saveCredentialsOldAccount(email, password);
  }
}

class CreateUserWithCredentials {

  final UserRepository repository;

  CreateUserWithCredentials(this.repository);

  Future<bool> call(String email, String password, String name, String username, String lastname, 
    String country, String phoneNum, String age) async {

    return await repository.createUserWithCredentials(email, password, name, username, lastname, 
      country, phoneNum, age);
  }
}

class GetUserData {

  final UserRepository repository;

  GetUserData(this.repository);

  Future<UserModel?> call() async {

    return await repository.getUserData();
  }
}

class UserLogout {

  final UserRepository repository;

  UserLogout(this.repository);

  Future<void> call() async {

    await repository.userLogout();
  }
}
