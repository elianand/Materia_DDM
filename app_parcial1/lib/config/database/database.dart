import 'dart:async';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../../data/entities/json_machines_repository.dart';
import '../../data/entities/json_users_repository.dart';
import '../../data/entities/machines_dao.dart';
import '../../data/entities/users_dao.dart';
import '../../domain/models/machine.dart';
import '../../domain/models/user.dart';

part 'database.g.dart';

@Database(
  version: 3,
  entities: [User, Machine, InjectionMolding, Crusher],
  //views: [MovieDetailed],
)

abstract class AppDatabase extends FloorDatabase {
  MachinesDao get machinesDao;
  UsersDao get usersDao;

  static Future<AppDatabase> create(String name) {

    return $FloorAppDatabase.databaseBuilder(name).addCallback(
      Callback(
        onCreate: (database, version) async {
          // This method is only called when the database is first created.
          await _prepopulateDb(database); 
        },
      ),
    ).build();
  }


  static Future<void> _prepopulateDb(sqflite.DatabaseExecutor database) async {
    // Pre-populate the database with machine and users from the JSON file.
    final repository = JsonMachinesRepository();
    final machines = await repository.getMachines();
    final injMoldMachines = await repository.getInjMoldMachines();
    final crusherMachines = await repository.getCrusherMachines();

    final usersRepo = JsonUsersRepository();
    final users = await usersRepo.getUsers();


    for (final machine in machines) {
      try {
      await InsertionAdapter(
        database,
        'Machine',
        (Machine item) => <String, Object?>{
          'id': item.id,
          'idType': item.idType,
          'idComp': item.idComp,
          'brand': null,
          'description': null,
          'posterUrl': null
        },
      ).insert(machine, OnConflictStrategy.replace);
      }catch(e) {
        debugPrint('Error $e');
      }
    }

    for (final machine in injMoldMachines) {
      try {
      await InsertionAdapter(
        database,
        'InjectionMolding',
        (InjectionMolding item) => <String, Object?>{
          'id': item.id,
          'brand': item.brand,
          'description': item.description,
          'posterUrl': item.posterUrl,
          'temp': item.temp,
          'pressure': item.pressure,
          'produced': item.produced,
        },
      ).insert(machine, OnConflictStrategy.replace);
      }catch(e) {
        debugPrint('Error $e');
      }
    }

    for (final machine in crusherMachines) {
      try {
      await InsertionAdapter(
        database,
        'Crusher',
        (Crusher item) => <String, Object?>{
          'id': item.id,
          'brand': item.brand,
          'description': item.description,
          'posterUrl': item.posterUrl,
          'speed': item.speed,
          'capacity': item.capacity,
          'active': item.active,
        },
      ).insert(machine, OnConflictStrategy.replace);
      }catch(e) {
        debugPrint('Error $e');
      }
    }


    for (final user in users) {
      try {
      await InsertionAdapter(
        database,
        'User',
        (User item) => <String, Object?>{
          'idComp': item.idComp,
          'name': item.name,
          'email': item.email,
          'password': item.password,
          'age': item.age,
        },
      ).insert(user, OnConflictStrategy.replace);
      }catch(e) {
        debugPrint('Error $e');
      }
    }
  }
}
