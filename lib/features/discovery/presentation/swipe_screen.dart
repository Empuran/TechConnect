import 'package:flutter/material.dart';
import 'package:techconnect/services/supabase_service.dart';

// Assuming package `flutter_card_swiper` or similar logic is used
// Here is a simplified widget block for the MVP demonstration

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  final _supabaseService = SupabaseService();
  List<Map<String, dynamic>> _profiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    try {
      final profiles = await _supabaseService.getDiscoveryProfiles();
      setState(() {
        _profiles = profiles;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSwipe(int index, bool isLike) {
    if (index >= _profiles.length) return;
    final profile = _profiles[index];
    _supabaseService.recordSwipe(profile['id'], isLike);
    
    // In a real app, update UI stack. Here we just print.
    print('Swiped $isLike on ${profile['first_name']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discovery: Infopark'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _supabaseService.signOut(),
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _profiles.isEmpty 
          ? const Center(child: Text('No profiles found nearby.'))
          : Stack(
              children: _profiles.asMap().entries.map((entry) {
                final index = entry.key;
                final profile = entry.value;
                // Basic representation of a profile card
                return Positioned.fill(
                  child: Card(
                    margin: const EdgeInsets.all(16),
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: profile['profile_photos'] != null && profile['profile_photos'].isNotEmpty
                                ? Image.network(profile['profile_photos'][0]['photo_url'], fit: BoxFit.cover)
                                : Container(color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${profile['first_name']}, ${profile['age'] ?? '28'}',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text('${profile['job_role']} @ ${profile['company_name']}'),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.orange, size: 40),
                                    onPressed: () => _onSwipe(index, false),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.favorite, color: Colors.pink, size: 40),
                                    onPressed: () => _onSwipe(index, true),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList().reversed.toList(), // Reversed to show current profile at top
            ),
    );
  }
}
