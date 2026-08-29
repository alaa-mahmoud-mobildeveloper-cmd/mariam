import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mariam/core/theme/theme_provider.dart';

class MemoriesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MemoriesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        'ذكرياتى',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: themeProvider.primaryText,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: themeProvider.primaryText,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}