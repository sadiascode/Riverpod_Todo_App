import 'package:flutter/material.dart';
import '../../data/todo_provider.dart';
import '../widget/category_card.dart';
import '../widget/progress_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widget/task_tile.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static const green = Color(0xFF25874D);

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoProvider);
    final notifier = ref.read(todoProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _header(),
                  const SizedBox(height: 22),
                  _banner(),
                  const SizedBox(height: 12),

                  ProgressCard(
                    progress: notifier.progress,
                    completed: notifier.completedCount,
                    total: notifier.totalCount,
                  ),

                  const SizedBox(height: 24),
                  _sectionTitle('Categories'),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 112,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        CategoryCard(
                          name: 'Home',
                          icon: Icons.home_rounded,
                          tasks: 8,
                          color: Color(0xFFB98250),
                        ),
                        SizedBox(width: 10),
                        CategoryCard(
                          name: 'Work / School',
                          icon: Icons.work_rounded,
                          tasks: 7,
                          color: Color(0xFF7C9C85),
                        ),
                        SizedBox(width: 10),
                        CategoryCard(
                          name: 'Worship / Ibadah',
                          icon: Icons.mosque_rounded,
                          tasks: 6,
                          color: Color(0xFF9C64D4),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  _sectionTitle("Today's Tasks"),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        for (int i = 0; i < todos.length; i++) ...[
                          TaskTile(
                            task: todos[i],
                            onTap: () => notifier.toggleTask(i),
                          ),
                          if (i != todos.length - 1)
                            const Divider(
                              height: 1,
                              color: Color(0xFFF1F1F1),
                            ),
                        ],
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Good morning, Sadia!',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202722),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "You've got this! Let's make today awesome",
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _banner() {
    return Container(
      height: 105,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF1F1D8),
            Color(0xFFDDEEDB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 155,
              child: Text(
                'Focus on progress,\nnot perfection.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                  color: Color(0xFF303B2E),
                ),
              ),
            ),
          ),
          Positioned(
            right: 3,
            top: 0,
            bottom: 0,
            child: Icon(
              Icons.landscape_rounded,
              size: 82,
              color: green.withValues(alpha: 0.7),
            ),
          ),
          const Positioned(
            right: 7,
            top: 0,
            child: Icon(
              Icons.wb_sunny_rounded,
              size: 23,
              color: Color(0xFFF0BF39),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(40, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'See All',
            style: TextStyle(
              fontSize: 11,
              color: green,
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomBar() {
    const icons = [
      Icons.home_rounded,
      Icons.checklist_rounded,
      Icons.add,
      Icons.bar_chart_rounded,
      Icons.person_outline_rounded,
    ];

    const labels = [
      'Home',
      'Tasks',
      '',
      'Progress',
      'Profile',
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              final selected = _selectedIndex == index;

              if (index == 2) {
                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add new task'),
                      ),
                    );
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                );
              }

              return InkWell(
                onTap: () {
                  setState(() => _selectedIndex = index);
                },
                child: SizedBox(
                  width: 58,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[index],
                        size: 21,
                        color: selected
                            ? green
                            : Colors.grey.shade400,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: 9,
                          color: selected
                              ? green
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}