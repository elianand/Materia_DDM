import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/usecases/machine_usecases.dart';
import '../../utils/base_screen_state.dart';
import '../../../core/providers/providers.dart';
import '../state/machine_detail_state.dart';


class MachineDetailNotifier extends AutoDisposeNotifier<MachineDetailState> {
  
  late final GetMachineByIdWithDetails _getMachineByIdWithDetails;
  late final SetImageToMachineId _setImageToMachineId;
  late final IsUserAdminLvl _isUserAdminLvl;
  

  @override
  MachineDetailState build() {

    _getMachineByIdWithDetails = ref.read(getMachineByIdWithDetailsProvider);
    _setImageToMachineId = ref.read(setImageToMachineIdProvider);
    _isUserAdminLvl = ref.read(isUserAdminLvlProvider);

    return MachineDetailState();
  }


  Future<void> getMachineById(int machineId) async {

    state = state.copyWith(screenState: BaseScreenState.loading, error: null);

    final machine = await _getMachineByIdWithDetails(machineId);

    final isAdmin = await _isUserAdminLvl();

    if(machine == null) {
      state = state.copyWith(screenState: BaseScreenState.error, error: "Error with the database");
      return;
    }

    state = state.copyWith(screenState: BaseScreenState.idle, machine: machine, isAdminLvl: isAdmin);
  }


  Future<void> setImageToMachineId(int machineId, XFile? image) async {

    state = state.copyWith(screenState: BaseScreenState.loading, error: null);

    if(image == null) {
      state = state.copyWith(screenState: BaseScreenState.error, error: "No image found");
      debugPrint("Error al cargar la imagen, CHEUQEAR ESTO");
      return;
    }

    final machine = await _setImageToMachineId(machineId, image);

    state = state.copyWith(screenState: BaseScreenState.idle, machine: machine);
  }
}
