import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/features/audio_quran/presentation/widgets/audio_preview.dart';


class AudioTile extends StatelessWidget {
  final AudioPreview item;
  final bool selected;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const AudioTile({super.key, required this.item, required this.selected, required this.isPlaying, required this.onTap, required this.onFavorite});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(13.w),
            decoration: BoxDecoration(
              color: selected ? colors.primary.withValues(alpha: 0.08) : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: selected ? colors.primary.withValues(alpha: 0.28) : Colors.transparent),
            ),
            child: Row(textDirection: TextDirection.rtl, children: [
              Container(width: 48.w, height: 48.w, decoration: BoxDecoration(color: item.color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(15.r)), child: Icon(item.icon, color: item.color, size: 25.sp)),
              SizedBox(width: 11.w),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(item.title, textDirection: TextDirection.rtl, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: colors.onSurface)),
                SizedBox(height: 5.h),
                Text('${item.category}  •  ${item.duration}', textDirection: TextDirection.rtl, style: TextStyle(fontSize: 10.sp, color: colors.onSurface.withValues(alpha: 0.52))),
              ])),
              IconButton(onPressed: onFavorite, visualDensity: VisualDensity.compact, icon: Icon(item.favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: item.favorite ? const Color(0xFFE978A9) : colors.onSurface.withValues(alpha: 0.42), size: 20.sp)),
              Container(width: 37.w, height: 37.w, decoration: BoxDecoration(color: selected ? colors.primary : colors.primary.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(selected && isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: selected ? colors.onPrimary : colors.primary, size: 22.sp)),
            ]),
          ),
        ),
      ),
    );
  }
}
