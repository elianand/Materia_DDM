import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

enum UserAccessLevel {adminLevel, userLevel, createAccount}

class UserModel  {

  final String idUser;

  final int idComp;
  final String name;
  final String lastname;
  final String email;
  final String username;
  final String country;
  final String phoneNum;
  final UserAccessLevel accessLevel;
  final int? age;

  UserModel ({
      required this.idUser,
      required this.idComp,
      required this.name,
      required this.lastname,
      required this.email,
      required this.username,
      required this.country,
      required this.phoneNum,
      required this.accessLevel,
      this.age = 0,
  });

  // Voy a convertir el modelo en una entidad User
  User toEntity() {
    return User(
      idUser: idUser,
      idComp: idComp,
      name: name,
      lastname: lastname,
      email: email,
      username: username,
      country: country,
      phoneNum: phoneNum,
      accessLevel: switch(accessLevel) {
        UserAccessLevel.adminLevel => "admin",
        UserAccessLevel.userLevel => "user",
        UserAccessLevel.createAccount => "create",
      },
      age: age,
    );
  }


  // Ahora creamos un modelo a partir de una entidad de dominio User
  factory UserModel.fromEntity(User user) {
    return UserModel(
      idUser: user.idUser,
      idComp: user.idComp,
      name: user.name,
      lastname: user.lastname,
      email: user.email,
      username: user.username,
      country: user.country,
      phoneNum: user.phoneNum,
      accessLevel: switch(user.accessLevel) {
        "admin" => UserAccessLevel.adminLevel,
        "user" => UserAccessLevel.userLevel,
        "create" => UserAccessLevel.createAccount,
        _  => UserAccessLevel.createAccount,
      },
      age: user.age,
    );
  }

  String getAccessLevelStr() {
    switch(accessLevel) {
      case UserAccessLevel.adminLevel:
        return "Admin level";
      case UserAccessLevel.userLevel:
        return "User level";
      case UserAccessLevel.createAccount:
        return "Create Account";
    }
  }

  UserAccessLevel getAccessLevelE(String accessLevelStr) {
    switch(accessLevelStr) {
      case "Admin level":
        return UserAccessLevel.adminLevel;
      case "User level":
        return UserAccessLevel.userLevel;
      case "Create Account":
        return UserAccessLevel.createAccount;
      default:
        return UserAccessLevel.userLevel;
    }
  }


  Map<String, dynamic> toFirestore() {
    return {
      'idUser': idUser,
      'idComp': idComp,
      'name' : name,
      'lastname' : lastname,
      'email' : email,
      'username' : username,
      'country' : country,
      'phoneNum' : phoneNum,
      'accessLevel' : switch(accessLevel) {
        UserAccessLevel.adminLevel => "admin",
        UserAccessLevel.userLevel => "user",
        UserAccessLevel.createAccount => "create",
      },
      if(age != null )'age' : age,
    };
  }

  static UserModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return UserModel(
      idUser: data?['idUser'] ?? "none",
      idComp: data?['idComp'] ?? 0,
      name: data?['name'] ?? "",
      lastname: data?['lastname'] ?? "none",
      email: data?['email'] ?? "none",
      username: data?['username'] ?? "none",
      country: data?['country'] ?? "none",
      phoneNum: data?['phoneNum'] ?? "none",
      accessLevel: switch(data?['accessLevel'] ?? "create") {
        "admin" => UserAccessLevel.adminLevel,
        "user" => UserAccessLevel.userLevel,
        "create" => UserAccessLevel.createAccount,
        _  => UserAccessLevel.createAccount,
      },
      age: data?['age'] ?? 0,
    );
  }
}
