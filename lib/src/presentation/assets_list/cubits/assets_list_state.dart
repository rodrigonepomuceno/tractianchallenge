part of 'assets_list_cubit.dart';

enum AssetListStatus { initial, loading, success, failure }

class AssetListState {
  final AssetListStatus status;
  final List<CompanyAssetsModel> assets;

  final String? error;

  const AssetListState({
    this.status = AssetListStatus.initial,
    this.assets = const [],
    this.error,
  });

  AssetListState copyWith({
    AssetListStatus? status,
    List<CompanyAssetsModel>? assets,
    String? error,
  }) {
    return AssetListState(
      status: status ?? this.status,
      assets: assets ?? this.assets,
      error: error ?? this.error,
    );
  }
}
