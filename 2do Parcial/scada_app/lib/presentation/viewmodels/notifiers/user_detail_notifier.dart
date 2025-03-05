import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/usecases/user_usecases.dart';
import '../../utils/base_screen_state.dart';
import '../../../core/providers/providers.dart';

import '../state/user_detail_state.dart';

class UserDetailNotifier extends AutoDisposeNotifier<UserDetailState> {
  
  late final GetUserData getUserData;
  bool isLoading = false;
  UserModel? user;
  
  @override
  UserDetailState build() {
    getUserData = ref.read(getUserDataProvider);
    return UserDetailState();
  }

  Future<void> getUser() async {
    state = state.copyWith(screenState: BaseScreenState.loading, error: null);

    user = await getUserData();
    
    state = state.copyWith(screenState: BaseScreenState.idle, userModel: user);
    
    return;
  }

}
