import 'package:equatable/equatable.dart';
import '../../utils/base_screen_state.dart';

class LogoutState extends Equatable {
  final BaseScreenState screenState;
  final String? error;
  final bool logoutDone;

  static const List<int> emptyList = [0, 0];

  const LogoutState({
    this.screenState = BaseScreenState.idle,
    this.error,
    this.logoutDone = false,
  });

  LogoutState copyWith({
    BaseScreenState? screenState,
    String? error,
    bool? logoutDone,
  }) {
    return LogoutState(
      screenState: screenState ?? this.screenState,
      error: error ?? this.error,
      logoutDone: logoutDone ?? this.logoutDone,
    );
  }

  @override
  List<Object?> get props => [screenState, error, logoutDone];
}
