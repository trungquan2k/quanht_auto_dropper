import 'package:flutter/widgets.dart';

class AssetsPrefixDrop extends StatelessWidget {
  final bool isHiden;
  final String path;
  final Widget assetWidget;
  const AssetsPrefixDrop(
      {super.key,
      this.isHiden = false,
      this.path = '',
      this.assetWidget = const Offstage()});

  @override
  Widget build(BuildContext context) {
    return _buildAssetPrefix();
  }

  Widget _buildAssetPrefix() {
    return Row(
      children: [
        if (!isHiden) ...[
          path.isNotEmpty ? assetWidget : const SizedBox.shrink(),
          const SizedBox(width: 8.0),
        ]
      ],
    );
  }
}
