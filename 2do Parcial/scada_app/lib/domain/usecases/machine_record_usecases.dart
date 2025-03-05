import '../../data/models/machine_model.dart';
import '../repositories/machine_record_repository.dart';


class GetMachineStatusById {
  
  final MachineRecordRepository machineRecordRepo;

  GetMachineStatusById(this.machineRecordRepo);

  Future<MachineStatusE?> call(int id) async {

    return await machineRecordRepo.getMachineStatusByMachineId(id);
  }
}