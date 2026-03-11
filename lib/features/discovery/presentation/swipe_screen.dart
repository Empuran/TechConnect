import 'package:flutter/material.dart';
import 'package:nila/core/theme/app_theme.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});
  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> with TickerProviderStateMixin {
  late AnimationController _swipeController;
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  final List<Map<String, dynamic>> _profiles = [
    {'name': 'Priya Menon', 'age': 26, 'role': 'UX Designer', 'company': 'UST Global', 'bio': 'Coffee lover ☕ · Design nerd · Looking for someone to explore the Kochi food scene', 'interests': ['UI/UX', 'Travel', 'Photography'], 'verified': true, 'trust': 92, 'gradient': [0xFF4A90D9, 0xFF7B4FD9]},
    {'name': 'Anjali Krishnan', 'age': 28, 'role': 'Data Scientist', 'company': 'Infosys', 'bio': 'Python 🐍 · AI/ML · Bookworm · Want to find someone as passionate about data as I am', 'interests': ['AI/ML', 'Reading', 'Yoga'], 'verified': true, 'trust': 88, 'gradient': [0xFFFF6B6B, 0xFFFF8E53]},
    {'name': 'Neethu Rajan', 'age': 25, 'role': 'Product Manager', 'company': 'TCS', 'bio': 'Building products, one sprint at a time 🚀 · Foodie · Weekend hiker', 'interests': ['Product', 'Fitness', 'Cooking'], 'verified': false, 'trust': 65, 'gradient': [0xFF4CAF50, 0xFF45B3E0]},
    {'name': 'Lakshmi Pillai', 'age': 27, 'role': 'DevOps Engineer', 'company': 'Wipro', 'bio': 'Cloud native ☁️ · Open source contributor · Looking for genuine connections', 'interests': ['DevOps', 'Open Source', 'Music'], 'verified': true, 'trust': 95, 'gradient': [0xFF9C27B0, 0xFFE91E63]},
  ];

  int _currentIndex = 0;

  void _swipe(bool liked) {
    if (_currentIndex >= _profiles.length) return;
    if (liked) {
      _showMatchDialog(_profiles[_currentIndex]['name'].toString());
    }
    setState(() {
      _currentIndex++;
      _dragOffset = Offset.zero;
    });
  }

  void _showMatchDialog(String name) {
    if (_currentIndex % 2 != 0) return; // Only show for demo
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => _MatchDialog(name: name),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Row(
              children: [
                const Icon(Icons.nightlight_round, color: AppColors.primary, size: 26),
                const SizedBox(width: 8),
                Text('nila', style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: AppColors.primary, letterSpacing: 2)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.tune, color: AppColors.textSecondary), onPressed: () {}),
                IconButton(icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary), onPressed: () {}),
              ],
            ),
          ),

          // Card stack
          Expanded(
            child: _currentIndex >= _profiles.length
              ? _EmptyState()
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background card (next)
                    if (_currentIndex + 1 < _profiles.length)
                      Positioned(
                        top: 20,
                        child: Transform.scale(
                          scale: 0.93,
                          child: _ProfileCard(profile: _profiles[_currentIndex + 1], isTop: false),
                        ),
                      ),

                    // Top card (draggable)
                    GestureDetector(
                      onPanStart: (_) => setState(() => _isDragging = true),
                      onPanUpdate: (d) => setState(() => _dragOffset += d.delta),
                      onPanEnd: (_) {
                        setState(() => _isDragging = false);
                        if (_dragOffset.dx > 100) _swipe(true);
                        else if (_dragOffset.dx < -100) _swipe(false);
                        else setState(() => _dragOffset = Offset.zero);
                      },
                      child: AnimatedContainer(
                        duration: _isDragging ? Duration.zero : const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        transform: Matrix4.identity()
                          ..translate(_dragOffset.dx, _dragOffset.dy)
                          ..rotateZ(_dragOffset.dx * 0.003),
                        child: Stack(
                          children: [
                            _ProfileCard(profile: _profiles[_currentIndex], isTop: true),
                            if (_dragOffset.dx > 40)
                              Positioned(top: 40, left: 20, child: _SwipeLabel(text: 'LIKE', color: AppColors.success)),
                            if (_dragOffset.dx < -40)
                              Positioned(top: 40, right: 20, child: _SwipeLabel(text: 'PASS', color: AppColors.error)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          ),

          // Action buttons
          if (_currentIndex < _profiles.length)
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 12, 32, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionBtn(icon: Icons.close, color: AppColors.error, size: 28, onTap: () => _swipe(false)),
                  _ActionBtn(icon: Icons.star, color: AppColors.gold, size: 22, onTap: () {}),
                  _ActionBtn(icon: Icons.favorite, color: AppColors.accent, size: 28, onTap: () => _swipe(true)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  final bool isTop;
  const _ProfileCard({required this.profile, required this.isTop});

  @override
  Widget build(BuildContext context) {
    final colors = (profile['gradient'] as List).map((c) => Color(c as int)).toList();
    final trust = profile['trust'] as int;
    final trustColor = trust >= 80 ? AppColors.success : trust >= 50 ? AppColors.warning : AppColors.error;

    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: isTop ? [BoxShadow(color: colors.first.withOpacity(0.4), blurRadius: 25, offset: const Offset(0, 10))] : [],
      ),
      child: Stack(
        children: [
          // Content overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [Colors.transparent, Color(0xDD000000)],
                  begin: Alignment(0, -0.1), end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: trust badge + verified
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: trustColor.withOpacity(0.5)),
                      ),
                      child: Row(children: [
                        Icon(Icons.shield, color: trustColor, size: 12),
                        const SizedBox(width: 4),
                        Text('$trust% Trust', style: TextStyle(color: trustColor, fontSize: 11, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                    const Spacer(),
                    if (profile['verified'] == true)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(10)),
                        child: const Row(children: [
                          Icon(Icons.verified, color: AppColors.primary, size: 12),
                          SizedBox(width: 4),
                          Text('Verified', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                  ],
                ),

                const Spacer(),

                // Profile info
                Text('${profile['name']}, ${profile['age']}',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 2),
                Text('${profile['role']} · ${profile['company']}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                Text(profile['bio'].toString(),
                  style: const TextStyle(color: Colors.white60, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),

                // Interest chips
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: (profile['interests'] as List).map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white15, borderRadius: BorderRadius.circular(10)),
                    child: Text(tag.toString(), style: const TextStyle(color: Colors.white, fontSize: 11)),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SwipeLabel({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2.5),
        borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(0.1),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 2)),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.color, required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56, height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.nightlight_round, color: AppColors.primary, size: 64),
          const SizedBox(height: 20),
          Text("You've seen everyone nearby!", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Check back later for new profiles.', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _MatchDialog extends StatelessWidget {
  final String name;
  const _MatchDialog({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite, color: AppColors.accent, size: 56),
          const SizedBox(height: 16),
          Text("It's a Match! 🎉", style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 8),
          Text('You and $name liked each other!', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('Keep Swiping'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: Text('Message $name'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
