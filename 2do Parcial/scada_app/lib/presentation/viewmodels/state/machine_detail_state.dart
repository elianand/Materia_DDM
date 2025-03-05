import 'package:equatable/equatable.dart';
import '../../../data/models/machine_model.dart';
import '../../utils/base_screen_state.dart';

class MachineDetailState extends Equatable {
  final BaseScreenState screenState;
  final String? error;
  final MachineModel? machine;
  final bool isAdminLvl;

  static const List<int> emptyList = [0, 0];

  const MachineDetailState({
    this.screenState = BaseScreenState.idle,
    this.error,
    this.machine,
    this.isAdminLvl = false,
  });

  MachineDetailState copyWith({
    BaseScreenState? screenState,
    String? error,
    MachineModel? machine,
    bool? isAdminLvl,
  }) {
    return MachineDetailState(
      screenState: screenState ?? this.screenState,
      error: error ?? this.error,
      machine: machine ?? this.machine,
      isAdminLvl: isAdminLvl ?? this.isAdminLvl,
    );
  }

  @override
  List<Object?> get props => [screenState, error, machine, isAdminLvl];
}
