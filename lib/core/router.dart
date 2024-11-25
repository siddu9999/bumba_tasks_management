import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../features/authentication/data/database_helper.dart';
import '../features/authentication/presentation/forgot_password.dart';
import '../features/authentication/presentation/login_screen.dart';
import '../features/authentication/presentation/signup_screen.dart';
import '../features/authentication/presentation/splash_screen.dart';

import '../features/task_management/data/task_bloc.dart';
import '../features/task_management/data/task_events.dart';
import '../features/task_management/presentation/task_screen.dart';
import '../main.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String tasks = '/tasks';

  static Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'task_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE tasks("
              "id INTEGER PRIMARY KEY, "
              "title TEXT, "
              "description TEXT, "
              "startDate TEXT, "
              "endDate TEXT, "
              "status INTEGER, "
              "userId INTEGER)", // Add userId column
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute("ALTER TABLE tasks ADD COLUMN userId INTEGER");
        }
      },


      version: 1,
    );
  }

  static Future<Route<dynamic>> onGenerateRoute(RouteSettings settings) async {
    final database = await _initDatabase();
    final databaseHelper = DatabaseHelper();
    final taskDatabase = await _initDatabase(); // Use _initDatabase for taskDatabase
    final authDatabaseHelper = DatabaseHelper();
    final authDatabase = await authDatabaseHelper.database; // Initialize authDatabase

    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignupScreen(databaseHelper: databaseHelper,));
    case forgotPassword:
      return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case tasks:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<TaskBloc>(
            create: (context) => TaskBloc(
              authDatabase: authDatabase,
              taskDatabase: taskDatabase,
            )..add(LoadTasksEvent()),
            child: TaskScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
