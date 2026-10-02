import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import 'package:mariam/features/notifications/domain/entities/app_notification.dart';
import 'package:mariam/features/notifications/presentation/providers/notifications_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  IconData _iconFor(String type) {
    switch (type) {
      case 'success':
        return Icons.check_circle_rounded;
      case 'task':
        return Icons.task_alt_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _colorFor(BuildContext context, String type) {
    switch (type) {
      case 'success':
        return Colors.green;
      case 'task':
        return Theme.of(context).colorScheme.primary;
      default:
        return Colors.amber.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        centerTitle: true,
        actions: [
          if (provider.unreadCount > 0)
            TextButton(
              onPressed: () => context.read<NotificationsProvider>().markAllAsRead(),
              child: const Text('قراءة الكل'),
            ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.notifications.isEmpty
              ? const _EmptyNotifications()
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 30.h),
                  itemCount: provider.notifications.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) => _NotificationTile(
                    item: provider.notifications[index],
                    icon: _iconFor(provider.notifications[index].type),
                    color: _colorFor(context, provider.notifications[index].type),
                    onTap: () => context.read<NotificationsProvider>().markAsRead(provider.notifications[index].id),
                  ),
                ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification item;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _NotificationTile({required this.item, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: item.isRead ? theme.colorScheme.surface : color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: item.isRead ? theme.dividerColor : color.withValues(alpha: 0.35)),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              foregroundColor: color,
              child: Icon(icon, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(child: Text(item.title, textDirection: TextDirection.rtl, style: TextStyle(fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w800))),
                      if (!item.isRead) Container(width: 8.w, height: 8.w, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(item.body, textDirection: TextDirection.rtl, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
                  SizedBox(height: 6.h),
                  Text(intl.DateFormat('yyyy/MM/dd - HH:mm').format(item.createdAt), style: TextStyle(fontSize: 10.sp, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_none_rounded, size: 70, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 14),
              const Text('لا توجد إشعارات حاليًا', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('ستظهر هنا تذكيرات المهام والإنجازات الجديدة', textAlign: TextAlign.center),
            ],
          ),
        ),
      );
}
