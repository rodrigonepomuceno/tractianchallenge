import 'package:dio/dio.dart';
import 'package:tractianchallenge/core/constants/urls_path.dart';

import '../../src/domain/models/company_model.dart';
import '../../src/domain/repositories/company_repository.dart';

class CompanieRepositoryImpl implements CompanyRepository {
  final Dio _dio;

  CompanieRepositoryImpl(this._dio);

  @override
  Future<List<CompanieModel>> getCompanies() async {
    try {
      final url = '${UrlsPath.baseUrl}/companies';
      final response = await _dio.get(url);
      final List<dynamic> data = response.data;
      return data.map((json) => CompanieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load companies');
    }
  }
}
