import 'dart:async';
import 'dart:math';
import 'package:app_parcial1/domain/models/machine.dart';
import 'package:flutter/material.dart';
import '../../data/entities/local_machines_repository.dart';

class DataGenerator {
  Timer? timer;
  final Duration intervalo; // Intervalo para el Timer
  late int idType;
  final int id;
  
  // Este lo voy a usar para trakear la cantidad de piezas producidas
  int val = 0;

  DataGenerator({this.intervalo = const Duration(seconds: 5), required this.id, required this.idType}); // Intervalo por defecto de 5 segundos

  void start() {

    timer = Timer.periodic(intervalo, (Timer timer) {
      _timerPeriodico();

      debugPrint("Generacion de valores");

    });
  }

  void stop() {
    timer?.cancel(); // Detiene el Timer
  }

  
  void _timerPeriodico() async {
    int temp, pressure, produced;
    int active;

    switch(idType) {
      case 1:
        // La temperatura va desde 30 a 100 grados
        // Si es mayor a 80 grados se va a indicar en rojo
        temp = Random().nextInt(70) + 30;
        
        // La presion va desde 25 a 50 bar
        // Si es mayor a 40 grados se va a indicar en rojo
        pressure = Random().nextInt(25) + 25;

        produced = val + Random().nextInt(2);
        val = produced;

        InjectionMolding? machine = await LocalMachinesRepository().getInyectMoldMachineById(id);

        try {
          InjectionMolding? newMachine = InjectionMolding(id: machine!.id, brand: machine.brand, description: machine.description, pressure: pressure, produced: produced, temp: temp, posterUrl: machine.posterUrl);
          await LocalMachinesRepository().updateInyectMoldMachine(newMachine);
          InjectionMolding? updateMachine = await LocalMachinesRepository().getInyectMoldMachineById(id);
          debugPrint(updateMachine!.pressure.toString());
        } catch(e) {
          stop();
          debugPrint("Deteniendo el generador $e");
        }

      case 2:
        active = Random().nextInt(2);

        Crusher? machine = await LocalMachinesRepository().getCrusherMachineById(id);
        
        try {

          Crusher? newMachine = Crusher(id: machine!.id, brand: machine.brand, description: machine.description, capacity: machine.capacity, speed: machine.speed, active: active, posterUrl: machine.posterUrl);
          await LocalMachinesRepository().updateCrusherMachine(newMachine);
          Crusher? updateMachine = await LocalMachinesRepository().getCrusherMachineById(id);
          debugPrint(updateMachine!.active.toString());

        } catch(e) {
          stop();
          debugPrint("Deteniendo el generador $e");
        }
      default: 
        return;
    }
  }
}