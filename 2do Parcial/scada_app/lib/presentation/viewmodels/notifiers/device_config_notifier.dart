import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecases/machine_record_usecases.dart';
import '../../../domain/usecases/machine_usecases.dart';
import '../../utils/base_screen_state.dart';
import '../../../core/providers/providers.dart';
import '../state/device_config_state.dart';


class DeviceConfigNotifier extends AutoDisposeNotifier<DeviceConfigState> {
  
  late final GetMachineList _getMachineList;
  late final GetMachineStatusById _getMachineStatusById;
  late final SetMachineAttachById _setMachineAttachById;
  late final IsUserAdminLvl _isUserAdminLvl;

  @override
  DeviceConfigState build() {

    _getMachineList = ref.read(getMachineListProvider);
    _getMachineStatusById = ref.read(getMachineStatusByIdProvider);
    _setMachineAttachById = ref.read(setMachineAttachByIdProvider);
    _isUserAdminLvl = ref.read(isUserAdminLvlProvider);

    return DeviceConfigState();
  }

  bool getSwitchState(int machineId) {
    return state.switchStates![machineId] ?? false;
  }

  void toggleSwitchState(int machineId, bool newState) async {
    state = state.copyWith(screenState: BaseScreenState.loading);

    await _setMachineAttachById(machineId, newState);


    Map<int, bool> newSwitchStates = state.switchStates!;
      newSwitchStates[machineId] = newState;
    
    state = state.copyWith(switchStates: newSwitchStates, screenState: BaseScreenState.idle);
    return;
  }


  Future<void> getMachines() async {
    state = state.copyWith(screenState: BaseScreenState.loading, error: null);

    final machineList = await _getMachineList();

    
    final userAdminLvl = await _isUserAdminLvl();

    Map<int, bool> newSwitchStates = {};

    if(machineList != null) {
      for(var machine in machineList) {
        newSwitchStates[machine.id] = machine.attach;
        machine.state = await _getMachineStatusById(machine.id);
      }
    }

    state = state.copyWith(screenState: BaseScreenState.idle, machineList: machineList, 
      switchStates: newSwitchStates, userAdminLvl: userAdminLvl);
  }
}
