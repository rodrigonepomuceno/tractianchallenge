import 'package:flutter/material.dart';
import 'package:tractianchallenge/core/theme/app_theme.dart';
import 'package:tractianchallenge/core/theme/app_typography.dart';
import 'package:tractianchallenge/src/domain/models/company_location_model.dart';

class AssetTreeView extends StatelessWidget {
  final CompanyAssetsModel asset;
  final double indentation;
  final bool isExpanded;
  final VoidCallback? onTap;

  const AssetTreeView({
    super.key,
    required this.asset,
    this.indentation = 0,
    this.isExpanded = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(left: indentation),
          child: SizedBox(
            height: 32, // Reduced height
            child: Row(
              children: [
                if (asset.children.isNotEmpty) ...[
                  Icon(
                    isExpanded ? Icons.expand_more : Icons.chevron_right,
                    size: 20,
                    color: Colors.grey,
                  ),
                ] else ...[
                  const SizedBox(width: 20),
                ],
                _getIcon(),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    asset.name,
                    style: AppTypography.bodyRegular.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (asset.status != null) _getStatusIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getIcon() {
    String icon;
    Color iconColor = Colors.blue;

    if (asset.sensorType != null) {
      icon = 'assets/component.png';
    } else if (_isLocal) {
      icon = 'assets/location.png';
    } else if (asset.sensorId == null) {
      icon = 'assets/assets.png';
    } else {
      icon = 'assets/location.png';
    }

    return Image.asset(icon, height: 20, width: 20, color: iconColor);
  }

  Widget _getStatusIndicator() {
    switch (asset.status) {
      case 'alert':
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(left: 8),
          decoration: const BoxDecoration(
            color: AppTheme.error,
            shape: BoxShape.circle,
          ),
        );

      case 'operating':
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Image.asset('assets/bolt.png', height: 14, width: 14),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  bool get _isLocal => (asset.sensorType == null && asset.locationId == null && asset.parentId == null && asset.status == null) || asset.isLocal;
}
