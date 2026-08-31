import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:mariam/core/theme/theme_provider.dart';
import '../../domain/entities/memory.dart';
import '../providers/memories_provider.dart';

class AddMemoryScreen extends StatefulWidget {
  const AddMemoryScreen({super.key});

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _picker = ImagePicker();

  DateTime _selectedDate = DateTime.now();
  MemoryIcon _selectedIcon = MemoryIcon.heart;
  final List<File> _selectedPhotos = [];

  static const _iconOptions = {
    MemoryIcon.heart: Icons.favorite_rounded,
    MemoryIcon.sparkle: Icons.auto_awesome_rounded,
    MemoryIcon.star: Icons.star_rounded,
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    final picked = await _picker.pickMultiImage(imageQuality: 80);
    if (picked.isEmpty) return;
    setState(() {
      _selectedPhotos.addAll(picked.map((x) => File(x.path)));
    });
  }

  void _removePhoto(int index) {
    setState(() => _selectedPhotos.removeAt(index));
  }

  Future<void> _pickDate(Color primary) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(primary: primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final memory = Memory(
      id: '',
      title: _titleController.text.trim(),
      date: _selectedDate,
      description: _descriptionController.text.trim(),
      icon: _selectedIcon,
    );

    final success = await context
        .read<MemoriesProvider>()
        .addMemory(memory, photos: _selectedPhotos);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حصل خطأ، حاول تاني')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final memoriesProvider = context.watch<MemoriesProvider>();
    final isDark = themeProvider.isDarkMode;
    final primary = isDark ? const Color(0xFFFFB6D9) : const Color(0xFFFF80BF);

    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'ذكرى جديدة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: themeProvider.primaryText),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: themeProvider.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 40.h),
            children: [
              _buildSectionLabel('الصور', themeProvider),
              SizedBox(height: 10.h),
              _buildPhotosPicker(themeProvider, primary),
              SizedBox(height: 24.h),

              _buildSectionLabel('عنوان الذكرى', themeProvider),
              SizedBox(height: 8.h),
              _buildTextField(
                controller: _titleController,
                hint: 'مثال: أول رحلة سوا',
                themeProvider: themeProvider,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'من فضلك اكتب عنوان للذكرى' : null,
              ),
              SizedBox(height: 22.h),

              _buildSectionLabel('التفاصيل', themeProvider),
              SizedBox(height: 8.h),
              _buildTextField(
                controller: _descriptionController,
                hint: 'احكي عن اللحظة دي بإيه ما تحب...',
                themeProvider: themeProvider,
                maxLines: 5,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'من فضلك اكتب وصف قصير' : null,
              ),
              SizedBox(height: 22.h),

              _buildSectionLabel('التاريخ', themeProvider),
              SizedBox(height: 8.h),
              _buildDatePickerTile(themeProvider, primary),
              SizedBox(height: 22.h),

              _buildSectionLabel('الأيقونة', themeProvider),
              SizedBox(height: 10.h),
              _buildIconSelector(themeProvider, primary),
              SizedBox(height: 34.h),

              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: memoriesProvider.isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
                    elevation: 0,
                  ),
                  child: memoriesProvider.isSaving
                      ? SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                      : Text(
                    'حفظ الذكرى',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotosPicker(ThemeProvider themeProvider, Color primary) {
    return SizedBox(
      height: 90.w,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          InkWell(
            onTap: _pickPhotos,
            borderRadius: BorderRadius.circular(18.r),
            child: Container(
              width: 90.w,
              height: 90.w,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: primary.withOpacity(0.4), style: BorderStyle.solid),
              ),
              child: Icon(Icons.add_photo_alternate_rounded, color: primary, size: 30.sp),
            ),
          ),
          ..._selectedPhotos.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            return Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: Image.file(
                      file,
                      width: 90.w,
                      height: 90.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removePhoto(index),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text, ThemeProvider themeProvider) {
    return Text(
      text,
      textDirection: TextDirection.rtl,
      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: themeProvider.primaryText),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required ThemeProvider themeProvider,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      textDirection: TextDirection.rtl,
      validator: validator,
      style: TextStyle(color: themeProvider.primaryText, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintTextDirection: TextDirection.rtl,
        hintStyle: TextStyle(color: themeProvider.secondaryText, fontSize: 13.sp),
        filled: true,
        fillColor: themeProvider.cardColor,
        contentPadding: EdgeInsets.all(16.w),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide(color: themeProvider.cardBorderColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide(color: themeProvider.cardBorderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: const BorderSide(color: Color(0xFFFF80BF), width: 1.6)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: const BorderSide(color: Colors.redAccent)),
      ),
    );
  }

  Widget _buildDatePickerTile(ThemeProvider themeProvider, Color primary) {
    const months = ['يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    final formatted = '${_selectedDate.day} ${months[_selectedDate.month - 1]} ${_selectedDate.year}';

    return InkWell(
      onTap: () => _pickDate(primary),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: themeProvider.cardBorderColor),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(Icons.calendar_today_rounded, color: primary, size: 20.sp),
            SizedBox(width: 12.w),
            Text(formatted, style: TextStyle(color: themeProvider.primaryText, fontSize: 14.sp)),
          ],
        ),
      ),
    );
  }

  Widget _buildIconSelector(ThemeProvider themeProvider, Color primary) {
    return Row(
      textDirection: TextDirection.rtl,
      children: _iconOptions.entries.map((entry) {
        final isSelected = _selectedIcon == entry.key;
        return Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: InkWell(
            onTap: () => setState(() => _selectedIcon = entry.key),
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: isSelected ? primary : themeProvider.cardColor,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: isSelected ? primary : themeProvider.cardBorderColor),
              ),
              child: Icon(entry.value, color: isSelected ? Colors.white : themeProvider.secondaryText, size: 24.sp),
            ),
          ),
        );
      }).toList(),
    );
  }
}