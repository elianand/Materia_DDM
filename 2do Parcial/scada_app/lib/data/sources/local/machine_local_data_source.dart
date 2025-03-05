import '../../models/machine_model.dart';


class LocalMachineDataSource {

  // Dependencias

  LocalMachineDataSource();

  List<MachineModel>? machineList;
    
  Future<MachineModel?> getMachineById(int machineId) async {

    if(machineList == null) {return null;}

    return machineList!.firstWhere((elem) => elem.id == machineId);
  }

  Future<List<MachineModel>?> getAllMachines() async {

    if(machineList == null) {return null;}

    return machineList!;
  }

  Future<void> setAllMachines(List<MachineModel>? machineList) async {
    this.machineList = machineList;
  }

}