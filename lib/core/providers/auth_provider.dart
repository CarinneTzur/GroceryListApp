import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// Auth state
class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? userId;
  final String? email;
  final bool isLoading;

  const AuthState({
    this.isAuthenticated = false,
    this.token,
    this.userId,
    this.email,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
    String? userId,
    String? email,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final SharedPreferences _prefs;

  AuthNotifier(this._prefs) : super(const AuthState()) {
    _loadAuthState();
  }

  void _loadAuthState() {
    final token = _prefs.getString('auth_token');
    final userId = _prefs.getString('user_id');
    final email = _prefs.getString('user_email');
    
    if (token != null && userId != null) {
      state = state.copyWith(
        isAuthenticated: true,
        token: token,
        userId: userId,
        email: email,
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      // Mock successful login
      const mockToken = 'mock_jwt_token';
      const mockUserId = 'user_123';
      
      await _prefs.setString('auth_token', mockToken);
      await _prefs.setString('user_id', mockUserId);
      await _prefs.setString('user_email', email);
      
      state = state.copyWith(
        isAuthenticated: true,
        token: mockToken,
        userId: mockUserId,
        email: email,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      // Mock successful registration
      const mockToken = 'mock_jwt_token';
      const mockUserId = 'user_123';
      
      await _prefs.setString('auth_token', mockToken);
      await _prefs.setString('user_id', mockUserId);
      await _prefs.setString('user_email', email);
      
      state = state.copyWith(
        isAuthenticated: true,
        token: mockToken,
        userId: mockUserId,
        email: email,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _prefs.remove('auth_token');
    await _prefs.remove('user_id');
    await _prefs.remove('user_email');
    
    state = const AuthState();
  }

  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthNotifier(prefs);
});
