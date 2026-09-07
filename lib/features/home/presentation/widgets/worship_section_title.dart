import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:mariam/core/theme/theme_provider.dart';

class WorshipSectionTitle extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onActionTap;

  const WorshipSectionTitle({
    super.key,
    required this.title,
    required this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeProvider = context.watch<ThemeProvider>();

    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Text(
          title,
          textDirection: TextDirection.rtl,
          style: GoogleFonts.cairo(fontSize: 16.sp, fontWeight: FontWeight.w800, color: themeProvider.primaryText),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionText,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.cairo(fontSize: 9.sp, fontWeight: FontWeight.w600, color: colorScheme.primary),
          ),
        ),
      ],
    );
  }
}