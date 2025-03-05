import 'package:equatable/equatable.dart';
import '../../../data/models/company_model.dart';
import '../../utils/base_screen_state.dart';

class CompanyState extends Equatable {
  final BaseScreenState screenState;
  final String? error;
  final CompanyModel? company;
  final bool companyLoaded;

  static const List<int> emptyList = [0, 0];

  const CompanyState({
    this.screenState = BaseScreenState.idle,
    this.error,
    this.company,
    this.companyLoaded = false,
  });

  CompanyState copyWith({
    BaseScreenState? screenState,
    String? error,
    CompanyModel? company,
    bool? companyLoaded,
  }) {
    return CompanyState(
      screenState: screenState ?? this.screenState,
      error: error ?? this.error,
      company: company ?? this.company,
      companyLoaded: companyLoaded ?? this.companyLoaded,
    );
  }

  @override
  List<Object?> get props => [screenState, error, company, companyLoaded];
}
