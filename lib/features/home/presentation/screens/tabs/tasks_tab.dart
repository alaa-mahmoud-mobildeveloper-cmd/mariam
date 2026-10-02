import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:mariam/features/tasks/domain/entities/task.dart';
import 'package:mariam/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:mariam/features/tasks/presentation/screens/add_task_screen.dart';
import 'package:mariam/features/home/presentation/widgets/task_item.dart';
import 'package:mariam/features/home/presentation/widgets/tasks_empty_state.dart';
import 'package:mariam/features/home/presentation/widgets/tasks_filters.dart';
import 'package:mariam/features/home/presentation/widgets/tasks_header.dart';
import 'package:mariam/features/home/presentation/widgets/tasks_progress_card.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  int selectedFilter = 0;
  final filters = const ['الكل', 'اليوم', 'المكتملة'];

  Future<void> _addTask() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskScreen()));
  }

  Map<String, dynamic> _asMap(AppTask task) => {
        'title': task.title,
        'category': task.category,
        'time': task.formattedTime,
        'icon': task.icon,
        'completed': task.completed,
      };

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TasksProvider>();
    final tasks = provider.tasks;
    final filtered = selectedFilter == 2
        ? tasks.where((task) => task.completed).toList()
        : selectedFilter == 1
            ? tasks.where((task) {
                final now = DateTime.now();
                return task.date.year == now.year && task.date.month == now.month && task.date.day == now.day;
              }).toList()
            : tasks;
    final progress = tasks.isEmpty ? 0.0 : provider.completedCount / tasks.length;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'tasks_fab',
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: _addTask,
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 100.h),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const TasksHeader(),
                        SizedBox(height: 22.h),
                        TasksProgressCard(
                          completedCount: provider.completedCount,
                          totalCount: tasks.length,
                          progress: progress,
                          activeDays: tasks.where((task) => task.completed).map((task) => '${task.date.year}-${task.date.month}-${task.date.day}').toSet().length,
                        ),
                        SizedBox(height: 22.h),
                        TasksFilters(filters: filters, selectedFilter: selectedFilter, onFilterSelected: (index) => setState(() => selectedFilter = index)),
                        SizedBox(height: 18.h),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Text('قائمة اليوم', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),
                            const Spacer(),
                            Text('${filtered.length} مهام', style: TextStyle(fontSize: 9.sp, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
                          ],
                        ),
                        SizedBox(height: 11.h),
                        if (filtered.isEmpty)
                          const TasksEmptyState()
                        else
                          ...filtered.map((task) => Padding(
                                padding: EdgeInsets.only(bottom: 9.h),
                                child: Dismissible(
                                  key: ValueKey(task.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
                                    child: const Icon(Icons.delete_outline, color: Colors.white),
                                  ),
                                  onDismissed: (_) => context.read<TasksProvider>().deleteTask(task.id),
                                  child: TaskItem(task: _asMap(task), onTap: () => context.read<TasksProvider>().toggleTask(task.id)),
                                ),
                              )),
                      ]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
