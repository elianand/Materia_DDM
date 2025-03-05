import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/machine_model.dart';
import '../../../domain/usecases/machine_usecases.dart';
import '../../utils/base_screen_state.dart';
import '../../../core/providers/providers.dart';
import '../state/machine_type_state.dart';


class MachineTypeNotifier extends AutoDisposeNotifier<MachineTypeState> {

  late final GetMachineList _getMachineList;

  @override
  MachineTypeState build() {

    _getMachineList = ref.read(getMachineListProvider);


    return MachineTypeState();
  }


  Future<void> getMachineCount() async {

    state = state.copyWith(screenState: BaseScreenState.loading, error: null);

    List<MachineModel>? machines = await _getMachineList();

    if(machines == null) {
      state = state.copyWith(screenState: BaseScreenState.error, error: "Error in machines");
      return;
    }

    // Vamos a devolver una lista de la cantidad de maquinas por tipo

    // Aca vamos a inicializar la lista
    List<int> machinesTypes = List<int>.filled(2, 0);    // Dos elementos

    // Vamos a empezar a contar
    for(var elem in machines) {
      switch(elem.idType) {
        case MachinesTypeE.injectionMolding:
          machinesTypes[0]++;
        break;
        case MachinesTypeE.crusher:
          machinesTypes[1]++;
        break;
      }
    } 

    state = state.copyWith(screenState: BaseScreenState.idle, listMachinesType: machinesTypes);
  }
}
