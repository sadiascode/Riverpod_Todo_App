import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final double progress;
  final int completed;
  final int total;

  const ProgressCard({
    super.key,
    required this.progress,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's progress",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: const Color(0xFFE4EDE4),
                    valueColor:
                    const AlwaysStoppedAnimation(
                      Color(0xFF25874D),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: Color(0xFF25874D),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _stat(
                Icons.check_circle,
                '$completed',
                'Completed',
                const Color(0xFF64B982),
              ),
              _divider(),
              _stat(
                Icons.access_time,
                '${total - completed}',
                'In Progress',
                const Color(0xFFE5A83C),
              ),
              _divider(),
              _stat(
                Icons.radio_button_unchecked,
                '${total - completed}',
                'To Do',
                const Color(0xFF9A65D8),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 38,
    color: const Color(0xFFEEEEEE),
  );

  Widget _stat(
      IconData icon,
      String count,
      String label,
      Color color,
      ) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}