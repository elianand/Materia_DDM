import 'package:equatable/equatable.dart';
import '../../utils/base_screen_state.dart';

class MachineTypeState extends Equatable {
  final BaseScreenState screenState;
  final String? error;
  final List<int> listMachinesType;

  static const List<int> emptyList = [0, 0];

  const MachineTypeState({
    this.screenState = BaseScreenState.idle,
    this.error,
    this.listMachinesType = emptyList,
  });

  MachineTypeState copyWith({
    BaseScreenState? screenState,
    String? error,
    List<int>? listMachinesType,
  }) {
    return MachineTypeState(
      screenState: screenState ?? this.screenState,
      error: error ?? this.error,
      listMachinesType: listMachinesType ?? this.listMachinesType,
    );
  }

  @override
  List<Object?> get props => [screenState, error, listMachinesType];
}
