// Import necessary packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_management/features/authentication/presentation/forgot_password.dart';
import 'package:task_management/features/authentication/presentation/login_screen.dart';
import 'package:task_management/features/authentication/presentation/signup_screen.dart';
import 'package:task_management/features/authentication/presentation/splash_screen.dart';

import 'features/authentication/data/authentication_bloc.dart';
import 'features/authentication/data/database_helper.dart';
import 'features/task_management/data/task_bloc.dart';
import 'features/task_management/data/task_events.dart';
import 'features/task_management/presentation/task_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseHelper = DatabaseHelper();
  await databaseHelper.database;

  final authDatabaseHelper = DatabaseHelper();
  final authDatabase = await authDatabaseHelper.database;

  final taskDatabase = await openDatabase(
    join(await getDatabasesPath(), 'task_database.db'),
    version: 1,
    onCreate: (db, version) {
      db.execute(
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
  );

  final taskBloc = TaskBloc(
    authDatabase: authDatabase,
    taskDatabase: taskDatabase,
  );

  runApp(MyApp(
    authDatabase: authDatabase,
    taskDatabase: taskDatabase,
    databaseHelper: databaseHelper,
    taskBloc: taskBloc,
  ));
}

class MyApp extends StatelessWidget {
  final Database authDatabase;
  final Database taskDatabase;
  final DatabaseHelper databaseHelper;
  final TaskBloc taskBloc;

  MyApp({
    required this.authDatabase,
    required this.taskDatabase,
    required this.databaseHelper,
    required this.taskBloc,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (context) => taskBloc..add(LoadTasksEvent()),
        ),
        BlocProvider(
          create: (context) =>
              AuthenticationBloc(databaseHelper: databaseHelper),
        ),
      ],
      child: MaterialApp(
        title: 'Task Management App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        routes: {
          '/tasks': (context) => TaskScreen(),
          '/login': (context) => LoginScreen(),
          '/forgot-password': (context) => ForgotPasswordScreen(),
          '/signup': (context) => SignupScreen(databaseHelper: databaseHelper),
        },
      ),
    );
  }
}
