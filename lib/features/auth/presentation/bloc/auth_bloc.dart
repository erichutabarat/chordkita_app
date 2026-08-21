// auth_bloc.dart
import 'package:chordkita/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    // 1. App Started Check
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authRepository.checkSavedSession();
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (_) {
        emit(AuthUnauthenticated());
      }
    });

    // 2. Guest Mode
    on<GuestModeRequested>((event, emit) {
      emit(AuthGuest());
    });

    // 3. Login
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authRepository.login(
          email: event.email,
          password: event.password,
        );
        emit(AuthAuthenticated(user: user));
      } catch (e) {
        emit(AuthError(message: e.toString().replaceAll("Exception: ", "")));
      }
    });

    // 4. Register
    on<RegisterSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authRepository.register(
          name: event.name,
          email: event.email,
          password: event.password,
        );
        emit(AuthAuthenticated(user: user));
      } catch (e) {
        emit(AuthError(message: e.toString().replaceAll("Exception: ", "")));
      }
    });

    // 5. Logout
    on<LogoutRequested>((event, emit) async {
      await _authRepository.clearSession();
      emit(AuthUnauthenticated());
    });
  }
}
