import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../data/authentication_bloc.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkLoginStatus(context);

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA), // Light Gray background
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/icons/bumba_icon.svg',
              width: 80,
              height: 80,
            ),
            SizedBox(width: 12),
            SvgPicture.asset(
              'assets/icons/bumbaText_icon.svg',
              width: 140,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  void _checkLoginStatus(BuildContext context) async {
    final isLoggedIn = await BlocProvider.of<AuthenticationBloc>(context).isLoggedIn();

    Future.delayed(Duration(seconds: 3), () {
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/tasks');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }
}
