import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tractianchallenge/core/repositories/companie_assets_repository_impl.dart';
import 'package:tractianchallenge/core/repositories/companie_repository_impl.dart';
import 'package:tractianchallenge/src/domain/repositories/company_repository.dart';
import 'package:tractianchallenge/src/domain/usecases/get_location_assets_usecase.dart';
import 'package:tractianchallenge/src/presentation/assets_list/cubits/assets_list_cubit.dart';
import 'package:tractianchallenge/src/presentation/company_list/cubits/company_list_cubit.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton<CompanyRepository>(() => CompanieRepositoryImpl(getIt<Dio>()));
  getIt.registerLazySingleton<CompanyAssetsRepository>(() => CompanieAssetsRepositoryImpl(getIt<Dio>()));
  getIt.registerLazySingleton<GetLocationAssetsUsecase>(() => GetLocationAssetsUsecaseImpl(getIt()));
  getIt.registerFactory(() => CompanyCubit(getIt<CompanyRepository>()));
  getIt.registerFactory(() => AssetsListCubit(getIt<GetLocationAssetsUsecase>()));
}
