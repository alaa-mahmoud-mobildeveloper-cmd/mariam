import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/tasks_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  TimeOfDay _time = TimeOfDay.now();
  String _category = 'شخصي';
  IconData _icon = Icons.task_alt_rounded;
  bool _saving = false;

  final _categories = const ['شخصي', 'عبادات', 'قرآن', 'صلاة'];
  final _icons = const [Icons.task_alt_rounded, Icons.wb_sunny_outlined, Icons.menu_book_rounded, Icons.mosque_outlined, Icons.favorite_outline_rounded];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await context.read<TasksProvider>().addTask(
      title: _titleController.text.trim(),
      category: _category,
      time: _time,
      icon: _icon,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('مهمة جديدة'), centerTitle: true),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20.w),
            children: [
              TextFormField(
                controller: _titleController,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(labelText: 'اسم المهمة', hintText: 'مثال: قراءة ورد القرآن'),
                validator: (value) => value == null || value.trim().isEmpty ? 'اكتب اسم المهمة' : null,
              ),
              SizedBox(height: 18.h),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'التصنيف'),
                items: _categories.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                onChanged: (value) => setState(() => _category = value ?? _category),
              ),
              SizedBox(height: 18.h),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('الوقت'),
                subtitle: Text(_time.format(context)),
                trailing: Icon(Icons.access_time_rounded, color: scheme.primary),
                onTap: () async {
                  final picked = await showTimePicker(context: context, initialTime: _time);
                  if (picked != null) setState(() => _time = picked);
                },
              ),
              SizedBox(height: 12.h),
              const Text('الأيقونة'),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 10,
                children: _icons.map((icon) => ChoiceChip(
                  label: Icon(icon),
                  selected: _icon == icon,
                  onSelected: (_) => setState(() => _icon = icon),
                )).toList(),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                height: 52.h,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving ? const CircularProgressIndicator() : const Text('حفظ المهمة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
