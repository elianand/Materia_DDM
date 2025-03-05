import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';
import '../../utils/base_screen_state.dart';

class CreateAccountState extends Equatable {
  final BaseScreenState screenState;
  final String? error;
  final User? user;
  final bool accountCreated;

  static const List<int> emptyList = [0, 0];

  const CreateAccountState({
    this.screenState = BaseScreenState.idle,
    this.error,
    this.user,
    this.accountCreated = false,
  });

  CreateAccountState copyWith({
    BaseScreenState? screenState,
    String? error,
    User? user,
    bool? accountCreated,
  }) {
    return CreateAccountState(
      screenState: screenState ?? this.screenState,
      error: error ?? this.error,
      user: user ?? this.user,
      accountCreated: accountCreated ?? this.accountCreated,
    );
  }

  @override
  List<Object?> get props => [screenState, error, user, accountCreated];
}
