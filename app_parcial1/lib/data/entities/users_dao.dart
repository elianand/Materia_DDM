import 'package:floor/floor.dart';

import '../../domain/models/user.dart';


@dao
abstract class UsersDao {

  @Query('SELECT * FROM User')
  Future<List<User>> findAllUsers();

}
