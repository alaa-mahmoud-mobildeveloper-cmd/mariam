import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/features/audio_quran/presentation/widgets/audio_preview.dart';



class AudioMiniPlayer extends StatelessWidget {
  final AudioPreview item;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onClose;

  const AudioMiniPlayer({super.key, required this.item, required this.isPlaying, required this.onPlayPause, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(child: Container(padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h), decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: const [BoxShadow(color: Color(0x18000000), blurRadius: 14, offset: Offset(0, -4))]), child: Row(textDirection: TextDirection.rtl, children: [
      Icon(item.icon, color: item.color, size: 23.sp),
      SizedBox(width: 10.w),
      Expanded(child: Text(item.title, textDirection: TextDirection.rtl, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: colors.onSurface))),
      IconButton(onPressed: onPlayPause, icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: colors.primary)),
      IconButton(onPressed: onClose, icon: Icon(Icons.close_rounded, color: colors.onSurface)),
    ]
    )
    )
      );
  }
}
