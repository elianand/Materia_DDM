//import "package:floor/floor.dart";
//import 'package:cloud_firestore/cloud_firestore.dart';

//enum UserAccessLevel {adminLevel, userLevel, createAccount}

//@entity
class User {

  //@PrimaryKey(autoGenerate: true)
  final String idUser;

  final int idComp;
  final String name;
  final String lastname;
  final String email;
  final String username;
  final String country;
  final String phoneNum;
  //final String password;
  final String accessLevel;
  final int? age;

  User({
      required this.idUser,
      required this.idComp,
      required this.name,
      required this.lastname,
      required this.email,
      required this.username,
      required this.country,
      required this.phoneNum,
      //required this.password,
      required this.accessLevel,
      this.age = 0,
  });

/*
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

  static User fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return User(
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
*/

/*
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idComp: json['idComp'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      age: json['age']
    );
  }

  */
}
