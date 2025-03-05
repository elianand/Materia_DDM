import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/machine_record_repository.dart';
import '../models/machine_model.dart';
import '../sources/local/machine_record_local_data_source.dart';
import '../sources/remote/firebase_machine_record_data_source.dart';

class MachineRecordRepositoryImpl implements MachineRecordRepository {

  final FirebaseMachineRecordDataSource firebaseDataSource;
  final LocalMachineRecordDataSource localDataSource;

  MachineRecordRepositoryImpl(this.firebaseDataSource, this.localDataSource);


  @override
  Future<MachineStatusE?> getMachineStatusByMachineId(int machineId) async {

    return await firebaseDataSource.getLastStatusByMachineId(machineId); 
  }

  @override
  Future<MachineModel?> getMachineDetails(MachineModel machine) async {

    
    DateTime startOfDay = DateTime(2024, 10, 31, 0, 0, 0); // Inicio del día
    DateTime endOfDay = DateTime(2024, 10, 31, 23, 59, 59); // Fin del día

    // Convertir a Timestamp
    Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
    Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

    // Voy a buscar los registros a la base de datos 
    final machineRecords = await firebaseDataSource.getMachineRecords(machine.id, startTimestamp, endTimestamp);

    if(machineRecords == null) {return null;}

    // Hago una copia local
    await localDataSource.setMachineRecords(machineRecords);
    
    await localDataSource.addMachineDetails(machine);

    return machine;
  }
}