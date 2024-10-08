import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_parcial1/config/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/entities/local_machines_repository.dart';
import '../data/entities/local_users_repository.dart';
import '../domain/models/machine.dart';
import '../domain/models/user.dart';


// Este es un provider de tipo AppTheme
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) => ThemeNotifier());

// Hay que modificar el main.dart para que funcione
class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme());

  void toggleDarkMode() {
    state = state.copyWith(!state.isDarkMode);
  }
}



// Provider del Usuario

final userDataProvider = StateNotifierProvider<UserProvider, User>((ref) => UserProvider(User(idUser: 0, idComp: 0, name: "", email: "", password: "")));

class UserProvider extends StateNotifier<User> {
  UserProvider(super.user);

  List<User>? userList;
  bool autoLoginOk = false;


  int getUserId() {
    return state.idUser!;
  }

  User getUser() {
    return state;
  }

  bool isAutoLoginOk() {
    return autoLoginOk;
  }


  bool attempLogin(String username, String pass, bool saveCredentials) {

    User? user = userList!.firstWhereOrNull((elem) => elem.name == username && elem.password == pass);

    if(user != null) {
      state = user;

      return true;
    }else {
      return false;
    }
  }

  Future saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('autoLogin', true);
    await prefs.setString('username', state.name);
    await prefs.setString('pass', state.password);
  }

  Future getUsersListReady() {
    return Future.delayed(
      const Duration(seconds: 1), () async {
        try {
          userList = await LocalUsersRepository().getUsers();
          _chequeoAutoLoginUsuario(userList!);
        } catch (e) {
          debugPrint("Error $e");
        }
      },
    );
  }

  void _chequeoAutoLoginUsuario(List<User> usersList) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    bool login = prefs.getBool("autoLogin") ?? false;

    if(login) {

      String? username = prefs.getString('username');
      String? pass = prefs.getString('pass');

      User? user = usersList.firstWhereOrNull((elem) => elem.name == username && elem.password == pass);

      if(user != null){
        autoLoginOk = true;
        state = user;
      }else {
        await prefs.setBool('autoLogin', false);
        autoLoginOk = false;
      }
    }else {
      autoLoginOk = false;
    }
  }

  
  Future<void> logout() {
    return Future.delayed(
      const Duration(seconds: 2), () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('autoLogin', false);
        autoLoginOk = false;
      },
    );
  }
}


/// Provider de las maquinas
enum ProviderState {idle, loading, success, error}

class MachinesState {
  List<Machine>? machines;
  ProviderState requestState;
  Machine? machine;
  List<InjectionMolding>? injMoldMachines;
  List<Crusher>? crusherMachines;

  int? machineDetailId;
  int? machineDetailType;
  Object? machineDetail;


  MachinesState({
    required this.machine,
    required this.machines,
    required this.injMoldMachines,
    required this.crusherMachines,
    required this.requestState,
    required this.machineDetail,
    required this.machineDetailId,
    required this.machineDetailType
  });

  MachinesState copyWith({
      List<Machine>? machines, 
      Machine? machine, 
      List<InjectionMolding>? injMoldMachines, 
      List<Crusher>? crusherMachines,
      ProviderState? requestState,
      Object? machineDetail,
    }) {

    return MachinesState(
      machine: machine ?? this.machine,
      machines: machines ?? this.machines,
      injMoldMachines: injMoldMachines ?? this.injMoldMachines,
      crusherMachines: crusherMachines ?? this.crusherMachines,
      requestState: requestState ?? this.requestState,
      machineDetail: machineDetail?? this.machineDetail,
      machineDetailId: machineDetailId,
      machineDetailType: machineDetailType
    );
  }

  List<Machine>? getMachines() {
    return machines;
  }

  Machine? getMachine() {
    return machine;
  }

