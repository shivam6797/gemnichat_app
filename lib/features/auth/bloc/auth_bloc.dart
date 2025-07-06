import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemnichat_app/core/error/api_exception.dart';
import '../repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignInWithGooglePressed>(_onGoogleSignIn);
    on<SignOutPressed>(_onSignOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final user = authRepository.getCurrentUser();
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onGoogleSignIn(
    SignInWithGooglePressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signInWithGoogle();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(AuthFailure("Sign in aborted by user"));
        emit(Unauthenticated());
      }
    } catch (e) {
      String message = "Something went wrong";
      if (e is AppException) {
        message = e.message;
      } else {
        print("Unknown Sign-in Error: $e");
      }
      emit(AuthFailure(message));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignOut(SignOutPressed event, Emitter<AuthState> emit) async {
    await authRepository.signOut();
    emit(Unauthenticated());
  }
}
