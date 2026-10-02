import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:mariam/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:mariam/features/home/presentation/screens/tabs/tasks_tab.dart';
import 'package:mariam/features/home/presentation/widgets/task_item.dart';

class TodayTasksSection extends StatelessWidget {
  const TodayTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TasksProvider>();
    final today = DateTime.now();
    final tasks = provider.tasks.where((task) => task.date.year == today.year && task.date.month == today.month && task.date.day == today.day).take(4).toList();
    return Column(
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Text('مهام اليوم', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TasksTab())),
              child: Text('عرض الكل', style: TextStyle(fontSize: 11.sp, color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        if (tasks.isEmpty)
          const Padding(padding: EdgeInsets.all(20), child: Text('لا توجد مهام اليوم'))
        else
          ...tasks.map((task) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: TaskItem(
                  task: {'title': task.title, 'category': task.category, 'time': task.formattedTime, 'icon': task.icon, 'completed': task.completed},
                  onTap: () => context.read<TasksProvider>().toggleTask(task.id),
                ),
              )),
      ],
    );
  }
}
