import 'package:app_parcial1/domain/models/user.dart';


abstract class UsersRepository {

  //Funciones generalmente para cargar la base de datos
  Future<List<User>> getUsers();
}
