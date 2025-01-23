import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tractianchallenge/src/domain/models/company_location_model.dart';
import 'package:tractianchallenge/src/presentation/assets_list/widgets/asset_tree_view.dart';

class VirtualizedTreeView extends StatefulWidget {
  final List<CompanyAssetsModel> assets;

  const VirtualizedTreeView({
    super.key,
    required this.assets,
  });

  @override
  State<VirtualizedTreeView> createState() => _VirtualizedTreeViewState();
}

class _VirtualizedTreeViewState extends State<VirtualizedTreeView> {
  final List<_FlattenedAsset> _flattenedAssets = [];
  final ScrollController _scrollController = ScrollController();
  final Set<String> _expandedItems = {};

  @override
  void initState() {
    super.initState();
    _expandAllItems(widget.assets);
    _flattenAssets();
  }

  void _expandAllItems(List<CompanyAssetsModel> assets) {
    for (var asset in assets) {
      if (asset.children.isNotEmpty) {
        _expandedItems.add(asset.id);
        _expandAllItems(asset.children);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VirtualizedTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.assets != oldWidget.assets) {
      _expandAllItems(widget.assets);
      _flattenAssets();
    }
  }

  void _toggleExpand(String assetId) {
    setState(() {
      if (_expandedItems.contains(assetId)) {
        _expandedItems.remove(assetId);
      } else {
        _expandedItems.add(assetId);
      }
      _flattenAssets();
    });
  }

  void _flattenAssets() {
    _flattenedAssets.clear();
    for (var asset in widget.assets) {
      _flattenAssetRecursively(asset, 0);
    }
    if (mounted) setState(() {});
  }

  void _flattenAssetRecursively(CompanyAssetsModel asset, double indentation) {
    _flattenedAssets.add(_FlattenedAsset(asset: asset, indentation: indentation));

    if (asset.children.isNotEmpty && _expandedItems.contains(asset.id)) {
      for (var child in asset.children) {
        _flattenAssetRecursively(child, indentation + 24);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      controller: _scrollController,
      crossAxisCount: 1,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      itemCount: _flattenedAssets.length,
      itemBuilder: (context, index) {
        final item = _flattenedAssets[index];
        return AssetTreeView(
          key: ValueKey(item.asset.id),
          asset: item.asset,
          indentation: item.indentation,
          isExpanded: _expandedItems.contains(item.asset.id),
          onTap: item.asset.children.isNotEmpty ? () => _toggleExpand(item.asset.id) : null,
        );
      },
    );
  }
}

class _FlattenedAsset {
  final CompanyAssetsModel asset;
  final double indentation;

  _FlattenedAsset({
    required this.asset,
    required this.indentation,
  });
}
