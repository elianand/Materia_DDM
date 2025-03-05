import 'package:image_picker/image_picker.dart';

import '../../data/models/machine_model.dart';


abstract interface class MachineRepository {



  Future<void> setMachineAttachById(int id, bool newStatus);

  Future<MachineModel?> setImageToMachineId(int machineId, XFile image);

  Future<MachineModel?> getMachineById(int id);

  // Este lo busca en el repositorio local
  Future<List<MachineModel>?> getMachinesByIdComp(int idComp);
}