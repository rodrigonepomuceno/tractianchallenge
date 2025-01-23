import 'package:dio/dio.dart';
import 'package:tractianchallenge/core/constants/urls_path.dart';
import 'package:tractianchallenge/src/domain/repositories/company_repository.dart';

class CompanieAssetsRepositoryImpl implements CompanyAssetsRepository {
  final Dio _dio;

  CompanieAssetsRepositoryImpl(this._dio);

  @override
  Future<List<Map<String, dynamic>>> getCompaniesLocation(String companyId) async {
    try {
      final url = '${UrlsPath.baseUrl}/companies/$companyId/locations';
      final response = await _dio.get(url);
      final List<dynamic> data = response.data;
      final List<Map<String, dynamic>> result = data.cast<Map<String, dynamic>>();

      return result;
    } catch (e) {
      throw Exception('Failed to load companies location $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCompaniesAssets(String companyId) async {
    try {
      final url = '${UrlsPath.baseUrl}/companies/$companyId/assets';
      final response = await _dio.get(url);
      final List<dynamic> data = response.data;
      final List<Map<String, dynamic>> result = data.cast<Map<String, dynamic>>();

      return result;
    } catch (e) {
      throw Exception('Failed to load companies assets $e');
    }
  }
}
