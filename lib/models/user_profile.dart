class UserProfile {
  final String name;
  final int totalXp;
  final int level;
  final List<String> unlockedAchievements;
  final DateTime createdAt;

  UserProfile({
    this.name = 'Utilizador',
    this.totalXp = 0,
    this.unlockedAchievements = const [],
    DateTime? createdAt,
  })  : level = _calculateLevel(totalXp),
        createdAt = createdAt ?? DateTime.now();

  // Calcula o nível baseado no XP total
  static int _calculateLevel(int xp) {
    // Cada nível requer progressivamente mais XP
    // Nível 1: 0 XP, Nível 2: 100 XP, Nível 3: 250 XP, etc.
    if (xp < 100) return 1;
    if (xp < 250) return 2;
    if (xp < 500) return 3;
    if (xp < 850) return 4;
    if (xp < 1300) return 5;
    if (xp < 1850) return 6;
    if (xp < 2500) return 7;
    if (xp < 3250) return 8;
    if (xp < 4100) return 9;
    if (xp < 5000) return 10;
    return 10 + ((xp - 5000) ~/ 1000);
  }

  // XP necessário para o próximo nível
  int get xpForNextLevel {
    switch (level) {
      case 1:
        return 100;
      case 2:
        return 250;
      case 3:
        return 500;
      case 4:
        return 850;
      case 5:
        return 1300;
      case 6:
        return 1850;
      case 7:
        return 2500;
      case 8:
        return 3250;
      case 9:
        return 4100;
      case 10:
        return 5000;
      default:
        return 5000 + (level - 10) * 1000;
    }
  }

  // XP do nível atual (início do nível)
  int get xpForCurrentLevel {
    switch (level) {
      case 1:
        return 0;
      case 2:
        return 100;
      case 3:
        return 250;
      case 4:
        return 500;
      case 5:
        return 850;
      case 6:
        return 1300;
      case 7:
        return 1850;
      case 8:
        return 2500;
      case 9:
        return 3250;
      case 10:
        return 4100;
      default:
        return 5000 + (level - 11) * 1000;
    }
  }

  // Progresso no nível atual (0.0 a 1.0)
  double get levelProgress {
    final xpInLevel = totalXp - xpForCurrentLevel;
    final xpNeeded = xpForNextLevel - xpForCurrentLevel;
    return (xpInLevel / xpNeeded).clamp(0.0, 1.0);
  }

  // Título baseado no nível
  String get title {
    if (level <= 2) return 'Iniciante';
    if (level <= 4) return 'Aprendiz';
    if (level <= 6) return 'Praticante';
    if (level <= 8) return 'Dedicado';
    if (level <= 10) return 'Mestre';
    if (level <= 15) return 'Grão-Mestre';
    return 'Lenda';
  }

  UserProfile copyWith({
    String? name,
    int? totalXp,
    List<String>? unlockedAchievements,
    DateTime? createdAt,
  }) {
    return UserProfile(
      name: name ?? this.name,
      totalXp: totalXp ?? this.totalXp,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  UserProfile addXp(int xp) {
    return copyWith(totalXp: totalXp + xp);
  }

  UserProfile unlockAchievement(String achievementId) {
    if (unlockedAchievements.contains(achievementId)) {
      return this;
    }
    return copyWith(
      unlockedAchievements: [...unlockedAchievements, achievementId],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'totalXp': totalXp,
      'unlockedAchievements': unlockedAchievements,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? 'Utilizador',
      totalXp: json['totalXp'] ?? 0,
      unlockedAchievements:
          List<String>.from(json['unlockedAchievements'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

