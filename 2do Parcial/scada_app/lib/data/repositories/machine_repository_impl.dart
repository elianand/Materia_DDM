import 'package:image_picker/image_picker.dart';

import '../../domain/repositories/machines_repository.dart';
import '../models/machine_model.dart';
import '../sources/local/machine_local_data_source.dart';
import '../sources/remote/firebase_machine_data_source.dart';

class MachineRepositoryImpl implements MachineRepository {

  final FirebaseMachineDataSource firebaseDataSource;
  final LocalMachineDataSource localDataSource;

  MachineRepositoryImpl(this.firebaseDataSource, this.localDataSource);

  @override
  Future<void> setMachineAttachById(int id, bool newStatus) async {

    // Para el status no voy a buscar a firebase
    final machine = await localDataSource.getMachineById(id);

    if(machine == null) {return;}

    machine.attach = newStatus;

    await firebaseDataSource.updateMachine(machine);

  }


  @override
  Future<MachineModel?> setImageToMachineId(int machineId, XFile image) async {

    final machine = await localDataSource.getMachineById(machineId);

    if(machine == null) {return null;}
    
    if(machine.imagePath != "" && machine.imagePath != null) {

      await firebaseDataSource.deleteMachineImageWithPath(machine.imagePath!);
    }

    final imageData = await firebaseDataSource.setImageToMachineWithId(machineId, image);

    machine.imagePath = imageData["imagePath"];
    machine.imageUrl = imageData["downloadURL"];

    await firebaseDataSource.updateMachine(machine);

    return machine;
  }

  @override
  Future<MachineModel?> getMachineById(int id) async {
    return await localDataSource.getMachineById(id);
  }

  @override
  Future<List<MachineModel>?> getMachinesByIdComp(int idComp) async {

    List<MachineModel>? machineList = await localDataSource.getAllMachines();

    machineList ??= await firebaseDataSource.getMachinesByIdComp(idComp);

    await localDataSource.setAllMachines(machineList);
    
    return machineList;
  }

}