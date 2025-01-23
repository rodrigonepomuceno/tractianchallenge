import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/company_model.dart';
import '../../../domain/repositories/company_repository.dart';

part 'company_list_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepository _repository;

  CompanyCubit(this._repository) : super(const CompanyState());

  Future<void> loadCompanies() async {
    try {
      emit(state.copyWith(status: CompanyStatus.loading));
      final assets = await _repository.getCompanies();
      emit(state.copyWith(
        status: CompanyStatus.success,
        assets: assets,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CompanyStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
