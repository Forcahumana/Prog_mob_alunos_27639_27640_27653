import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import '../models/user_profile.dart';
import '../models/challenge.dart';

class StorageService {
  static const String _habitsKey = 'habits';
  static const String _userProfileKey = 'user_profile';
  static const String _challengesKey = 'challenges';

  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ==================== HABITS ====================

  Future<List<Habit>> loadHabits() async {
    await _ensureInitialized();
    final String? habitsJson = _prefs?.getString(_habitsKey);
    if (habitsJson == null || habitsJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> habitsList = jsonDecode(habitsJson);
      return habitsList.map((json) => Habit.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao carregar hábitos: $e');
      return [];
    }
  }

  Future<void> saveHabits(List<Habit> habits) async {
    await _ensureInitialized();
    final String habitsJson = jsonEncode(habits.map((h) => h.toJson()).toList());
    await _prefs?.setString(_habitsKey, habitsJson);
  }

  Future<void> addHabit(Habit habit) async {
    final habits = await loadHabits();
    habits.add(habit);
    await saveHabits(habits);
  }

  Future<void> updateHabit(Habit habit) async {
    final habits = await loadHabits();
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      habits[index] = habit;
      await saveHabits(habits);
    }
  }

  Future<void> deleteHabit(String habitId) async {
    final habits = await loadHabits();
    habits.removeWhere((h) => h.id == habitId);
    await saveHabits(habits);
  }

  // ==================== USER PROFILE ====================

  Future<UserProfile> loadUserProfile() async {
    await _ensureInitialized();
    final String? profileJson = _prefs?.getString(_userProfileKey);
    if (profileJson == null || profileJson.isEmpty) {
      return UserProfile();
    }

    try {
      return UserProfile.fromJson(jsonDecode(profileJson));
    } catch (e) {
      print('Erro ao carregar perfil: $e');
      return UserProfile();
    }
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await _ensureInitialized();
    final String profileJson = jsonEncode(profile.toJson());
    await _prefs?.setString(_userProfileKey, profileJson);
  }

  // ==================== CHALLENGES ====================

  Future<List<Challenge>> loadChallenges() async {
    await _ensureInitialized();
    final String? challengesJson = _prefs?.getString(_challengesKey);
    if (challengesJson == null || challengesJson.isEmpty) {
      // Retorna desafios padrão se não existirem
      return [
        ...Challenge.getWeeklyChallenges(),
        ...Challenge.getMonthlyChallenges(),
      ];
    }

    try {
      final List<dynamic> challengesList = jsonDecode(challengesJson);
      return challengesList.map((json) => Challenge.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao carregar desafios: $e');
      return [
        ...Challenge.getWeeklyChallenges(),
        ...Challenge.getMonthlyChallenges(),
      ];
    }
  }

  Future<void> saveChallenges(List<Challenge> challenges) async {
    await _ensureInitialized();
    final String challengesJson =
        jsonEncode(challenges.map((c) => c.toJson()).toList());
    await _prefs?.setString(_challengesKey, challengesJson);
  }

  // ==================== UTILITIES ====================

  Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      await init();
    }
  }

  Future<void> clearAllData() async {
    await _ensureInitialized();
    await _prefs?.clear();
  }
}

