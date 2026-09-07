import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/features/home/domain/entities/custom_task.dart';
import 'package:mariam/features/home/presentation/providers/custom_tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:mariam/core/theme/theme_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController(text: 'شخصي');

  TimeOfDay _selectedTime = TimeOfDay.now();
  TaskIcon _selectedIcon = TaskIcon.task;
  bool _isSaving = false;

  static const Color _accentPink = Color(0xFFFF80BF);
  static const Color _darkBg = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _lightBg = Color(0xFFF8F9FD);
  static const Color _lightSurface = Colors.white;

  static const _iconOptions = {
    TaskIcon.task: Icons.edit_note_rounded,
    TaskIcon.book: Icons.menu_book_rounded,
    TaskIcon.star: Icons.star_rounded,
    TaskIcon.personal: Icons.person_rounded,
    TaskIcon.prayer: Icons.mosque_rounded,
  };

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    FocusScope.of(context).unfocus();
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: _accentPink,
            onSurface: context.read<ThemeProvider>().isDarkMode ? Colors.white : Colors.black,
            surface: context.read<ThemeProvider>().isDarkMode ? _darkSurface : _lightSurface,
          ),
        ),
        child: Directionality(textDirection: TextDirection.rtl, child: child!),
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final task = CustomTask(
      id: '',
      title: _titleController.text.trim(),
      category: _categoryController.text.trim(),
      icon: _selectedIcon,
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
      date: DateTime.now(),
    );

    try {
      await context.read<CustomTasksProvider>().addTask(task);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('فشل حفظ المهمة، يرجى المحاولة مرة أخرى', textDirection: TextDirection.rtl),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    final bgColor = isDark ? _darkBg : _lightBg;
    final surfaceColor = isDark ? _darkSurface : _lightSurface;
    final primaryText = isDark ? Colors.white : const Color(0xFF212121);
    final secondaryText = isDark ? Colors.white54 : const Color(0xFF757575);
    final shadowColor = isDark ? Colors.black.withOpacity(0.3) : const Color(0xFFE8EAF6).withOpacity(0.8);

    // استخدام TimeOfDay المدمج لتلافي مشاكل تهيئة الـ intl
    final formattedTime = _selectedTime.format(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFF80BF), Color(0xFFFFB6D9)],
          ).createShader(bounds),
          child: Text(
            'إضافة بصمة جديدة ✨',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22.sp,
              color: Colors.white,
            ),
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: shadowColor, blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Center(
                child: Icon(Icons.arrow_back_ios_new_rounded, color: primaryText, size: 18.sp),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
            children: [
              _sectionTitle('ما هي مهمتك؟ 🎯', secondaryText),
              SizedBox(height: 12.h),
              _customGlassTextField(
                controller: _titleController,
                hint: 'مثال: مكالمة هامة مع العميل',
                surfaceColor: surfaceColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                shadowColor: shadowColor,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'لابد من كتابة عنوان للمهمة' : null,
              ),
              SizedBox(height: 24.h),

              _sectionTitle('في أي إطار تندرج؟ 🏷️', secondaryText),
              SizedBox(height: 12.h),
              _customGlassTextField(
                controller: _categoryController,
                hint: 'شخصي / عمل / دراسة...',
                surfaceColor: surfaceColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                shadowColor: shadowColor,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'برجاء تحديد تصنيف' : null,
              ),
              SizedBox(height: 24.h),

              _sectionTitle('متى موعدها؟ ⏰', secondaryText),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: _pickTime,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(28.r),
                    boxShadow: [
                      BoxShadow(color: shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                    border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.white),
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: _accentPink.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: const Icon(Icons.schedule_rounded, color: _accentPink),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded, size: 16.sp, color: secondaryText),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              _sectionTitle('اختر أيقونة مميزة 🎨', secondaryText),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(28.r),
                  boxShadow: [
                    BoxShadow(color: shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                  border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.white),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _iconOptions.entries.map((entry) {
                    final isSelected = _selectedIcon == entry.key;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIcon = entry.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color: isSelected ? _accentPink : Colors.transparent,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: isSelected
                              ? [BoxShadow(color: _accentPink.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))]
                              : [],
                        ),
                        child: Icon(
                          entry.value,
                          color: isSelected ? Colors.white : secondaryText.withOpacity(0.8),
                          size: 24.sp,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 40.h),

              SizedBox(
                width: double.infinity,
                height: 60.h,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentPink,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                    elevation: 8,
                    shadowColor: _accentPink.withOpacity(0.5),
                  ),
                  child: _isSaving
                      ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_rounded, color: Colors.white),
                      SizedBox(width: 8.w),
                      Text(
                        'إضافة المهمة الآن',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, Color color) => Text(
    text,
    textDirection: TextDirection.rtl,
    style: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: 0.5,
    ),
  );

  Widget _customGlassTextField({
    required TextEditingController controller,
    required String hint,
    required Color surfaceColor,
    required Color primaryText,
    required Color secondaryText,
    required Color shadowColor,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: context.read<ThemeProvider>().isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white),
      ),
      child: TextFormField(
        controller: controller,
        textDirection: TextDirection.rtl,
        validator: validator,
        maxLines: maxLines,
        style: TextStyle(
          color: primaryText,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintTextDirection: TextDirection.rtl,
          hintStyle: TextStyle(color: secondaryText.withOpacity(0.6), fontSize: 15.sp),
          filled: false,
          contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          border: InputBorder.none,
          errorStyle: TextStyle(color: Colors.redAccent, fontSize: 11.sp),
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      ),
    );
  }
}