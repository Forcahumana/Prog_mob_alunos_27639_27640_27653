import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/achievement.dart';
import '../widgets/achievement_badge.dart';
import '../utils/constants.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        final unlockedIds = provider.userProfile.unlockedAchievements;
        final allAchievements = Achievement.allAchievements;

        final unlockedCount = unlockedIds.length;
        final totalCount = allAchievements.length;
        final progress = totalCount > 0 ? unlockedCount / totalCount : 0.0;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Conquistas',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Coleciona todas as conquistas!',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Text(
                                    '🏆',
                                    style: TextStyle(fontSize: 36),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Barra de progresso
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$unlockedCount de $totalCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${(progress * 100).toInt()}%',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 8,
                                    backgroundColor: Colors.white.withOpacity(0.3),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Conquistas por categoria
              ..._buildAchievementSections(allAchievements, unlockedIds),

              // Espaço no final
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildAchievementSections(
    List<Achievement> achievements,
    List<String> unlockedIds,
  ) {
    final categories = {
      AchievementType.streak: ('🔥 Streaks', 'Mantem a consistência'),
      AchievementType.totalHabits: ('🌱 Hábitos', 'Cria novos hábitos'),
      AchievementType.totalCompletions: ('✅ Completions', 'Completa hábitos'),
      AchievementType.level: ('📈 Níveis', 'Sobe de nível'),
      AchievementType.special: ('⭐ Especiais', 'Conquistas únicas'),
    };

    final List<Widget> sections = [];

    for (final entry in categories.entries) {
      final type = entry.key;
      final title = entry.value.$1;
      final subtitle = entry.value.$2;

      final typeAchievements =
          achievements.where((a) => a.type == type).toList();

      if (typeAchievements.isEmpty) continue;

      sections.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      sections.add(
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final achievement = typeAchievements[index];
                final isUnlocked = unlockedIds.contains(achievement.id);

                return AchievementBadge(
                  achievement: achievement,
                  isUnlocked: isUnlocked,
                );
              },
              childCount: typeAchievements.length,
            ),
          ),
        ),
      );
    }

    return sections;
  }
}

