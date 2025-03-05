import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';
import '../../utils/base_screen_state.dart';

class LoginState extends Equatable {
  final BaseScreenState screenState;
  final String? error;
  final User? user;
  final bool loginSuccess;
  final bool createAccount;

  static const List<int> emptyList = [0, 0];

  const LoginState({
    this.screenState = BaseScreenState.idle,
    this.error,
    this.user,
    this.loginSuccess = false,
    this.createAccount = false,
  });

  LoginState copyWith({
    BaseScreenState? screenState,
    String? error,
    User? user,
    bool? loginSuccess,
    bool? createAccount,
  }) {
    return LoginState(
      screenState: screenState ?? this.screenState,
      error: error ?? this.error,
      user: user ?? this.user,
      loginSuccess: loginSuccess ?? this.loginSuccess,
      createAccount: createAccount ?? this.createAccount,
    );
  }

  @override
  List<Object?> get props => [screenState, error, user, loginSuccess, createAccount];
}
