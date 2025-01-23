import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractianchallenge/core/theme/app_theme.dart';
import 'package:tractianchallenge/core/theme/app_typography.dart';
import 'package:tractianchallenge/injections.dart';
import 'package:tractianchallenge/src/domain/models/company_location_model.dart';
import 'package:tractianchallenge/src/presentation/assets_list/cubits/assets_list_cubit.dart';
import 'package:tractianchallenge/src/presentation/assets_list/widgets/filter_button.dart';
import 'package:tractianchallenge/src/presentation/assets_list/widgets/search_field.dart';

import '../widgets/virtualized_tree_view.dart';

class AssetsListPage extends StatefulWidget {
  final String companieId;
  const AssetsListPage({super.key, required this.companieId});

  @override
  State<AssetsListPage> createState() => _AssetsListPageState();
}

class _AssetsListPageState extends State<AssetsListPage> {
  bool _showEnergySensors = false;
  bool _showCritical = false;
  String _searchQuery = '';

  bool _shouldShowAsset(CompanyAssetsModel asset) {
    if (!_showEnergySensors && !_showCritical && _searchQuery.isEmpty) {
      return true;
    }

    bool matchesSearch = _searchQuery.isEmpty || asset.name.toLowerCase().contains(_searchQuery.toLowerCase());

    bool matchesFilter = (!_showEnergySensors && !_showCritical) || (_showEnergySensors && asset.status == 'operating') || (_showCritical && asset.status == 'alert');

    if (matchesSearch && matchesFilter) {
      return true;
    }

    for (var child in asset.children) {
      if (_shouldShowAsset(child)) {
        return true;
      }
    }

    return false;
  }

  CompanyAssetsModel? _filterAsset(CompanyAssetsModel asset) {
    if (!_shouldShowAsset(asset)) {
      return null;
    }
    if (!_showEnergySensors && !_showCritical && _searchQuery.isEmpty) {
      return asset;
    }

    final filteredChildren = asset.children.map((child) => _filterAsset(child)).whereType<CompanyAssetsModel>().toList();

    return CompanyAssetsModel(
      id: asset.id,
      name: asset.name,
      parentId: asset.parentId,
      sensorId: asset.sensorId,
      sensorType: asset.sensorType,
      status: asset.status,
      gatewayId: asset.gatewayId,
      locationId: asset.locationId,
      children: filteredChildren,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AssetsListCubit>()..loadCompaniesLocation(widget.companieId),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          iconTheme: const IconThemeData(color: AppTheme.background),
          title: Text('Assets', style: AppTypography.regularLg),
        ),
        body: BlocBuilder<AssetsListCubit, AssetListState>(
          builder: (context, state) {
            if (state.status == AssetListStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.assets.isEmpty) {
              return const Center(child: Text('No assets found'));
            }

            final filteredAssets = state.assets.map((asset) => _filterAsset(asset)).whereType<CompanyAssetsModel>().toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    children: [
                      SearchField(
                        value: _searchQuery,
                        onChanged: (value) => setState(() => _searchQuery = value),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          FilterButton(
                            label: 'Sensor de Energia',
                            icon: 'assets/icon_filter_bolt.png',
                            isSelected: _showEnergySensors,
                            onTap: () => setState(() => _showEnergySensors = !_showEnergySensors),
                          ),
                          const SizedBox(width: 12),
                          FilterButton(
                            label: 'Crítico',
                            icon: 'assets/icon_filter_alert.png',
                            isSelected: _showCritical,
                            onTap: () => setState(() => _showCritical = !_showCritical),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Divider(height: 2, color: AppTheme.divider),
                ),
                Expanded(
                  child: filteredAssets.isEmpty
                      ? Center(
                          child: Text(
                            _searchQuery.isNotEmpty
                                ? 'Nenhum resultando encontrado para "$_searchQuery"'
                                : _showEnergySensors
                                    ? 'Nenhum sensor de energia encontrado'
                                    : _showCritical
                                        ? 'Nenhum ativo crítico encontrado'
                                        : 'Nenhum ativo encontrado',
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 16, 16),
                          child: VirtualizedTreeView(
                            assets: filteredAssets,
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
