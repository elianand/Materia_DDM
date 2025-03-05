import '../../data/models/company_model.dart';
import '../repositories/company_repository.dart';
import '../repositories/users_repository.dart';


class GetUserCompany {

  final CompanyRepository compRepo;
  final UserRepository userRepo;

  GetUserCompany(this.compRepo, this.userRepo);

  Future<CompanyModel?> call() async {
    final compId = await userRepo.getUserIdComp();
    if(compId == null) {return null;}

    return await compRepo.getCompanyById(compId);
  }
}
