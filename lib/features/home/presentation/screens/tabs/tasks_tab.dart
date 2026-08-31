import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  final List<String> filters = [
    'الكل',
    'اليوم',
    'المكتملة',
  ];

  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'أذكار الصباح',
      'category': 'عبادات',
      'time': '07:00 ص',
      'icon': Icons.wb_sunny_outlined,
      'completed': true,
      'isReligious': true,
    },
    {
      'title': 'قراءة ورد القرآن',
      'category': 'قرآن',
      'time': '09:00 ص',
      'icon': Icons.menu_book_rounded,
      'completed': true,
      'isReligious': true,
    },
    {
      'title': 'مراجعة المهام اليومية',
      'category': 'شخصي',
      'time': '11:00 ص',
      'icon': Icons.edit_note_rounded,
      'completed': false,
      'isReligious': false,
    },
    {
      'title': 'صلاة الضحى',
      'category': 'عبادات',
      'time': '12:30 م',
      'icon': Icons.mosque_outlined,
      'completed': false,
      'isReligious': true,
    },
    {
      'title': 'قراءة سورة الكهف',
      'category': 'قرآن',
      'time': '04:00 م',
      'icon': Icons.auto_stories_outlined,
      'completed': false,
      'isReligious': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final completedCount = tasks.where((task) => task['completed'] == true).length;
    final progress = tasks.isEmpty ? 0.0 : completedCount / tasks.length;

    List<Map<String, dynamic>> filteredTasks;
    if (selectedFilter == 2) {
      filteredTasks = tasks.where((task) => task['completed'] == true).toList();
    } else {
      filteredTasks = tasks;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'tasks_fab',
        elevation: 8,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        onPressed: () {
          // ربط شاشة إضافة مهمة جديدة لاحقاً
        },
        child: Icon(
          Icons.add_rounded,
          size: 28.sp,
        ),
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
                      completedCount: completedCount,
                      totalCount: tasks.length,
                      progress: progress,
                    ),
                    SizedBox(height: 22.h),
                    TasksFilters(
                      filters: filters,
                      selectedFilter: selectedFilter,
                      onFilterSelected: (index) {
                        setState(() {
                          selectedFilter = index;
                        });
                      },
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          'قائمة اليوم',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${filteredTasks.length} مهام',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
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
                            onTap: () {
                              setState(() {
                                task['completed'] = !task['completed'];
                              });
                            },
                          ),
                        ),
                      ),
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