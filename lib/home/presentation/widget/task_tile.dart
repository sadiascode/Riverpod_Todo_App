import 'package:flutter/material.dart';
import '../../data/todo_provider.dart';

class TaskTile extends StatelessWidget {
  final Todo task;
  final VoidCallback onTap;

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = task.isCompleted
        ? const Color(0xFF62B982)
        : const Color(0xFFE7AD4C);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 9,
          horizontal: 4,
        ),
        child: Row(
          children: [
            Icon(
              task.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                  color: task.isCompleted
                      ? Colors.grey
                      : const Color(0xFF292D2A),
                ),
              ),
            ),
            Text(
              task.time,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}