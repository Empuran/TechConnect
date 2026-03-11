import 'package:flutter/material.dart';
import 'package:nila/core/theme/app_theme.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Profile', style: Theme.of(context).textTheme.displayMedium),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Profile Card Preview
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  // Photo area
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      gradient: LinearGradient(
                        colors: [AppColors.primary.withOpacity(0.5), AppColors.surfaceVariant],
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      ),
                    ),
                    child: const Center(child: Icon(Icons.person, size: 64, color: AppColors.textMuted)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Arjun Nair, 27', style: Theme.of(context).textTheme.headlineLarge),
                            const Spacer(),
                            _TrustBadge(score: 70),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text('Software Engineer · UST Global', style: TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        const Row(children: [
                          Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                          SizedBox(width: 4),
                          Text('Infopark, Kochi', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Verification badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Verification', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      _VerifyBadge(label: '✔ Email', verified: true),
                      SizedBox(width: 8),
                      _VerifyBadge(label: '✔ Selfie', verified: false),
                      SizedBox(width: 8),
                      _VerifyBadge(label: '✔ LinkedIn', verified: false),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Text('Profile Completeness', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 10),
                  _CompletenessBar(pct: 0.60),

                  const SizedBox(height: 24),
                  Text('Settings', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // Settings list
            ...[
              {'icon': Icons.tune, 'title': 'Discovery Preferences'},
              {'icon': Icons.notifications_outlined, 'title': 'Notifications'},
              {'icon': Icons.lock_outline, 'title': 'Privacy & Safety'},
              {'icon': Icons.help_outline, 'title': 'Help & Support'},
              {'icon': Icons.logout, 'title': 'Log Out'},
            ].map((item) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
              leading: Icon(item['icon'] as IconData, color: item['title'] == 'Log Out' ? AppColors.error : AppColors.textSecondary),
              title: Text(item['title'].toString(), style: TextStyle(color: item['title'] == 'Log Out' ? AppColors.error : AppColors.textPrimary)),
              trailing: item['title'] != 'Log Out' ? const Icon(Icons.chevron_right, color: AppColors.textMuted) : null,
              onTap: () {},
            )),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final int score;
  const _TrustBadge({required this.score});

  Color get color {
    if (score >= 80) return AppColors.success;
    if (score >= 50) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.shield, color: color, size: 14),
          const SizedBox(width: 4),
          Text('$score%', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

class _VerifyBadge extends StatelessWidget {
  final String label;
  final bool verified;
  const _VerifyBadge({required this.label, required this.verified});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: verified ? AppColors.success.withOpacity(0.15) : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: verified ? AppColors.success.withOpacity(0.4) : Colors.transparent),
      ),
      child: Text(label, style: TextStyle(color: verified ? AppColors.success : AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _CompletenessBar extends StatelessWidget {
  final double pct;
  const _CompletenessBar({required this.pct});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 8,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        const SizedBox(height: 4),
        Text('${(pct * 100).toInt()}% complete', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }
}
