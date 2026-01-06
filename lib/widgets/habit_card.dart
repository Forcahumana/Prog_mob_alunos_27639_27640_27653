import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../utils/constants.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback? onLongPress;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onToggle,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Botão de check
              _buildCheckButton(context),
              const SizedBox(width: 16),
              // Informações do hábito
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          habit.icon,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            habit.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: habit.isCompletedToday
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: habit.isCompletedToday
                                  ? Colors.grey
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      habit.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStreakBadge(),
                        const SizedBox(width: 12),
                        _buildXpBadge(),
                      ],
                    ),
                  ],
                ),
              ),
              // Indicador de progresso
              _buildProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckButton(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: habit.isCompletedToday
              ? AppTheme.successColor
              : Colors.transparent,
          border: Border.all(
            color: habit.isCompletedToday
                ? AppTheme.successColor
                : Colors.grey[400]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: habit.isCompletedToday
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              )
            : null,
      ),
    );
  }

  Widget _buildStreakBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: habit.currentStreak > 0
            ? Colors.orange.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🔥',
            style: TextStyle(
              fontSize: 12,
              color: habit.currentStreak > 0 ? null : Colors.grey,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${habit.currentStreak} dias',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: habit.currentStreak > 0
                  ? Colors.orange[700]
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXpBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '⭐',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Text(
            '+${habit.xpReward} XP',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return SizedBox(
      width: 45,
      height: 45,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: habit.completionPercentage / 100,
            strokeWidth: 4,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              habit.completionPercentage >= 100
                  ? AppTheme.successColor
                  : AppTheme.primaryColor,
            ),
          ),
          Text(
            '${habit.completionPercentage.toInt()}%',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

