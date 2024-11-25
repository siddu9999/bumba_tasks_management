import 'package:bloc/bloc.dart';

import 'authentication_events.dart';
import 'authentication_model.dart';
import 'authentication_states.dart';
import 'database_helper.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final DatabaseHelper databaseHelper;

  AuthenticationBloc({required this.databaseHelper})
      : super(AuthenticationInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
    on<LogoutEvent>(_onLogout);
  }

  // Handle login: Save userId in session
  Future<void> _onLogin(LoginEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      final email = event.email.trim().toLowerCase();
      final password = event.password.trim();
      final user = await databaseHelper.getUserByEmail(email);

      if (user != null && user.password == password) {
        await databaseHelper.saveSession(user.id!); // Save the userId in session
        emit(AuthenticationSuccess());
      } else {
        emit(AuthenticationFailure(message: 'Invalid email or password'));
      }
    } catch (e) {
      emit(AuthenticationFailure(message: 'Error occurred while logging in'));
    }
  }

// Handle logout: Clear the session
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthenticationState> emit) async {
    await databaseHelper.clearSession(); // Clear the session in the database
    emit(AuthenticationInitial()); // Reset state to initial
  }



  Future<void> _onSignup(SignupEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      final userExists = await databaseHelper.getUserByEmail(event.email);
      if (userExists != null) {
        emit(AuthenticationFailure(message: 'User already exists'));
      } else {
        await databaseHelper.insertUser(
          UserModel(email: event.email, password: event.password),
        );
        emit(AuthenticationSuccess());
      }
    } catch (e) {
      emit(AuthenticationFailure(message: 'Error occurred during signup'));
    }
  }



  Future<bool> isLoggedIn() async {
    return await databaseHelper.isLoggedIn();
  }
}
