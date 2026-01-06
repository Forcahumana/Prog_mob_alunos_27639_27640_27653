import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/challenge_card.dart';
import '../utils/constants.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        final activeChallenges = provider.activeChallenges;
        final completedChallenges = provider.completedChallenges;

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 180,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 40),
                                const Text(
                                  'Desafios',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Completa desafios para ganhar XP extra!',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    bottom: TabBar(
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white60,
                      tabs: [
                        Tab(text: 'Ativos (${activeChallenges.length})'),
                        Tab(text: 'Completos (${completedChallenges.length})'),
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  // Desafios Ativos
                  _buildChallengeList(
                    activeChallenges,
                    emptyMessage: 'Nenhum desafio ativo no momento',
                    emptyIcon: '🎯',
                  ),
                  // Desafios Completos
                  _buildChallengeList(
                    completedChallenges,
                    emptyMessage: 'Ainda não completaste nenhum desafio',
                    emptyIcon: '🏆',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChallengeList(
    List challenges, {
    required String emptyMessage,
    required String emptyIcon,
  }) {
    if (challenges.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emptyIcon,
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        return ChallengeCard(challenge: challenges[index]);
      },
    );
  }
}

