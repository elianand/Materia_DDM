import '../../domain/repositories/company_repository.dart';
import '../models/company_model.dart';
import '../sources/local/company_local_data_source.dart';
import '../sources/remote/firebase_company_data_source.dart';

class CompanyRepositoryImpl implements CompanyRepository {

  final FirebaseCompanyDataSource firebaseDataSource;
  final LocalCompanyDataSource localDataSource;

  CompanyRepositoryImpl(this.firebaseDataSource, this.localDataSource);

  @override
  Future<CompanyModel?> getCompanyById(int idComp) async {
    
    CompanyModel? company;

    // Buscamos la compania localmente
    company = await localDataSource.getCompany();
    
    if(company == null) {
      // Buscamos la compania en firestore
      company = await firebaseDataSource.getCompanyById(idComp);

      if(company == null) {return null;}
      
      // Guardamos los datos localmente
      await localDataSource.setCompany(company);
    }

    return company;
  }

}