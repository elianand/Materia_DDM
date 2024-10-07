import 'package:app_parcial1/domain/models/user.dart';


abstract class UsersRepository {

  //Funciones generalmente para cargar la base de datos
  Future<List<User>> getUsers();
}



final usersList = [
  User(
    idUser: 1,
    idComp: 1, 
    name: "Elian", 
    email: "elian@gmail.com", 
    password: "pass", 
    age: 20
  ),
  User(
    idUser: 2,
    idComp: 1, 
    name: "Julian", 
    email: "julian@gmail.com", 
    password: "pass", 
    age: 30
  ),
  User(
    idUser: 3,
    idComp: 2, 
    name: "Pablo", 
    email: "pablo@gmail.com", 
    password: "pass", 
    age: 40
  ),

];