  List<int> getListTypeOfMachines() {

    // Vamos a devolver una lista de la cantidad de maquinas
    // por tipo

    // Aca vamos a inicializar la lista
    List<int> listMachineTypes = List<int>.filled(2, 0);    // Dos elementos
    
    // Vamos a empezar a contar
    for(var elem in machines!) {
      listMachineTypes[elem.idType-1]++;
    } 
    return listMachineTypes;
  }

  List<InjectionMolding>? getInyectionMoldingMachines() {
    return injMoldMachines;
  }

  List<Crusher>? getCrusherMachines() {
    return crusherMachines;
  }

  Object? getMachineDetail() {
    return machineDetail;
  }

  void setMachineDetailIdAndType(int id, int idType) {
    machineDetailId = id;
    machineDetailType = idType;
  }

  void cleanMachineDetail() {
    machineDetail = null;
  }
  
  int getFreeMachineId() {
    int newId = 1;

    machines?.sort((a, b) => a.id.compareTo(b.id));

    for(var machine in machines!) {
      if (machine.id == newId) {
        newId++;
      }else if (machine.id > newId) {
        return newId;
      }
    }

    return newId;
  }
}


final machinesDataProvider = StateNotifierProvider<MachineProvider, MachinesState>((ref) => MachineProvider(ref));

class MachineProvider extends StateNotifier<MachinesState> {
  MachineProvider(this.ref) : super(
    MachinesState(
      machine: null, 
      machines: [], 
      injMoldMachines: [], 
      crusherMachines: [], 
      requestState: ProviderState.idle,
      machineDetail: null,
      machineDetailId: null,
      machineDetailType: null
    ));

  final Ref ref;

  Future<void> getMachines() async {
    state = state.copyWith(requestState: ProviderState.loading);

    try {
      final machines = await LocalMachinesRepository().getMachines();
      state = state.copyWith(machines: machines, requestState: ProviderState.success);
    } catch (e) {
      state = state.copyWith(requestState: ProviderState.error);
    }
  }

  Future<void> getMachineById(int id) async {
    state = state.copyWith(requestState: ProviderState.loading);

    try {
      final machine = await LocalMachinesRepository().getMachineById(id);
      state = state.copyWith(machine: machine, requestState: ProviderState.success);
    } catch (e) {
      state = state.copyWith(requestState: ProviderState.error);
    }
  }

  Future<void> getMachinesByIdComp(int idComp) async {
    state = state.copyWith(requestState: ProviderState.loading);

    try {
      final machines = await LocalMachinesRepository().getMachinesByIdComp(idComp);
      state = state.copyWith(machines: machines, requestState: ProviderState.success);
    } catch (e) {
      state = state.copyWith(requestState: ProviderState.error);
    }
  }

  Future<void> getMachineByIdCompAndIdType(int idComp, int idType) async {
    state = state.copyWith(requestState: ProviderState.loading);

    try {
      switch(idType) {
        case 1:
          final machines = await LocalMachinesRepository().getInyectMoldMachineByIdComp(idComp);
          state = state.copyWith(injMoldMachines: machines, requestState: ProviderState.success);
        break;

        case 2:
          final machines = await LocalMachinesRepository().getCrusherMachineByIdComp(idComp);
          state = state.copyWith(crusherMachines: machines, requestState: ProviderState.success);
        break;
      }
      
    } catch (e) {
      state = state.copyWith(requestState: ProviderState.error);
    }
  }

  Future<void> getMachineDetail() async {
    if (state.machineDetailId == null || state.machineDetailType == null) {
      state = state.copyWith(requestState: ProviderState.error);
      return;
    }


    state = state.copyWith(requestState: ProviderState.loading);

    try {
      switch(state.machineDetailType) {
        case 1:
          log("id: ${state.machineDetailId} , idType ${state.machineDetailType}");
          final machine = await LocalMachinesRepository().getInyectMoldMachineById(state.machineDetailId!);
          state = state.copyWith(machineDetail: machine, requestState: ProviderState.success);
        break;

        case 2:
          final machine = await LocalMachinesRepository().getCrusherMachineById(state.machineDetailId!);
          state = state.copyWith(machineDetail: machine, requestState: ProviderState.success);
        break;
      }
      
    } catch (e) {
      state = state.copyWith(requestState: ProviderState.error);
    }
  }

