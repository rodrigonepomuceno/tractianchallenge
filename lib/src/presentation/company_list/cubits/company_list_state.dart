part of 'company_list_cubit.dart';

enum CompanyStatus { initial, loading, success, failure }

class CompanyState {
  final CompanyStatus status;
  final List<CompanieModel> assets;

  final String? error;

  const CompanyState({
    this.status = CompanyStatus.initial,
    this.assets = const [],
    this.error,
  });

  CompanyState copyWith({
    CompanyStatus? status,
    List<CompanieModel>? assets,
    String? error,
  }) {
    return CompanyState(
      status: status ?? this.status,
      assets: assets ?? this.assets,
      error: error ?? this.error,
    );
  }
}
