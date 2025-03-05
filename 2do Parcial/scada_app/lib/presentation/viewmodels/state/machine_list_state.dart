import 'package:equatable/equatable.dart';
import '../../../data/models/machine_model.dart';
import '../../utils/base_screen_state.dart';

class MachineListState extends Equatable {
  final BaseScreenState screenState;
  final String? error;
  final List<MachineModel>? machineList;

  static const List<int> emptyList = [0, 0];

  const MachineListState({
    this.screenState = BaseScreenState.idle,
    this.error,
    this.machineList,
  });

  MachineListState copyWith({
    BaseScreenState? screenState,
    String? error,
    List<MachineModel>? machineList,
  }) {
    return MachineListState(
      screenState: screenState ?? this.screenState,
      error: error ?? this.error,
      machineList: machineList ?? this.machineList,
    );
  }

  @override
  List<Object?> get props => [screenState, error, machineList];
}
