import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/machine_model.dart';
import '../../models/machine_record_model.dart';


class LocalMachineRecordDataSource {

  // Dependencias

  LocalMachineRecordDataSource();

  List<MachineRecordModel>? machineRecordList;

    
  Future<void> setMachineRecords(List<MachineRecordModel> machineRecordList) async {
    this.machineRecordList = machineRecordList;
  }

  Future<void> addMachineDetails(MachineModel machine) async {


    if(machineRecordList == null) {return;}


    final lastStatus = getLastStatusEvent(machineRecordList!);
    if(lastStatus != null) {
      machine.state = lastStatus.getStatus();
      // No es correcto esto pero lo voy a simplificar
      machine.stateTime = 5;
    }


    machine.timeActive = getProduccionDuration(machineRecordList!).inMinutes/60;
    machine.timeOnline = getMachineOnDuration(machineRecordList!).inMinutes/60;
    machine.timeOffline = 24 - machine.timeActive! - machine.timeOnline!;
    
    // Produccion total
    machine.produced = getTotalProduccion(machineRecordList!);
    machine.prodPerHour = machine.produced!.toDouble() / 24;
    machine.productivity = machine.produced!.toDouble() / machine.timeActive!.toDouble();


    machine.porcActive = machine.timeActive! * 100 / 24;
    machine.porcOffline = machine.timeOffline! * 100 / 24;
    machine.porcOnline = machine.timeOnline! * 100 / 24;
    
    getProdOverTimePoints(machineRecordList!, machine.prodOverTimeX, machine.prodOverTimeY);
    getTempOverTimePoints(machineRecordList!, machine.tempOverTimeX, machine.tempOverTimeY);
    
  }




  

  MachineRecordModel? getLastStatusEvent(List<MachineRecordModel> records) {

    // Primero vamos a filtrar todos los registros por los que sean de status
    List<MachineRecordModel> statusRecords = records
      .where((record) => record.idEvent == EventE.machineStatus)
      .toList();

    // Ordenamos los registros temporalmente
    statusRecords.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Vamos a retronar el primero, o null si no hay registros
    return statusRecords.isNotEmpty ? statusRecords.first : null;
  }

  int getTotalProduccion(List<MachineRecordModel> records) {
    return records
      .where((record) => record.idEvent == EventE.produced)
      .map((record) => record.value ?? 0)
      .reduce((total, valor) => total + valor);
  }

  Duration getProduccionDuration(List<MachineRecordModel> records) {

    // Ordenar los registros cronológicamente por timestamp
    records.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    Duration totalProductionTime = Duration.zero;
    Timestamp? prodInit;

    for(var record in records) {
      if(record.idEvent == EventE.machineStatus) {
        if(record.getStatus() == MachineStatusE.activeState) {
          // Iniciar o continuar un intervalo de producción
          prodInit ??= record.timestamp;

        }else if(prodInit != null) {
          // Termina el intervalo de producción al encontrar un valor diferente de 2
          totalProductionTime += record.timestamp.toDate().difference(prodInit.toDate());
          prodInit = null;  // Reiniciar para el próximo intervalo
        }
      }
    }

    // Si la máquina sigue en producción al final de la lista, cerrar el último intervalo
    if (prodInit != null) {
      totalProductionTime += records.last.timestamp.toDate().difference(prodInit.toDate());
    }

    return totalProductionTime;
  }

  Duration getMachineOnDuration(List<MachineRecordModel> records) {

    // Ordenar los registros cronológicamente por timestamp
    records.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    Duration totalStateTime = Duration.zero;
    Timestamp? inMyTargetTimestamp;

    for(var record in records) {
      if (record.getStatus() == MachineStatusE.onState) {

        // Iniciar o continuar un intervalo de producción
        inMyTargetTimestamp ??= record.timestamp;

      }else if (inMyTargetTimestamp != null) {
        // Termina el intervalo de producción al encontrar un valor diferente de 2
        totalStateTime += record.timestamp.toDate().difference(inMyTargetTimestamp.toDate());
        inMyTargetTimestamp = null;  // Reiniciar para el próximo intervalo
      }
      
    }

    // Si la máquina sigue en producción al final de la lista, cerrar el último intervalo
    if (inMyTargetTimestamp != null) {
      totalStateTime += records.last.timestamp.toDate().difference(inMyTargetTimestamp.toDate());
    }

    return totalStateTime;
  }

  Duration getMachineOffDuration(List<MachineRecordModel> records) {

    // Ordenar los registros cronológicamente por timestamp
    records.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    Duration totalStateTime = Duration.zero;
    Timestamp? inMyTargetTimestamp;

    for(var record in records) {
      if (record.getStatus() == MachineStatusE.offState || record.getStatus() == MachineStatusE.detachState) {

        // Iniciar o continuar un intervalo de producción
        inMyTargetTimestamp ??= record.timestamp;

      } else if (inMyTargetTimestamp != null) {
        // Termina el intervalo de producción al encontrar un valor diferente de 2
        totalStateTime += record.timestamp.toDate().difference(inMyTargetTimestamp.toDate());
        inMyTargetTimestamp = null;  // Reiniciar para el próximo intervalo
      }
      
    }

    // Si la máquina sigue en producción al final de la lista, cerrar el último intervalo
    if (inMyTargetTimestamp != null) {
      totalStateTime += records.last.timestamp.toDate().difference(inMyTargetTimestamp.toDate());
    }

    return totalStateTime;
  }

  void getProdOverTimePoints(List<MachineRecordModel> records, List<double> prodOverTimeX, List<double> prodOverTimeY) {

    prodOverTimeX.clear();
    prodOverTimeY.clear();

    // Asegurarse de que los registros estén ordenados cronológicamente
    records.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Inicializar la producción acumulada
    int cumulativeProduction = 0;

    for (var record in records) {
      // Verificar que el evento sea de producción
      if (record.idEvent == EventE.produced) {
        // Obtener el tiempo en horas desde el inicio del día
        DateTime dateTime = record.timestamp.toDate();
        double tiempoEnHoras = dateTime.hour + (dateTime.minute / 60.0);

        // Actualizar la producción acumulada
        cumulativeProduction += record.value ?? 0;

        // Agregar los valores a las listas
        prodOverTimeX.add(tiempoEnHoras);
        prodOverTimeY.add(cumulativeProduction.toDouble());
      }
    }
  }

  void getTempOverTimePoints(List<MachineRecordModel> records, List<double> tempOverTimeX, List<double> tempOverTimeY) {

    tempOverTimeX.clear();
    tempOverTimeY.clear();

    // Asegurarse de que los registros estén ordenados cronológicamente
    records.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    for (var record in records) {
      // Verificar que el evento sea de producción
      if (record.idEvent == EventE.produced) {
        // Obtener el tiempo en horas desde el inicio del día
        DateTime dateTime = record.timestamp.toDate();
        double tiempoEnHoras = dateTime.hour + (dateTime.minute / 60.0);

        // Agregar los valores a las listas
        tempOverTimeX.add(tiempoEnHoras);
        tempOverTimeY.add((record.value ?? 0).toDouble());
      }
    }
  }

}