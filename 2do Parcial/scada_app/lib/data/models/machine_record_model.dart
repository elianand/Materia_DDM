import 'package:cloud_firestore/cloud_firestore.dart';

import 'machine_model.dart';

enum EventE {machineStatus, produced, temp}

// En machineStatus
// Valor 0 es maquina apagada
// Valor 1 es maquina encendida sin producir
// Valor 2 es maquina encendida produciendo

class MachineRecordModel {

  final int id;
  final int idMachine;
  final Timestamp timestamp;
  final EventE idEvent;
  final int? value;

  MachineRecordModel({
    required this.id,
    required this.idMachine,
    required this.timestamp,
    required this.idEvent,
    this.value,
  });


  MachineStatusE getStatus() {
    switch(value) {
      case 0:
        return MachineStatusE.offState;
      case 1: 
        return MachineStatusE.onState;
      case 2: 
        return MachineStatusE.activeState;
      case 3: 
        return MachineStatusE.detachState;
      default: 
        return MachineStatusE.offState;
    }
  }

  
  Map<String, dynamic> toFirestore() {
    return {
      'recordId': id,
      'idMachine': idMachine,
      'timestamp' : timestamp,
      'idEvent' : switch(idEvent) {
        EventE.machineStatus => "status",
        EventE.produced => "produce",
        EventE.temp => "temp",
      },
      'value' : value,
    };
  }

  static MachineRecordModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return MachineRecordModel(
      id: data?['recordId'] ?? 0,
      idMachine: data?['idMachine'] ?? 0,
      timestamp: data?['timestamp'] ?? "",
      idEvent: switch(data?['idEvent'] ?? "status") {
        "status" => EventE.machineStatus,
        "produce" => EventE.produced,
        "temp" => EventE.temp,
        _  => EventE.machineStatus,
      },
      value: data?['value'] ?? 0,
    );
  }

}