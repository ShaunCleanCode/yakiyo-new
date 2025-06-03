import 'package:flutter/material.dart';

import '../../core/constants/assets_constants.dart';
import '../../core/constants/routes_constants.dart';

class AppMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSettingsTap;
  const AppMainAppBar({
    Key? key,
    this.onSettingsTap,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          AssetsConstants.appLogoPng,
          width: 32,
          height: 32,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () {
            if (onSettingsTap != null) {
              onSettingsTap!();
            } else {
              Navigator.pushNamed(context, RoutesConstants.settings);
            }
          },
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: null,
    );
  }
}
