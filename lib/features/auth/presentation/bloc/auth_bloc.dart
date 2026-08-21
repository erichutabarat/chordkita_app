import 'package:chordkita/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    // Handler Login
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

    // Handler Register
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

    // Handler Logout
    on<LogoutRequested>((event, emit) {
      emit(AuthUnauthenticated());
    });
  }
}
