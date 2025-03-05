import 'package:image_picker/image_picker.dart';

import '../../data/models/machine_model.dart';
import '../repositories/machine_record_repository.dart';
import '../repositories/machines_repository.dart';
import '../repositories/users_repository.dart';


class GetMachineList {

  final MachineRepository machineRepo;
  final UserRepository userRepo;

  GetMachineList(this.machineRepo, this.userRepo);

  Future<List<MachineModel>?> call() async {

    final compId = await userRepo.getUserIdComp();
    if(compId == null) {return null;}

    return await machineRepo.getMachinesByIdComp(compId);
  }
}


class GetMachineByIdWithDetails {

  final MachineRepository machineRepo;
  final MachineRecordRepository machineRecordRepo;

  GetMachineByIdWithDetails(this.machineRepo, this.machineRecordRepo);

  Future<MachineModel?> call(int machineId) async {

    final machine = await machineRepo.getMachineById(machineId);
    
    if(machine == null) {return null;}

    return await machineRecordRepo.getMachineDetails(machine);
  }
}

class SetImageToMachineId {
  

  final MachineRepository machineRepo;

  SetImageToMachineId(this.machineRepo);

  Future<MachineModel?> call(int machineId, XFile image) async {

    return await machineRepo.setImageToMachineId(machineId, image);
  }
}

class IsUserAdminLvl {
  
  final UserRepository userRepo;

  IsUserAdminLvl(this.userRepo);

  Future<bool> call() async {

    return await userRepo.isUserAdminLvl();
  }
}



class SetMachineAttachById {
  
  final MachineRepository machineRepo;

  SetMachineAttachById(this.machineRepo);

  Future<void> call(int id, bool status) async {

    await machineRepo.setMachineAttachById(id, status);
  }
}
