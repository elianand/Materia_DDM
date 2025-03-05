import 'package:equatable/equatable.dart';
import '../../../data/models/machine_model.dart';
import '../../utils/base_screen_state.dart';

class DeviceConfigState extends Equatable {
  final BaseScreenState screenState;
  final String? error;
  final List<MachineModel>? machineList;
  final Map<int, bool>? switchStates;
  final bool userAdminLvl;


  const DeviceConfigState({
    this.screenState = BaseScreenState.idle,
    this.error,
    this.machineList,
    this.switchStates,
    this.userAdminLvl = false,
  });

  DeviceConfigState copyWith({
    BaseScreenState? screenState,
    String? error,
    List<MachineModel>? machineList,
    Map<int, bool>? switchStates,
    List<MachineStatusE>? machineStatus,
    bool? userAdminLvl,
  }) {
    return DeviceConfigState(
      screenState: screenState ?? this.screenState,
      error: error ?? this.error,
      machineList: machineList ?? this.machineList,
      switchStates: switchStates ?? this.switchStates,
      userAdminLvl: userAdminLvl ?? this.userAdminLvl,
    );
  }

  @override
  List<Object?> get props => [screenState, error, machineList, userAdminLvl];
}