  void cleanMachineDetail() {
    state.machineDetail = null;
  }

  Future<void> insertInjMoldMachine(int idType, String brand, String description, int temp, int pressure, String? imagePath) async {

    state = state.copyWith(requestState: ProviderState.loading);

    List<int> machineIds = await LocalMachinesRepository().getAllMachineIds();

    int newId = 1;

    machineIds.sort();

    for(int id in machineIds) {
      if (id == newId) {
        newId++;
      }else if(id > newId) {
        break;
      }
    }

    int idComp = ref.read(userDataProvider).idComp;
    Machine newMachine = Machine(id: newId, idType: idType, brand: brand, idComp: idComp, description: description, posterUrl: imagePath);
    InjectionMolding newInjMold = InjectionMolding(id: newId, brand: brand, description: description, pressure: pressure, temp: temp, posterUrl: imagePath, produced: 0);

    try {

      await LocalMachinesRepository().insertMachine(newMachine);
      await LocalMachinesRepository().insertInjMoldMachine(newInjMold);

      state = state.copyWith(requestState: ProviderState.success);
    } catch (e) {
      state = state.copyWith(requestState: ProviderState.error);
    }
  }

  Future<void> insertCrusherMachine(int idType, String brand, String description, int capacity, int speed, String? imagePath) async {

    state = state.copyWith(requestState: ProviderState.loading);

    List<int> machineIds = await LocalMachinesRepository().getAllMachineIds();

    int newId = 1;

    machineIds.sort();

    for(int id in machineIds) {
      if (id == newId) {
        newId++;
      }else if(id > newId) {
        break;
      }
    }
    

    int idComp = ref.read(userDataProvider).idComp;
    Machine newMachine = Machine(id: newId, idType: idType, brand: brand, idComp: idComp, description: description, posterUrl: imagePath);
    Crusher newCrusher = Crusher(id: newId, brand: brand, description: description, capacity: capacity, speed: speed, posterUrl: imagePath, active: 0);

    try {

      await LocalMachinesRepository().insertMachine(newMachine);
      await LocalMachinesRepository().insertCrusherMachine(newCrusher);

      state = state.copyWith(requestState: ProviderState.success);
    } catch (e, stackTrace) {
      state = state.copyWith(requestState: ProviderState.error);
      log('Error capturado: $e');
      log('Stack trace: $stackTrace');
    }
  }

  
  Future<void> deleteMachine(int id, int idType) async {

    state = state.copyWith(requestState: ProviderState.loading);
    int idComp = ref.read(userDataProvider).idComp;

    try {

      // Se borra la maquina
      await LocalMachinesRepository().deleteMachine(id);



      switch(idType) {
        case 1: 
          //Se borra la maquina 
          await LocalMachinesRepository().deleteInjMoldMachine(id);
          //Se actualiza la lista
          await ref.read(machinesDataProvider.notifier).getMachineByIdCompAndIdType(idComp, 1);
          break;
        case 2:
          await LocalMachinesRepository().deleteCrusherMachine(id);
          await ref.read(machinesDataProvider.notifier).getMachineByIdCompAndIdType(idComp, 2);
          break;
      }

      // Actualiza la lista de máquinas
      ref.read(machinesDataProvider.notifier).getMachinesByIdComp(idComp);
      
      
      

      state = state.copyWith(requestState: ProviderState.success);
    } catch (e, stackTrace) {
      state = state.copyWith(requestState: ProviderState.error);
      log('Error capturado: $e');
      log('Stack trace: $stackTrace');
    }
  }
  
  int? getMachineDetailId() {
    return state.machineDetailId;
  }

  int? getMachineDetailType() {
    return state.machineDetailType;
  }
}

