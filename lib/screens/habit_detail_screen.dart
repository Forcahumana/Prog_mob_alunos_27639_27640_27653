import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../utils/constants.dart';
import 'add_habit_screen.dart';

class HabitDetailScreen extends StatelessWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        // Obter o hábito atualizado do provider
        final currentHabit = provider.habits.firstWhere(
          (h) => h.id == habit.id,
          orElse: () => habit,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes do Hábito'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddHabitScreen(habitToEdit: currentHabit),
                    ),
                  );
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header com ícone e nome
              _buildHeader(currentHabit),
              const SizedBox(height: 24),

              // Estatísticas principais
              _buildMainStats(currentHabit),
              const SizedBox(height: 24),

              // Progresso
              _buildProgressSection(currentHabit),
              const SizedBox(height: 24),

              // Calendário de atividade
              _buildActivityCalendar(context, currentHabit),
              const SizedBox(height: 24),

              // Informações adicionais
              _buildInfoSection(currentHabit),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(Habit habit) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Ícone grande
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  habit.icon,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Nome
            Text(
              habit.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Descrição
            Text(
              habit.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Categoria
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                habit.category,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainStats(Habit habit) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            icon: '🔥',
            value: '${habit.currentStreak}',
            label: 'Streak Atual',
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            icon: '🏆',
            value: '${habit.bestStreak}',
            label: 'Melhor Streak',
            color: Colors.amber,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            icon: '✅',
            value: '${habit.totalCompletedDays}',
            label: 'Total Dias',
            color: AppTheme.successColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(Habit habit) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progresso para a Meta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${habit.totalCompletedDays} de ${habit.targetDays} dias',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: habit.completionPercentage / 100,
                          minHeight: 12,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            habit.completionPercentage >= 100
                                ? AppTheme.successColor
                                : AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: habit.completionPercentage >= 100
                        ? AppTheme.successColor.withOpacity(0.1)
                        : AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${habit.completionPercentage.toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: habit.completionPercentage >= 100
                            ? AppTheme.successColor
                            : AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (habit.completionPercentage >= 100) ...[
              const SizedBox(height: 12),
              const Row(
                children: [
                  Icon(Icons.check_circle, color: AppTheme.successColor, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Meta atingida! Parabéns! 🎉',
                    style: TextStyle(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCalendar(BuildContext context, Habit habit) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Atividade do Mês',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _getMonthName(now.month),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Dias da semana
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'].map((day) {
                return SizedBox(
                  width: 36,
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            // Grid do calendário
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: (firstWeekday - 1) + daysInMonth,
              itemBuilder: (context, index) {
                // Dias vazios antes do primeiro dia
                if (index < firstWeekday - 1) {
                  return const SizedBox();
                }

                final day = index - (firstWeekday - 2);
                final date = DateTime(now.year, now.month, day);
                final isCompleted = habit.completedDates.any(
                  (d) => d.year == date.year && d.month == date.month && d.day == date.day,
                );
                final isToday = date.day == now.day;
                final isFuture = date.isAfter(now);

                return Container(
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.successColor
                        : isToday
                            ? AppTheme.primaryColor.withOpacity(0.1)
                            : null,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday
                        ? Border.all(color: AppTheme.primaryColor, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 12,
                        color: isCompleted
                            ? Colors.white
                            : isFuture
                                ? Colors.grey[400]
                                : null,
                        fontWeight: isToday ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(Habit habit) {
    final daysSinceCreation = DateTime.now().difference(habit.createdAt).inDays;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informações',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.star,
              label: 'XP por conclusão',
              value: '+${habit.xpReward} XP',
            ),
            const Divider(),
            _InfoRow(
              icon: Icons.flag,
              label: 'Meta',
              value: '${habit.targetDays} dias',
            ),
            const Divider(),
            _InfoRow(
              icon: Icons.calendar_today,
              label: 'Criado há',
              value: '$daysSinceCreation dias',
            ),
            const Divider(),
            _InfoRow(
              icon: Icons.show_chart,
              label: 'Taxa de sucesso',
              value: daysSinceCreation > 0
                  ? '${(habit.totalCompletedDays / (daysSinceCreation + 1) * 100).toInt()}%'
                  : '-',
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return months[month - 1];
  }
}

class _StatBox extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;

  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

