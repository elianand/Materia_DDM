import '../../domain/repositories/users_repository.dart';
import 'users_dao.dart';

import '../../domain/models/user.dart';
import '../../main.dart';

class LocalUsersRepository implements UsersRepository {
  // TODO - inject this DAO
  final UsersDao _usersDao = database.usersDao;

  @override
  Future<List<User>> getUsers() {
    return _usersDao.findAllUsers();
  }


}
