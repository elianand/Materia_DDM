import '../../models/company_model.dart';


class LocalCompanyDataSource {

  // Dependencias
  // Este no tiene

  LocalCompanyDataSource();

  CompanyModel? company;


  Future<CompanyModel?> getCompany() async {
    return company;
  }

  Future<void> setCompany(CompanyModel comp) async {
    company = comp;
  }

}