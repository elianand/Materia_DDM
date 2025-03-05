import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecases/user_usecases.dart';
import '../../utils/base_screen_state.dart';
import '../../../core/providers/providers.dart';
import '../state/create_account_state.dart';


class CreateAccountNotifier extends AutoDisposeNotifier<CreateAccountState> {
  
  late final CheckUserSession checkUserSession;
  late final CreateUserWithCredentials createUserWithCredentials;


  @override
  CreateAccountState build() {

    checkUserSession = ref.read(checkUserSessionProvider);
    createUserWithCredentials = ref.read(createUserWithCredentialsProvider);

    return CreateAccountState();
  }

  Future<void> createAccount(String name, String username, String lastname, String country, 
    String phoneNum, String age, String email, String password) async {

    state = state.copyWith(screenState: BaseScreenState.loading, accountCreated: false);

    final isLoggedIn = await checkUserSession(); 

    if(!isLoggedIn) {
      state = state.copyWith(screenState: BaseScreenState.error, error: "User not logged");
    }

    final createdUser = await createUserWithCredentials(email, password, name, username, lastname, country, phoneNum, age);

    if(!createdUser) {
      state = state.copyWith(screenState: BaseScreenState.error, error: "User not created");
    }

    state = state.copyWith(screenState: BaseScreenState.idle, accountCreated: true);
    
  }
}
