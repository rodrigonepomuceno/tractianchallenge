import '../models/company_model.dart';

abstract class CompanyRepository {
  Future<List<CompanieModel>> getCompanies();
}

abstract class CompanyAssetsRepository {
  Future<List<Map<String, dynamic>>> getCompaniesLocation(String companyId);
  Future<List<Map<String, dynamic>>> getCompaniesAssets(String companyId);
}
