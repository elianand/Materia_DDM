import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/machine_model.dart';
import '../../../domain/usecases/machine_usecases.dart';
import '../../utils/base_screen_state.dart';
import '../../../core/providers/providers.dart';
import '../state/machine_list_state.dart';


class MachineListNotifier extends AutoDisposeNotifier<MachineListState> {
  
  late final GetMachineList _getMachineList;

  @override
  MachineListState build() {

    _getMachineList = ref.read(getMachineListProvider);

    return MachineListState();
  }


  Future<void> getMachinesByType(MachinesTypeE machineType) async {
    state = state.copyWith(screenState: BaseScreenState.loading, error: null);

    final machines = await _getMachineList();


    if(machines == null) {
      state = state.copyWith(screenState: BaseScreenState.error, error: "No data found");
      return;
    }

    final machineSelection = machines.where((elem) => elem.idType == machineType).toList();

    state = state.copyWith(screenState: BaseScreenState.idle, machineList: machineSelection);

  }
}
