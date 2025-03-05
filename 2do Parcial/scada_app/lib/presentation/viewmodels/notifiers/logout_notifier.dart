import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecases/user_usecases.dart';
import '../../utils/base_screen_state.dart';
import '../../../core/providers/providers.dart';
import '../state/logout_state.dart';


class LogoutNotifier extends AutoDisposeNotifier<LogoutState> {

  late final UserLogout _userLogout;

  @override
  LogoutState build() {

    _userLogout = ref.read(userLogoutProvider);
    return LogoutState();
  }

  void initLogout() {
    state = state.copyWith(
      screenState: BaseScreenState.idle,
      logoutDone: false,
    );
  }


  Future<void> logout() async {
    state = state.copyWith(screenState: BaseScreenState.loading, error: null);

    await _userLogout();

    state = state.copyWith(screenState: BaseScreenState.idle, logoutDone: true);
  }
}
