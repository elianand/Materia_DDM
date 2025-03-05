import '../../data/models/company_model.dart';


abstract class CompanyRepository {

  Future<CompanyModel?> getCompanyById(int id);
}