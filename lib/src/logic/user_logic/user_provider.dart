import 'package:amathia/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authStateProvider = StreamProvider<AuthState>((ref){
  return supabase.auth.onAuthStateChange.map((data) {
    return data;
  });
});

final authSessionProvider = Provider((ref){
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (data) => data.session,
    loading: () => null,
    error: (_, __) => null,
  );
});

final userIdProvider = Provider<String?>((ref) {
  final session = ref.watch(authSessionProvider);
  return session?.user.id;
});
