import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/features/home/data/models/daily_task.dart';
import 'package:mariam/features/home/presentation/providers/custom_tasks_provider.dart';
import 'package:mariam/features/home/presentation/providers/tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:mariam/features/home/presentation/widgets/task_item.dart';
import 'package:mariam/features/home/presentation/widgets/tasks_empty_state.dart';
import 'package:mariam/features/home/presentation/widgets/tasks_filters.dart';
import 'package:mariam/features/home/presentation/widgets/tasks_header.dart';
import 'package:mariam/features/home/presentation/widgets/tasks_progress_card.dart';

import '../add_task_screen/add_task_screen.dart' show AddTaskScreen;

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  int selectedFilter = 0;
  final List<String> filters = ['الكل', 'اليوم', 'المكتملة'];

  Future<void> _pickTime(BuildContext context, DailyTask task) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: task.time,
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    );

    if (picked != null && context.mounted) {
      context.read<TasksProvider>().updateTaskTime(task.id, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tasksProvider = context.watch<TasksProvider>();

    // فلتر "المكتملة" بيعرض المهام المنجزة فقط (المكان الوحيد اللي تبان فيه)،
    // وباقي الفلاتر بتعرض visibleTasks (يعني كل حاجة عدا المنجزة، فبتختفي منها).
    final filteredTasks =
    selectedFilter == 2 ? tasksProvider.completedTasks : tasksProvider.visibleTasks;
    final customTasksProvider = context.watch<CustomTasksProvider>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'tasks_fab',
        elevation: 8,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
        },
        child: Icon(Icons.add_rounded, size: 28.sp),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 100.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const TasksHeader(),
                    SizedBox(height: 22.h),
                    TasksProgressCard(
                      completedCount: tasksProvider.completedCount,
                      totalCount: tasksProvider.totalCount,
                      progress: tasksProvider.progress,
                    ),
                    SizedBox(height: 22.h),
                    TasksFilters(
                      filters: filters,
                      selectedFilter: selectedFilter,
                      onFilterSelected: (index) => setState(() => selectedFilter = index),
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          'قائمة اليوم',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: colorScheme.onSurface),
                        ),
                        const Spacer(),
                        Text(
                          '${filteredTasks.length} مهام',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 9.sp, color: colorScheme.onSurface.withValues(alpha: 0.6)),
                        ),
                      ],
                    ),
                    SizedBox(height: 11.h),
                    if (filteredTasks.isEmpty)
                      const TasksEmptyState()
                    else
                      ...filteredTasks.map(
                            (task) => Padding(
                          padding: EdgeInsets.only(bottom: 9.h),
                          child: TaskItem(
                            task: task,
                            onTap: () => context.read<TasksProvider>().toggleTask(task.id),
                            onLongPress: () => _pickTime(context, task),
                          ),
                        ),
                      ),
                    // بعد قائمة filteredTasks (الثابتة)، ضيف:
                    if (customTasksProvider.tasks.isNotEmpty) ...[
                      SizedBox(height: 18.h),

                      Text(
                        'مهامك المضافة',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),

                      SizedBox(height: 11.h),

                      ...customTasksProvider.tasks.map(
                            (task) => Padding(
                          padding: EdgeInsets.only(bottom: 9.h),

                          child: Dismissible(
                            key: ValueKey(task.id),

                            direction: DismissDirection.endToStart,

                            confirmDismiss: (_) async {
                              return await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('حذف المهمة'),
                                    content: const Text(
                                      'هل أنت متأكد أنك تريد حذف هذه المهمة؟',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('إلغاء'),
                                      ),

                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text(
                                          'حذف',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ) ??
                                  false;
                            },

                            onDismissed: (_) {
                              context
                                  .read<CustomTasksProvider>()
                                  .deleteTask(task.id);
                            },

                            background: Container(
                              alignment: Alignment.centerLeft,

                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(18.r),
                              ),

                              child: const Icon(
                                Icons.delete_rounded,
                                color: Colors.white,
                              ),
                            ),

                            child: GestureDetector(
                              onTap: () {
                                context.read<CustomTasksProvider>().toggleTask(task.id, !task.completed,);
                                context.read<CustomTasksProvider>().deleteTask(task.id);
                              },

                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: task.completed
                                      ? const Color(0xFFFF80BF).withOpacity(0.06)
                                      : Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(22.r),
                                  border: Border.all(
                                    color: task.completed
                                        ? const Color(0xFFFF80BF).withOpacity(0.25)
                                        : colorScheme.outline.withOpacity(0.12),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(task.completed ? 0.015 : 0.04),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // =========================
                                    // Check Button
                                    // =========================
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      width: 44.w,
                                      height: 44.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: task.completed
                                            ? const Color(0xFFFF80BF)
                                            : colorScheme.surfaceContainerHighest.withOpacity(0.35),
                                        boxShadow: task.completed
                                            ? [
                                          BoxShadow(
                                            color: const Color(0xFFFF80BF).withOpacity(0.35),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          )
                                        ]
                                            : [],
                                      ),
                                      child: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 200),
                                        transitionBuilder: (child, animation) => ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        ),
                                        child: Icon(
                                          task.completed ? Icons.check_rounded : Icons.radio_button_unchecked,
                                          key: ValueKey(task.completed),
                                          size: 22.sp,
                                          color: task.completed
                                              ? Colors.white
                                              : colorScheme.onSurface.withOpacity(0.4),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 14.w),

                                    // =========================
                                    // Task Content
                                    // =========================
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AnimatedDefaultTextStyle(
                                            duration: const Duration(milliseconds: 200),
                                            style: TextStyle(
                                              fontSize: 14.5.sp,
                                              fontWeight: FontWeight.w600,
                                              height: 1.35,
                                              color: task.completed
                                                  ? colorScheme.onSurface.withOpacity(0.4)
                                                  : colorScheme.onSurface,
                                              decoration: task.completed
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                              decorationColor: const Color(0xFFFF80BF),
                                              decorationThickness: 2,
                                            ),
                                            child: Text(
                                              task.title,
                                              textDirection: TextDirection.rtl,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          SizedBox(height: 6.h),

                                          // Subtitle / Status Tag
                                          AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 200),
                                            child: task.completed
                                                ? Row(
                                              key: const ValueKey('tag_completed'),
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.verified_rounded,
                                                  size: 13.sp,
                                                  color: const Color(0xFFFF80BF),
                                                ),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  'تم الانجاز بنجاح',
                                                  style: TextStyle(
                                                    fontSize: 11.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xFFFF80BF),
                                                  ),
                                                ),
                                              ],
                                            )
                                                : Container(
                                              key: const ValueKey('tag_pending'),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 2.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: colorScheme.surfaceContainerHighest
                                                    .withOpacity(0.5),
                                                borderRadius: BorderRadius.circular(6.r),
                                              ),
                                              child: Text(
                                                'مهمة شخصية',
                                                style: TextStyle(
                                                  fontSize: 10.5.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: colorScheme.onSurface.withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: 10.w),

                                    // =========================
                                    // Trailing Action Badge / Icon
                                    // =========================
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 200),
                                      child: task.completed
                                          ? Container(
                                        key: const ValueKey('badge_done'),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF80BF).withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        child: Text(
                                          'منجزة',
                                          style: TextStyle(
                                            fontSize: 10.5.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFFFF80BF),
                                          ),
                                        ),
                                      )
                                          : Container(
                                        key: const ValueKey('badge_arrow'),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF80BF).withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        child: Text(
                                          ' فى انتظارك لانجاز المهمه',
                                          style: TextStyle(
                                            fontSize: 10.5.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFFFF80BF),
                                          ),
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}