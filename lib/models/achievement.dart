class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int xpReward;
  final AchievementType type;
  final int requirement; // Valor necessário para desbloquear

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.type,
    required this.requirement,
  });

  // Lista de conquistas disponíveis na aplicação
  static const List<Achievement> allAchievements = [
    // Conquistas de Streak
    Achievement(
      id: 'streak_3',
      name: 'Primeiros Passos',
      description: 'Mantém um hábito por 3 dias seguidos',
      icon: '🔥',
      xpReward: 25,
      type: AchievementType.streak,
      requirement: 3,
    ),
    Achievement(
      id: 'streak_7',
      name: 'Uma Semana Forte',
      description: 'Mantém um hábito por 7 dias seguidos',
      icon: '💪',
      xpReward: 50,
      type: AchievementType.streak,
      requirement: 7,
    ),
    Achievement(
      id: 'streak_14',
      name: 'Duas Semanas',
      description: 'Mantém um hábito por 14 dias seguidos',
      icon: '⭐',
      xpReward: 100,
      type: AchievementType.streak,
      requirement: 14,
    ),
    Achievement(
      id: 'streak_30',
      name: 'Um Mês de Dedicação',
      description: 'Mantém um hábito por 30 dias seguidos',
      icon: '🏆',
      xpReward: 250,
      type: AchievementType.streak,
      requirement: 30,
    ),
    Achievement(
      id: 'streak_100',
      name: 'Centenário',
      description: 'Mantém um hábito por 100 dias seguidos',
      icon: '👑',
      xpReward: 1000,
      type: AchievementType.streak,
      requirement: 100,
    ),

    // Conquistas de Total de Hábitos
    Achievement(
      id: 'habits_1',
      name: 'Primeiro Hábito',
      description: 'Cria o teu primeiro hábito',
      icon: '🌱',
      xpReward: 10,
      type: AchievementType.totalHabits,
      requirement: 1,
    ),
    Achievement(
      id: 'habits_3',
      name: 'Trio de Hábitos',
      description: 'Cria 3 hábitos diferentes',
      icon: '🌿',
      xpReward: 30,
      type: AchievementType.totalHabits,
      requirement: 3,
    ),
    Achievement(
      id: 'habits_5',
      name: 'Colecionador',
      description: 'Cria 5 hábitos diferentes',
      icon: '🌳',
      xpReward: 50,
      type: AchievementType.totalHabits,
      requirement: 5,
    ),
    Achievement(
      id: 'habits_10',
      name: 'Mestre dos Hábitos',
      description: 'Cria 10 hábitos diferentes',
      icon: '🏅',
      xpReward: 100,
      type: AchievementType.totalHabits,
      requirement: 10,
    ),

    // Conquistas de Completions
    Achievement(
      id: 'complete_10',
      name: 'Dez Vezes',
      description: 'Completa hábitos 10 vezes no total',
      icon: '✅',
      xpReward: 25,
      type: AchievementType.totalCompletions,
      requirement: 10,
    ),
    Achievement(
      id: 'complete_50',
      name: 'Cinquenta',
      description: 'Completa hábitos 50 vezes no total',
      icon: '🎯',
      xpReward: 75,
      type: AchievementType.totalCompletions,
      requirement: 50,
    ),
    Achievement(
      id: 'complete_100',
      name: 'Cem Vezes',
      description: 'Completa hábitos 100 vezes no total',
      icon: '💯',
      xpReward: 150,
      type: AchievementType.totalCompletions,
      requirement: 100,
    ),
    Achievement(
      id: 'complete_500',
      name: 'Veterano',
      description: 'Completa hábitos 500 vezes no total',
      icon: '🌟',
      xpReward: 500,
      type: AchievementType.totalCompletions,
      requirement: 500,
    ),

    // Conquistas de Nível
    Achievement(
      id: 'level_5',
      name: 'Nível 5',
      description: 'Atinge o nível 5',
      icon: '📈',
      xpReward: 50,
      type: AchievementType.level,
      requirement: 5,
    ),
    Achievement(
      id: 'level_10',
      name: 'Nível 10',
      description: 'Atinge o nível 10',
      icon: '🚀',
      xpReward: 100,
      type: AchievementType.level,
      requirement: 10,
    ),

    // Conquistas Especiais
    Achievement(
      id: 'perfect_day',
      name: 'Dia Perfeito',
      description: 'Completa todos os hábitos num único dia',
      icon: '🌈',
      xpReward: 50,
      type: AchievementType.special,
      requirement: 1,
    ),
    Achievement(
      id: 'early_bird',
      name: 'Madrugador',
      description: 'Completa um hábito antes das 7h da manhã',
      icon: '🌅',
      xpReward: 25,
      type: AchievementType.special,
      requirement: 1,
    ),
  ];

  static Achievement? getById(String id) {
    try {
      return allAchievements.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }
}

enum AchievementType {
  streak,
  totalHabits,
  totalCompletions,
  level,
  special,
}

