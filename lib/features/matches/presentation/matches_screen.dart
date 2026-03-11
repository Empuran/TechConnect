import 'package:flutter/material.dart';
import 'package:nila/core/theme/app_theme.dart';
import 'package:nila/features/chat/presentation/chat_screen.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  final _demoMatches = const [
    {'name': 'Priya', 'role': 'UI Designer', 'company': 'UST', 'isNew': true},
    {'name': 'Anjali', 'role': 'Data Scientist', 'company': 'Infosys', 'isNew': true},
    {'name': 'Rahul', 'role': 'DevOps Engineer', 'company': 'TCS', 'isNew': false},
    {'name': 'Sneha', 'role': 'Product Manager', 'company': 'Wipro', 'isNew': false},
    {'name': 'Arjun', 'role': 'Backend Dev', 'company': 'Cognizant', 'isNew': false},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Matches', style: Theme.of(context).textTheme.displayMedium),
                Text('People who liked you back', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // New matches horizontal list
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _demoMatches.where((m) => m['isNew'] == true).length,
              itemBuilder: (ctx, i) {
                final match = _demoMatches.where((m) => m['isNew'] == true).toList()[i];
                return Container(
                  margin: const EdgeInsets.only(right: 14),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 64, height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(colors: AppColors.accentGradient),
                              boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 10)],
                            ),
                            child: Center(child: Text(match['name'].toString()[0], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))),
                          ),
                          Positioned(
                            right: 0, bottom: 0,
                            child: Container(
                              width: 18, height: 18,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(match['name'].toString(), style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('All Matches', style: Theme.of(context).textTheme.labelLarge),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _demoMatches.length,
              itemBuilder: (ctx, i) {
                final match = _demoMatches[i];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(name: match['name'].toString()))),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: i % 2 == 0 ? AppColors.primaryGradient : AppColors.accentGradient,
                            ),
                          ),
                          child: Center(child: Text(match['name'].toString()[0], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(match['name'].toString(), style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 8),
                                  if (match['isNew'] == true)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(10)),
                                      child: const Text('New', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                ],
                              ),
                              Text('${match['role']} · ${match['company']}', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chat_bubble_outline, color: AppColors.primary, size: 22),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
