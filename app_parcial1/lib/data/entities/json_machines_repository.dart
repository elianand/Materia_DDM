import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/services.dart';
import '../../domain/models/machine.dart';
import '../../domain/repositories/machines_repository.dart';

// Aca se implementan los futures del repositorio de maquinas


class JsonMachinesRepository implements MachinesRepository {
  
  @override
  Future<List<Machine>> getMachines() async {
    
    final jsonString = await rootBundle.loadString('assets/json/machinesRelacional.json');
    final jsonList = json.decode(jsonString) as List;
    final machines = jsonList.map((json) => Machine.fromJson(json)).toList();
    return machines;
  }

  @override
  Future<List<InjectionMolding>> getInjMoldMachines()  async {
    final jsonString = await rootBundle.loadString('assets/json/inyectionMolding_machines.json');
    final jsonList = json.decode(jsonString) as List;
    final machines = jsonList.map((json) => InjectionMolding.fromJson(json)).toList();
    return machines;
  }



  @override
  Future<List<Crusher>> getCrusherMachines() async {
    final jsonString = await rootBundle.loadString('assets/json/crusher_machines.json');
    final jsonList = json.decode(jsonString) as List;
    final machines = jsonList.map((json) => Crusher.fromJson(json)).toList();
    return machines;
  }



  @override
  Future<Machine> getMachineById(int id) async {
    final jsonString = await rootBundle.loadString('assets/json/machinesRelacional.json');
    final jsonList = json.decode(jsonString) as List;
    final machines = jsonList.map((json) => Machine.fromJson(json)).toList();
    final machine = machines.firstWhere((elem) => elem.id == id);
    return machine;
  }

  @override
  Future<InjectionMolding> getInyectMoldMachineById(int id) async {
    final jsonString = await rootBundle.loadString('assets/json/inyectionMolding_machines.json');
    final jsonList = json.decode(jsonString) as List;
    final machines = jsonList.map((json) => InjectionMolding.fromJson(json)).toList();
    final machine = machines.firstWhere((elem) => elem.id == id);
    return machine;
  }

  @override
  Future<Crusher> getCrusherMachineById(int id) async {
    final jsonString = await rootBundle.loadString('assets/json/crusher_machines.json');
    final jsonList = json.decode(jsonString) as List;
    final machines = jsonList.map((json) => Crusher.fromJson(json)).toList();
    final machine = machines.firstWhere((elem) => elem.id == id);
    return machine;
  }



  @override
  Future<List<Machine>?> getMachinesByIdComp(int idComp) {
    return Future.delayed(
      const Duration(seconds: 2),
      () async {
        final jsonString = await rootBundle.loadString('assets/json/machinesRelacional.json');
        final jsonList = json.decode(jsonString) as List;
        final machines = jsonList.map((json) => Machine.fromJson(json)).toList();
        final machinesComp = machines.where((elem) => elem.idComp == idComp).toList();
        return machinesComp;
      },
    );
  }

  @override
  Future<List<Machine>> getMachineByIdCompAndIdType(int idComp, int idType) {
    return Future.delayed(
      const Duration(seconds: 2),
      () async {
        final jsonString = await rootBundle.loadString('assets/json/machinesRelacional.json');
        final jsonList = json.decode(jsonString) as List;
        final machines = jsonList.map((json) => Machine.fromJson(json)).toList();
        final machinesComp = machines.where((elem) => (elem.idComp == idComp && elem.idType == 1)).toList();
        return machinesComp;
      },
    );
  }

  @override
  Future<List<InjectionMolding>> getInyectMoldMachineByIdComp(int idComp) {
    return Future.delayed(
      const Duration(seconds: 2),
      () async {
        // Lista de maquinas bajo el idComp
        final machines = await getMachinesByIdComp(idComp);
        final jsonString = await rootBundle.loadString('assets/json/inyectionMolding_machines.json');
        final jsonList = json.decode(jsonString) as List;
        final injMoldMachines = jsonList.map((json) => InjectionMolding.fromJson(json)).toList();
        // OJOOO, puse que estoy seguro que no va a ser null
        final injMoldSelect = injMoldMachines.where((injMold) {
          return machines!.any((machine) => machine.id == injMold.id);
        }).toList();
        return injMoldSelect;
      },
    );
  }

  @override
  Future<List<Crusher>> getCrusherMachineByIdComp(int idComp) {
    return Future.delayed(
      const Duration(seconds: 2),
      () async {
        final machines = await getMachinesByIdComp(idComp);
        final jsonString = await rootBundle.loadString('assets/json/crusher_machines.json');
        final jsonList = json.decode(jsonString) as List;
        final crusherMachines = jsonList.map((json) => Crusher.fromJson(json)).toList();
        //final machinesComp = machines.where((elem) => (elem.idComp == idComp && elem.idType == 2)).toList();
        // OJOOO, puse que estoy seguro que no va a ser null
        final crusherSelect = crusherMachines.where((crusher) {
          return machines!.any((machine) => machine.id == crusher.id);
        }).toList();
        return crusherSelect;
        
      },
    );
  }

  @override
  Future<List<int>> getAllMachineIds() {
    return Future.delayed(
      const Duration(seconds: 2),
      () async {
        final ids = await getAllMachineIds();
        return ids;
        
      },
    );
  }


/*
  @override
  Future<MovieDetailed> getMovieById(int id) async {
    final genres = await getGenres();
    final movies = await getMovies();

    final movie = movies.firstWhere((m) => m.id == id);
    final movieDetailed = MovieDetailed(
      id: movie.id,
      title: movie.title,
      overview: movie.overview,
      releaseDate: movie.releaseDate,
      genres: genres
          .where((g) => movie.genreIds.contains(g.id))
          .map((e) => e.name)
          .join(','),
      posterUrl: movie.posterUrl,
      backdropUrl: movie.backdropUrl,
      likes: movie.likes,
    );

    return Future.delayed(
      const Duration(seconds: 2),
      () => movieDetailed,
    );
  }
*/


  @override
  Future<void> insertMachine(Machine machine) {
    return Future.delayed(
      const Duration(seconds: 2),
      () => null,
    );
  }

  @override
  Future<void> updateMachine(Machine machine) {
    return Future.delayed(
      const Duration(seconds: 2),
      () => null,
    );
  }


  @override
  Future<void> insertInjMoldMachine(InjectionMolding machine) {
    return Future.delayed(
      const Duration(seconds: 2),
      () => null,
    );
  }

  @override
  Future<void> insertCrusherMachine(Crusher machine) {
    return Future.delayed(
      const Duration(seconds: 2),
      () => null,
    );
  }


  @override
  Future<void> deleteMachine(int id) {
    return Future.delayed(
      const Duration(seconds: 2),
      () => null,
    );
  }

  @override
  Future<void> deleteInjMoldMachine(int id) {
    return Future.delayed(
      const Duration(seconds: 2),
      () => null,
    );
  }

  @override
  Future<void> deleteCrusherMachine(int id) {
    return Future.delayed(
      const Duration(seconds: 2),
      () => null,
    );
  }

  @override
  Future<void> updateInyectMoldMachineById(int id, int temp, int pressure, int produced) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => null,
    );
  }

  @override
  Future<void> updateCrusherMachineById(int id, int active) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => null,
    );
  }

  @override
  Future<void> updateInyectMoldMachine(InjectionMolding machine) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => null,
    );
  }

  @override
  Future<void> updateCrusherMachine(Crusher machine) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => null,
    );
  }
  



}
