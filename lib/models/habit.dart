import 'dart:convert';

class Habit {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String category;
  final int xpReward;
  final List<DateTime> completedDates;
  final DateTime createdAt;
  final int targetDays; // Meta de dias para completar

  Habit({
    required this.id,
    required this.name,
    required this.description,
    this.icon = '🎯',
    this.category = 'Geral',
    this.xpReward = 10,
    this.completedDates = const [],
    DateTime? createdAt,
    this.targetDays = 30,
  }) : createdAt = createdAt ?? DateTime.now();

  // Verifica se o hábito foi completado hoje
  bool get isCompletedToday {
    final now = DateTime.now();
    return completedDates.any((date) =>
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day);
  }

  // Calcula o streak atual (dias consecutivos)
  int get currentStreak {
    if (completedDates.isEmpty) return 0;

    final sortedDates = List<DateTime>.from(completedDates)
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime checkDate = DateTime.now();

    // Se não completou hoje, começar a contar de ontem
    if (!isCompletedToday) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    for (final date in sortedDates) {
      if (_isSameDay(date, checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (date.isBefore(checkDate)) {
        break;
      }
    }

    return streak;
  }

  // Calcula o melhor streak
  int get bestStreak {
    if (completedDates.isEmpty) return 0;

    final sortedDates = List<DateTime>.from(completedDates)
      ..sort((a, b) => a.compareTo(b));

    int bestStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < sortedDates.length; i++) {
      final diff = sortedDates[i].difference(sortedDates[i - 1]).inDays;
      if (diff == 1) {
        currentStreak++;
        if (currentStreak > bestStreak) {
          bestStreak = currentStreak;
        }
      } else if (diff > 1) {
        currentStreak = 1;
      }
    }

    return bestStreak;
  }

  // Percentagem de conclusão
  double get completionPercentage {
    if (targetDays == 0) return 0;
    return (completedDates.length / targetDays * 100).clamp(0, 100);
  }

  // Total de dias completados
  int get totalCompletedDays => completedDates.length;

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Cria uma cópia do hábito com modificações
  Habit copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? category,
    int? xpReward,
    List<DateTime>? completedDates,
    DateTime? createdAt,
    int? targetDays,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      xpReward: xpReward ?? this.xpReward,
      completedDates: completedDates ?? this.completedDates,
      createdAt: createdAt ?? this.createdAt,
      targetDays: targetDays ?? this.targetDays,
    );
  }

  // Adiciona uma data de conclusão
  Habit markAsCompleted(DateTime date) {
    if (completedDates.any((d) => _isSameDay(d, date))) {
      return this;
    }
    return copyWith(
      completedDates: [...completedDates, date],
    );
  }

  // Remove uma data de conclusão
  Habit unmarkAsCompleted(DateTime date) {
    return copyWith(
      completedDates: completedDates.where((d) => !_isSameDay(d, date)).toList(),
    );
  }

  // Conversão para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'category': category,
      'xpReward': xpReward,
      'completedDates': completedDates.map((d) => d.toIso8601String()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'targetDays': targetDays,
    };
  }

  // Criação a partir de JSON
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'] ?? '🎯',
      category: json['category'] ?? 'Geral',
      xpReward: json['xpReward'] ?? 10,
      completedDates: (json['completedDates'] as List<dynamic>?)
              ?.map((d) => DateTime.parse(d))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
      targetDays: json['targetDays'] ?? 30,
    );
  }

  @override
  String toString() {
    return 'Habit(id: $id, name: $name, streak: $currentStreak)';
  }
}

