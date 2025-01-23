import 'package:flutter/material.dart';
import 'package:tractianchallenge/src/domain/models/company_location_model.dart';
import 'package:tractianchallenge/src/domain/repositories/company_repository.dart';

abstract class GetLocationAssetsUsecase {
  Future<List<CompanyAssetsModel>> call(String companyId);
}

class GetLocationAssetsUsecaseImpl implements GetLocationAssetsUsecase {
  final CompanyAssetsRepository _repository;

  GetLocationAssetsUsecaseImpl(this._repository);

  @override
  Future<List<CompanyAssetsModel>> call(String companyId) async {
    try {
      List<Map<String, dynamic>> locationsJson = await _repository.getCompaniesLocation(companyId);
      List<Map<String, dynamic>> assetsJson = await _repository.getCompaniesAssets(companyId);

      var companiesAssets = organizeAssets(locationsJson, assetsJson);

      return companiesAssets;
    } catch (e) {
      throw Exception('Failed to load companies location $e');
    }
  }

  List<CompanyAssetsModel> organizeAssets(
    List<Map<String, dynamic>> locationsJson,
    List<Map<String, dynamic>> assetsJson,
  ) {
    List<CompanyAssetsModel> locations = locationsJson.map((json) => CompanyAssetsModel.fromJson(json, true)).toList();
    List<CompanyAssetsModel> assets = assetsJson.map((json) => CompanyAssetsModel.fromJson(json, false)).toList();

    Map<String, CompanyAssetsModel> allItemsMap = {
      ...{for (var location in locations) location.id: location},
      ...{for (var asset in assets) asset.id: asset},
    };

    List<CompanyAssetsModel> organizedAssets = [];
    List<CompanyAssetsModel> unlinkedAssets = [];

    debugPrint('\nProcessing Locations:');
    for (var location in locations) {
      debugPrint('Processing Location: ${location.name} (ParentID: ${location.parentId})');
      if (location.parentId != null) {
        var parent = allItemsMap[location.parentId];
        if (parent != null) {
          debugPrint('Adding location ${location.name} to parent ${parent.name}');
          parent.addChild(location);
        } else {
          debugPrint('Parent not found for location ${location.name}');
          unlinkedAssets.add(location);
        }
      } else {
        debugPrint('Root location: ${location.name}');
        organizedAssets.add(location);
      }
    }

    debugPrint('\nProcessing Assets:');
    for (var asset in assets) {
      debugPrint('Processing: ${asset.name} (sensorType: ${asset.sensorType}, locationId: ${asset.locationId}, parentId: ${asset.parentId}, sensorId: ${asset.sensorId})');

      if (asset.sensorType != null && asset.locationId == null && asset.parentId == null) {
        debugPrint('Rule 1: Unlinked component - ${asset.name}');
        unlinkedAssets.add(asset);
        continue;
      }

      if (asset.locationId != null && asset.sensorId == null) {
        var location = allItemsMap[asset.locationId];
        if (location != null) {
          debugPrint('Rule 2: Adding asset ${asset.name} to location ${location.name}');
          location.addChild(asset);
        } else {
          debugPrint('Location not found for ${asset.name}');
          unlinkedAssets.add(asset);
        }
        continue;
      }

      if (asset.parentId != null && asset.sensorId == null) {
        var parent = allItemsMap[asset.parentId];
        if (parent != null) {
          debugPrint('Rule 3: Adding asset ${asset.name} to parent ${parent.name}');
          parent.addChild(asset);
        } else {
          debugPrint('Parent not found for ${asset.name}');
          unlinkedAssets.add(asset);
        }
        continue;
      }

      if (asset.sensorType != null && (asset.locationId != null || asset.parentId != null)) {
        var parent = asset.parentId != null ? allItemsMap[asset.parentId] : allItemsMap[asset.locationId];
        if (parent != null) {
          debugPrint('Rule 4: Adding component ${asset.name} to parent ${parent.name}');
          parent.addChild(asset);
        } else {
          debugPrint('Parent not found for component ${asset.name}');
          unlinkedAssets.add(asset);
        }
        continue;
      }

      debugPrint('No rule matched for ${asset.name}');
      unlinkedAssets.add(asset);
    }

    organizedAssets.addAll(unlinkedAssets);

    organizedAssets.removeWhere((item) => item.parentId != null || (item.locationId != null && item.sensorId == null));

    debugPrint('\nDebug sorting:');
    for (var item in organizedAssets) {
      debugPrint('Item: ${item.name}');
      debugPrint('  sensorType: ${item.sensorType}');
      debugPrint('  children count: ${item.children.length}');
    }

    organizedAssets.sort((a, b) {
      bool aIsArea = a.name.contains('AREA');
      bool bIsArea = b.name.contains('AREA');

      if (aIsArea && !bIsArea) return -1;
      if (!aIsArea && bIsArea) return 1;

      if (a.children.isEmpty && b.children.isNotEmpty) return 1;
      if (a.children.isNotEmpty && b.children.isEmpty) return -1;

      return 0;
    });

    debugPrint('\nFinal hierarchy:');
    for (var item in organizedAssets) {
      debugPrint('Root: ${item.name}');
      for (var child in item.children) {
        debugPrint('  Child: ${child.name} (ParentID: ${child.parentId}, LocationID: ${child.locationId})');
        for (var grandChild in child.children) {
          debugPrint('    GrandChild: ${grandChild.name} (ParentID: ${grandChild.parentId}, LocationID: ${grandChild.locationId})');
        }
      }
    }

    return organizedAssets;
  }
}
