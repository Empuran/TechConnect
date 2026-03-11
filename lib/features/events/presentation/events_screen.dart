import 'package:flutter/material.dart';
import 'package:nila/core/theme/app_theme.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  final _events = const [
    {'title': 'Tech Mixer Night', 'date': 'Fri, Mar 14 · 7:00 PM', 'location': 'Infopark Hub, Kochi', 'attendees': 34, 'tag': 'Networking', 'isFeatured': true},
    {'title': 'Lunch Match: UST Campus', 'date': 'Today · 1:00 PM', 'location': 'UST Cafeteria, Infopark', 'attendees': 12, 'tag': 'Lunch Match', 'isFeatured': false},
    {'title': 'Coffee & Code Meetup', 'date': 'Sat, Mar 15 · 10:00 AM', 'location': 'Infopark Phase 1', 'attendees': 22, 'tag': 'Casual', 'isFeatured': false},
    {'title': 'Startup Networking Night', 'date': 'Sun, Mar 16 · 6:30 PM', 'location': 'Smart City Hub, Kochi', 'attendees': 57, 'tag': 'Startup', 'isFeatured': false},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Events', style: Theme.of(context).textTheme.displayMedium),
                  Text('Tech meetups near Infopark', style: Theme.of(context).textTheme.bodyMedium),

                  // Lunch Match Banner
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: AppColors.accentGradient, begin: Alignment.centerLeft, end: Alignment.centerRight),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Text('🍱', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Lunch Match Available!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text('12 people looking for lunch in Infopark today', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                          child: const Text('Join', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Upcoming Events', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) {
                final event = _events[i];
                final tagColor = event['tag'] == 'Lunch Match' ? AppColors.accent : AppColors.primary;
                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: event['isFeatured'] == true
                        ? Border.all(color: AppColors.primary.withOpacity(0.4))
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: tagColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                            child: Text(event['tag'].toString(), style: TextStyle(color: tagColor, fontSize: 11, fontWeight: FontWeight.w600)),
                          ),
                          if (event['isFeatured'] == true) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.star, color: AppColors.gold, size: 14),
                            const Text(' Featured', style: TextStyle(color: AppColors.gold, fontSize: 11)),
                          ],
                          const Spacer(),
                          Icon(Icons.people_outline, color: AppColors.textMuted, size: 16),
                          const SizedBox(width: 4),
                          Text('${event['attendees']}', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(event['title'].toString(), style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 6),
                      Row(children: [
                        const Icon(Icons.calendar_today_outlined, color: AppColors.textMuted, size: 14),
                        const SizedBox(width: 6),
                        Text(event['date'].toString(), style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12)),
                      ]),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.location_on_outlined, color: AppColors.textMuted, size: 14),
                        const SizedBox(width: 6),
                        Text(event['location'].toString(), style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12)),
                      ]),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text('RSVP'),
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: _events.length,
            ),
          ),
        ],
      ),
    );
  }
}
