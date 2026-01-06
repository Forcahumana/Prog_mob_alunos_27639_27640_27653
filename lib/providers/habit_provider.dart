import 'package:flutter/foundation.dart';
import '../models/habit.dart';
import '../models/user_profile.dart';
import '../models/achievement.dart';
import '../models/challenge.dart';
import '../services/storage_service.dart';

class HabitProvider with ChangeNotifier {
  final StorageService _storage = StorageService();

  List<Habit> _habits = [];
  UserProfile _userProfile = UserProfile();
  List<Challenge> _challenges = [];
  List<Achievement> _newlyUnlockedAchievements = [];
  bool _isLoading = true;

  // Getters
  List<Habit> get habits => _habits;
  UserProfile get userProfile => _userProfile;
  List<Challenge> get challenges => _challenges;
  List<Achievement> get newlyUnlockedAchievements => _newlyUnlockedAchievements;
  bool get isLoading => _isLoading;

  // Hábitos de hoje
  List<Habit> get todayHabits => _habits;

  // Hábitos completados hoje
  List<Habit> get completedTodayHabits =>
      _habits.where((h) => h.isCompletedToday).toList();

  // Hábitos pendentes hoje
  List<Habit> get pendingTodayHabits =>
      _habits.where((h) => !h.isCompletedToday).toList();

  // Percentagem de conclusão hoje
  double get todayCompletionPercentage {
    if (_habits.isEmpty) return 0;
    return completedTodayHabits.length / _habits.length * 100;
  }

  // Total de completions
  int get totalCompletions {
    return _habits.fold(0, (sum, h) => sum + h.totalCompletedDays);
  }

  // Melhor streak global
  int get bestStreak {
    if (_habits.isEmpty) return 0;
    return _habits.map((h) => h.bestStreak).reduce((a, b) => a > b ? a : b);
  }

  // Streak atual mais alto
  int get currentBestStreak {
    if (_habits.isEmpty) return 0;
    return _habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b);
  }

  // Desafios ativos
  List<Challenge> get activeChallenges =>
      _challenges.where((c) => c.isActive).toList();

  // Desafios completados
  List<Challenge> get completedChallenges =>
      _challenges.where((c) => c.isCompleted).toList();

  // Inicialização
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _storage.init();
    _habits = await _storage.loadHabits();
    _userProfile = await _storage.loadUserProfile();
    _challenges = await _storage.loadChallenges();

    _isLoading = false;
    notifyListeners();
  }

  // Adicionar hábito
  Future<void> addHabit(Habit habit) async {
    _habits.add(habit);
    await _storage.saveHabits(_habits);

    // Verificar conquistas de total de hábitos
    _checkAchievements();
    notifyListeners();
  }

  // Atualizar hábito
  Future<void> updateHabit(Habit habit) async {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      await _storage.saveHabits(_habits);
      notifyListeners();
    }
  }

  // Eliminar hábito
  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((h) => h.id == habitId);
    await _storage.saveHabits(_habits);
    notifyListeners();
  }

  // Marcar hábito como completo
  Future<void> toggleHabitCompletion(String habitId) async {
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index == -1) return;

    final habit = _habits[index];
    final now = DateTime.now();

    if (habit.isCompletedToday) {
      // Desmarcar
      _habits[index] = habit.unmarkAsCompleted(now);
      _userProfile = _userProfile.copyWith(
        totalXp: (_userProfile.totalXp - habit.xpReward).clamp(0, 999999),
      );
    } else {
      // Marcar como completo
      _habits[index] = habit.markAsCompleted(now);
      _userProfile = _userProfile.addXp(habit.xpReward);

      // Atualizar desafios
      _updateChallengeProgress();
    }

    await _storage.saveHabits(_habits);
    await _storage.saveUserProfile(_userProfile);

    // Verificar conquistas
    _checkAchievements();

    notifyListeners();
  }

  // Atualizar progresso dos desafios
  void _updateChallengeProgress() {
    for (int i = 0; i < _challenges.length; i++) {
      final challenge = _challenges[i];
      if (!challenge.isActive) continue;

      int newProgress = challenge.currentProgress;

      switch (challenge.type) {
        case ChallengeType.weeklyCompletions:
        case ChallengeType.monthlyCompletions:
          newProgress = totalCompletions;
          break;
        case ChallengeType.streakDays:
          newProgress = currentBestStreak;
          break;
        case ChallengeType.perfectDays:
          if (todayCompletionPercentage == 100) {
            newProgress++;
          }
          break;
        case ChallengeType.newHabits:
          newProgress = _habits.length;
          break;
      }

      if (newProgress != challenge.currentProgress) {
        _challenges[i] = challenge.updateProgress(newProgress);

        // Se completou o desafio, adicionar XP
        if (_challenges[i].isCompleted && !challenge.isCompleted) {
          _userProfile = _userProfile.addXp(challenge.xpReward);
        }
      }
    }

    _storage.saveChallenges(_challenges);
  }

  // Verificar conquistas
  void _checkAchievements() {
    _newlyUnlockedAchievements = [];

    for (final achievement in Achievement.allAchievements) {
      if (_userProfile.unlockedAchievements.contains(achievement.id)) {
        continue;
      }

      bool shouldUnlock = false;

      switch (achievement.type) {
        case AchievementType.streak:
          shouldUnlock = currentBestStreak >= achievement.requirement ||
              bestStreak >= achievement.requirement;
          break;
        case AchievementType.totalHabits:
          shouldUnlock = _habits.length >= achievement.requirement;
          break;
        case AchievementType.totalCompletions:
          shouldUnlock = totalCompletions >= achievement.requirement;
          break;
        case AchievementType.level:
          shouldUnlock = _userProfile.level >= achievement.requirement;
          break;
        case AchievementType.special:
          if (achievement.id == 'perfect_day') {
            shouldUnlock = todayCompletionPercentage == 100 && _habits.isNotEmpty;
          } else if (achievement.id == 'early_bird') {
            shouldUnlock = DateTime.now().hour < 7 &&
                completedTodayHabits.isNotEmpty;
          }
          break;
      }

      if (shouldUnlock) {
        _userProfile = _userProfile.unlockAchievement(achievement.id);
        _userProfile = _userProfile.addXp(achievement.xpReward);
        _newlyUnlockedAchievements.add(achievement);
      }
    }

    if (_newlyUnlockedAchievements.isNotEmpty) {
      _storage.saveUserProfile(_userProfile);
    }
  }

  // Limpar conquistas recém-desbloqueadas
  void clearNewlyUnlockedAchievements() {
    _newlyUnlockedAchievements = [];
    notifyListeners();
  }

  // Atualizar nome do utilizador
  Future<void> updateUserName(String name) async {
    _userProfile = _userProfile.copyWith(name: name);
    await _storage.saveUserProfile(_userProfile);
    notifyListeners();
  }

  // Reiniciar dados
  Future<void> resetAllData() async {
    await _storage.clearAllData();
    _habits = [];
    _userProfile = UserProfile();
    _challenges = [
      ...Challenge.getWeeklyChallenges(),
      ...Challenge.getMonthlyChallenges(),
    ];
    notifyListeners();
  }
}

