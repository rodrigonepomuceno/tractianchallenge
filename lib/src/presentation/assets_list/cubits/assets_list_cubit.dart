import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractianchallenge/src/domain/models/company_location_model.dart';
import 'package:tractianchallenge/src/domain/usecases/get_location_assets_usecase.dart';

part 'assets_list_state.dart';

class AssetsListCubit extends Cubit<AssetListState> {
  final GetLocationAssetsUsecase getLocationAssetsUsecase;

  AssetsListCubit(this.getLocationAssetsUsecase) : super(const AssetListState());

  Future<void> loadCompaniesLocation(String companyId) async {
    try {
      emit(state.copyWith(status: AssetListStatus.loading));
      final assets = await getLocationAssetsUsecase(companyId);
      emit(state.copyWith(
        status: AssetListStatus.success,
        assets: assets,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AssetListStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
