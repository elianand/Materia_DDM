import '../../domain/repositories/users_repository.dart';
import '../models/user_model.dart';
import '../sources/local/user_local_data_source.dart';
import '../sources/remote/firebase_user_data_source.dart';

class UserRepositoryImpl implements UserRepository {

  final FirebaseUserDataSource firebaseDataSource;
  final LocalUserDataSource localUserDataSource;

  UserRepositoryImpl(this.firebaseDataSource, this.localUserDataSource);

  @override
  Future<bool> loginWithCredentials(String email, String password) async {
    final logged = await firebaseDataSource.loginWithCredentials(email, password);
    if(logged == false) {return false;}

    final userModel = await firebaseDataSource.getUserData();
    if(userModel != null) {
      localUserDataSource.saveUserData(userModel);
      return true;
    }

    return false;
  }

  @override
  Future<bool> checkUserForAutoLogin() async {

    // Probamos si estamos logueados en firebase    
    final alreadyLoggedInFirebase = await firebaseDataSource.isUserLoggedIn();

    if(!alreadyLoggedInFirebase) {

      // Como no estamos loggeados vamos a buscar las credenciales con encrypted preferences
      final userCredentials = await localUserDataSource.getUserSavedCredentialsForAutoLogin();

      if(userCredentials == null) {
        return false;
      }

      // Realizamos el login en firebase con esta credenciales
      await firebaseDataSource.loginWithCredentials(userCredentials['email'] ?? "", userCredentials['password'] ?? "");
      
      // Volvemos a intentar si ahora si nos loggeamos
      final signInFirebase = await firebaseDataSource.isUserLoggedIn();

      if(!signInFirebase) {
        return false;
      }
    }

    // Si todo salio bien y estamos loggeados

    final myUser = await firebaseDataSource.getUserData();
    if(myUser == null) {
      // Aca debemos hacer un logout
      return false;
    }
    await localUserDataSource.saveUserData(myUser);

    return true;
  }

  @override
  Future<bool> isUserLoggedIn() async {

    final loggedInFirebase = await firebaseDataSource.isUserLoggedIn();

    if(loggedInFirebase) {

      final myUser = await firebaseDataSource.getUserData();
      if(myUser == null) {
        // Aca debemos hacer un logout
        return false;
      }
      await localUserDataSource.saveUserData(myUser);
      
      return true;
    }

    return false;
  }


  @override
  Future<bool> saveUserCredentials(String email, String password) async {

    return await localUserDataSource.saveUserCredentials(email, password);
  }

  @override
  Future<bool> isNeedCreateAccount() async {

    return await localUserDataSource.isNeedCreateAccount();
  }

  @override
  Future<UserModel?> getUserData() async {
    return await localUserDataSource.getUserData();
  }
  
  @override
  Future<void> saveCredentialsOldAccount(String email, String password) async {
    final user = await firebaseDataSource.getUserData();
    await localUserDataSource.saveCredentialsOldAccount(email, password, user);
  }


  @override
  Future<bool> createUserWithCredentials(String email, String password, String name, 
    String username, String lastname, String country, String phoneNum, String age) async {

    final oldAccountData = await localUserDataSource.getCredentialsOldAccount();

    // Creamos la nueva cuenta
    await firebaseDataSource.createAccountWithCredentials(email, password);

    // Nos loggeamos en la cuenta anterior 
    await firebaseDataSource.loginWithCredentials(oldAccountData["email"] ?? "", 
      oldAccountData["password"] ?? "");
    // La borramos
    await firebaseDataSource.deleteAccount();

    // Ahora nos loggeamos en la nueva cuenta
    final logged = await firebaseDataSource.loginWithCredentials(email, password);
    if(logged == false) {return false;}

    final acessLevel = oldAccountData["accessLevel"] as UserAccessLevel;
    final idComp = oldAccountData["idComp"] as int;
    final userAge = int.parse(age);
    final userId = await firebaseDataSource.getUserId();
    if(userId == null) {return false;}
    final oldUserId = oldAccountData["userId"] as String;

    final newUser = UserModel(name: name, lastname: lastname, country: country, phoneNum: phoneNum, 
      email: email, age: userAge, idComp: idComp, idUser: userId, username: username, 
      accessLevel: acessLevel);

    await firebaseDataSource.updateUserDataWithId(oldUserId, newUser);


    await localUserDataSource.saveUserData(newUser);

    
    return true;
  }

  @override
  Future<int?> getUserIdComp() async {
    final userData = await localUserDataSource.getUserData();

    if(userData == null) {
      return null;
    }

    return userData.idComp; 
  }

  @override
  Future<bool> isUserAdminLvl() async {

    final userData = await localUserDataSource.getUserData();

    if(userData == null) {
      return false;
    }

    if(userData.accessLevel == UserAccessLevel.adminLevel) {
      return true;
    }

    return false; 
  }

  @override
  Future<void> userLogout() async {
    await localUserDataSource.userlogout();
    await firebaseDataSource.userlogout();
  }

}