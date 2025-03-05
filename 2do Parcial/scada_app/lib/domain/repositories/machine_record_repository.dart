import '../../data/models/machine_model.dart';


abstract interface class MachineRecordRepository {

  Future<MachineStatusE?> getMachineStatusByMachineId(int machineId);

  Future<MachineModel?> getMachineDetails(MachineModel machine);
  
}