import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecases/company_usecases.dart';
import '../../utils/base_screen_state.dart';
import '../../../core/providers/providers.dart';
import '../state/company_state.dart';


class CompanyNotifier extends AutoDisposeNotifier<CompanyState> {
  
  late final GetUserCompany getUserCompany;

  @override
  CompanyState build() {

    getUserCompany = ref.read(getUserCompanyProvider);

    return CompanyState();
  }

  Future<void> getCompany() async {

    state = state.copyWith(screenState: BaseScreenState.loading, companyLoaded: false);

    final myCompany = await getUserCompany();

    if(myCompany == null) {
      state = state.copyWith(screenState: BaseScreenState.error, error: "No company found");
    }

    state = state.copyWith(screenState: BaseScreenState.idle, company: myCompany, companyLoaded: true);
  }
}
