import "package:floor/floor.dart";


@entity
class User {

  @PrimaryKey(autoGenerate: true)
  final int? idUser;

  final int idComp;
  final String name;
  final String email;
  final String password;
  final int? age;

  User({
      this.idUser,
      required this.idComp,
      required this.name,
      required this.email,
      required this.password,
      this.age = 0,
  });


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idComp: json['idComp'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      age: json['age']
    );
  }
}
