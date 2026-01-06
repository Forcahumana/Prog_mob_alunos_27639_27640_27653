class Challenge {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int xpReward;
  final ChallengeType type;
  final int targetValue;
  final DateTime startDate;
  final DateTime endDate;
  final int currentProgress;
  final bool isCompleted;

  Challenge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.type,
    required this.targetValue,
    required this.startDate,
    required this.endDate,
    this.currentProgress = 0,
    this.isCompleted = false,
  });

  double get progressPercentage {
    return (currentProgress / targetValue * 100).clamp(0, 100);
  }

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate) && !isCompleted;
  }

  bool get isExpired {
    return DateTime.now().isAfter(endDate) && !isCompleted;
  }

  int get daysRemaining {
    final remaining = endDate.difference(DateTime.now()).inDays;
    return remaining > 0 ? remaining : 0;
  }

  Challenge copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    int? xpReward,
    ChallengeType? type,
    int? targetValue,
    DateTime? startDate,
    DateTime? endDate,
    int? currentProgress,
    bool? isCompleted,
  }) {
    return Challenge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      xpReward: xpReward ?? this.xpReward,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentProgress: currentProgress ?? this.currentProgress,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Challenge updateProgress(int newProgress) {
    final completed = newProgress >= targetValue;
    return copyWith(
      currentProgress: newProgress,
      isCompleted: completed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'xpReward': xpReward,
      'type': type.index,
      'targetValue': targetValue,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'currentProgress': currentProgress,
      'isCompleted': isCompleted,
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      xpReward: json['xpReward'],
      type: ChallengeType.values[json['type']],
      targetValue: json['targetValue'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      currentProgress: json['currentProgress'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  // Desafios predefinidos
  static List<Challenge> getWeeklyChallenges() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    return [
      Challenge(
        id: 'weekly_complete_21',
        name: 'Semana Produtiva',
        description: 'Completa 21 hábitos esta semana',
        icon: '📅',
        xpReward: 100,
        type: ChallengeType.weeklyCompletions,
        targetValue: 21,
        startDate: weekStart,
        endDate: weekEnd,
      ),
      Challenge(
        id: 'weekly_streak_7',
        name: 'Consistência Semanal',
        description: 'Mantém um streak de 7 dias',
        icon: '🔥',
        xpReward: 75,
        type: ChallengeType.streakDays,
        targetValue: 7,
        startDate: weekStart,
        endDate: weekEnd,
      ),
      Challenge(
        id: 'weekly_all_habits',
        name: 'Dia Perfeito',
        description: 'Completa todos os hábitos em 3 dias diferentes',
        icon: '⭐',
        xpReward: 150,
        type: ChallengeType.perfectDays,
        targetValue: 3,
        startDate: weekStart,
        endDate: weekEnd,
      ),
    ];
  }

  static List<Challenge> getMonthlyChallenges() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    return [
      Challenge(
        id: 'monthly_complete_90',
        name: 'Mês de Fogo',
        description: 'Completa 90 hábitos este mês',
        icon: '🏆',
        xpReward: 300,
        type: ChallengeType.monthlyCompletions,
        targetValue: 90,
        startDate: monthStart,
        endDate: monthEnd,
      ),
      Challenge(
        id: 'monthly_streak_30',
        name: 'Mestre da Consistência',
        description: 'Mantém um streak de 30 dias',
        icon: '👑',
        xpReward: 500,
        type: ChallengeType.streakDays,
        targetValue: 30,
        startDate: monthStart,
        endDate: monthEnd,
      ),
    ];
  }
}

enum ChallengeType {
  weeklyCompletions,
  monthlyCompletions,
  streakDays,
  perfectDays,
  newHabits,
}

