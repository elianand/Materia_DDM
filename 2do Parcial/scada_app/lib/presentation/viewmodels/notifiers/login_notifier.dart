import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/providers.dart';
import '../../../domain/usecases/user_usecases.dart';
import '../../utils/base_screen_state.dart';
import '../state/login_state.dart';


class LoginNotifier extends AutoDisposeNotifier<LoginState> {

  late final UserLoginWithCredentials userLoginWithCredentials;
  late final CheckUserSession checkUserSession;
  late final NeedCreateAccount needCreateAccount;
  late final SaveUserCredentials saveUserCredentials;
  late final SaveCredentialsOldAccount saveCredentialsOldAccount;

  LoginNotifier();
  
  @override
  LoginState build() {

    userLoginWithCredentials = ref.read(userLoginWithCredentialsProvider);
    checkUserSession = ref.read(checkUserSessionProvider);
    needCreateAccount = ref.read(needCreateAccountProvider);
    saveUserCredentials = ref.read(saveUserCredentialsProvider);
    saveCredentialsOldAccount = ref.read(saveCredentialsOldAccountProvider);

    return LoginState();
  }

  Future<bool> isUserLogin() async {

    state = state.copyWith(screenState: BaseScreenState.loading);

    final isLoggedIn = await checkUserSession();

    if (isLoggedIn) {
      state = state.copyWith(screenState: BaseScreenState.idle, loginSuccess: true);
      return true;
    }else {
      state = state.copyWith(screenState: BaseScreenState.idle);
      return false;
    }
  }


  Future<void> login(String email, String password) async {

    state = state.copyWith(screenState: BaseScreenState.loading);

    final login = await userLoginWithCredentials(email, password);
    if(login) {

      final createAccount = await needCreateAccount();

      if(!createAccount) {

        await saveUserCredentials(email, password);
        state = state.copyWith(
          screenState: BaseScreenState.idle, createAccount: false, loginSuccess: true);
        return;
      }else {

        await saveCredentialsOldAccount(email, password);
        state = state.copyWith(
          screenState: BaseScreenState.idle, createAccount: true, loginSuccess: true);
        return;
      }
    }else {
      state = state.copyWith(screenState: BaseScreenState.error, error: "Wrong credentials :c");
    }
  }

}
