import 'package:flutter/material.dart';
import '../../domain/entities/custom_task.dart';

IconData iconForTask(TaskIcon icon) {
  switch (icon) {
    case TaskIcon.task:
      return Icons.edit_note_rounded;
    case TaskIcon.book:
      return Icons.menu_book_rounded;
    case TaskIcon.star:
      return Icons.star_rounded;
    case TaskIcon.personal:
      return Icons.person_rounded;
    case TaskIcon.prayer:
      return Icons.mosque_rounded;
  }
}