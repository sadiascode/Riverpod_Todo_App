import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class Todo {
  final String title;
  final String time;
  final bool isCompleted;

  const Todo({
    required this.title,
    required this.time,
    this.isCompleted = false,
  });

  Todo copyWith({bool? isCompleted}) {
    return Todo(
      title: title,
      time: time,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

final todoProvider =
StateNotifierProvider<TodoNotifier, List<Todo>>(
      (ref) => TodoNotifier(),
);

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier()
      : super([
    const Todo(title: 'Fajr Prayer', time: '04:40 AM'),
    const Todo(title: 'Dhikr Morning', time: '05:00 AM'),
    const Todo(title: 'Read a book', time: '05:30 AM'),
    const Todo(title: 'Study Flutter', time: '10:00 AM'),
    const Todo(title: 'Exercise', time: '06:00 PM'),
  ]);

  void toggleTask(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(
            isCompleted: !state[i].isCompleted,
          )
        else
          state[i],
    ];
  }

  int get completedCount =>
      state.where((task) => task.isCompleted).length;

  int get totalCount => state.length;

  double get progress =>
      totalCount == 0 ? 0 : completedCount / totalCount;
}