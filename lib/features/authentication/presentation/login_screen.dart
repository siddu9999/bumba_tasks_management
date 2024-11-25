import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/authentication_bloc.dart';
import '../data/authentication_events.dart';
import '../data/authentication_states.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => Center(child: CircularProgressIndicator()),
            );
          } else if (state is AuthenticationSuccess) {
            Navigator.of(context).pop(); // Close loading dialog
            Navigator.of(context).pushReplacementNamed('/tasks');
          } else if (state is AuthenticationFailure) {
            Navigator.of(context).pop(); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/bumba_icon.svg', height: 40),
                  SizedBox(width: 8),
                  SvgPicture.asset('assets/icons/bumbaText_icon.svg', height: 40),
                ],
              ),
              SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(
                    color: Color(0xFF2D3436),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(
                      text: 'Signup for free',
                      style: TextStyle(color: Color(0xFF6C5CE7), fontSize: 12),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, '/signup');
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Sign in to Bumba',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 16),
              _buildInputField('EMAIL', 'Email address', _emailController),
              SizedBox(height: 16),
              _buildPasswordField('PASSWORD', 'Password', _passwordController),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/forgot-password');
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: Color(0xFF6C5CE7), fontSize: 12),
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(
                    LoginEvent(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C5CE7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Color(0xFF2D3436), fontSize: 12)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Color(0xFF2D3436), fontSize: 14),
            filled: true,
            fillColor: Color(0xFFFFFFFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Color(0xFFE1E4E8)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, String hint, TextEditingController controller) {
    bool _isObscured = true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Color(0xFF2D3436), fontSize: 12)),
        SizedBox(height: 8),
        StatefulBuilder(builder: (context, setState) {
          return TextField(
            controller: controller,
            obscureText: _isObscured,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Color(0xFF2D3436), fontSize: 14),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0), // Add padding to adjust size
                  child: Transform.scale(
                    scale: 1.2, // Reduce size
                    child: SvgPicture.asset('assets/icons/eye_icon.svg'),
                  ),
                ),
              ),
              filled: true,
              fillColor: Color(0xFFFFFFFF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Color(0xFFE1E4E8)),
              ),
            ),
          );
        }),
      ],
    );
  }

}
