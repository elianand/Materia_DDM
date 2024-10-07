import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/services.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/users_repository.dart';

// Aca se implementan los futures del repositorio de maquinas


class JsonUsersRepository implements UsersRepository {
  
  @override
  Future<List<User>> getUsers() async {
    
    final jsonString = await rootBundle.loadString('assets/json/users.json');
    final jsonList = json.decode(jsonString) as List;
    final users = jsonList.map((json) => User.fromJson(json)).toList();
    return users;
  }

}
