import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';
import '../../utils/base_screen_state.dart';

class UserDetailState extends Equatable {
  final BaseScreenState screenState;
  final String? error;
  final UserModel? userModel;

  static const List<int> emptyList = [0, 0];

  const UserDetailState({
    this.screenState = BaseScreenState.idle,
    this.error,
    this.userModel,
  });

  UserDetailState copyWith({
    BaseScreenState? screenState,
    String? error,
    UserModel? userModel,
  }) {
    return UserDetailState(
      screenState: screenState ?? this.screenState,
      error: error ?? this.error,
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  List<Object?> get props => [screenState, error, userModel];
}
