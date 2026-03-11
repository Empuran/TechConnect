import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> signInWithOtp(String email) async {
    await _client.auth.signInWithOtp(
      email: email,
      emailRedirectTo: 'io.supabase.techconnect://login-callback/',
    );
  }

  Future<AuthResponse> verifyOTP(String email, String token) async {
    return await _client.auth.verifyOTP(
      type: OtpType.magiclink,
      email: email,
      token: token,
    );
  }
  
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Record a swipe (like or pass)
  Future<void> recordSwipe(String swipedUserId, bool isLike) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('swipes').insert({
      'swiper_id': userId,
      'swiped_id': swipedUserId,
      'is_like': isLike,
    });
  }

  // Fetch nearby profiles within a specific Tech Park location
  Future<List<Map<String, dynamic>>> getDiscoveryProfiles() async {
    final response = await _client
        .from('profiles')
        .select('id, first_name, age, company_name, job_role, profile_photos!inner(photo_url)')
        .eq('profile_photos.is_primary', true)
        .neq('id', _client.auth.currentUser!.id)
        .limit(20);
    return List<Map<String, dynamic>>.from(response);
  }
}
