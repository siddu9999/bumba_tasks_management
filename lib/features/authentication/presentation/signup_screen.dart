import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/authentication_model.dart';
import '../data/database_helper.dart';

class SignupScreen extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  SignupScreen({required this.databaseHelper});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;

  Future<void> _registerUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required!')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    try {
      // Check if user already exists
      final existingUser = await widget.databaseHelper.getUserByEmail(email);
      if (existingUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User already exists!')),
        );
        return;
      }

      // Insert new user
      await widget.databaseHelper.insertUser(
        UserModel(id: 0, email: email, password: password),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User signed up successfully!')),
      );

      // Navigate back to Login screen
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during signup. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Padding(
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
                text: 'Already have an account? ',
                style: TextStyle(
                  color: Color(0xFF2D3436),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                children: [
                  TextSpan(
                    text: 'Login.',
                    style: TextStyle(color: Color(0xFF6C5CE7), fontSize: 12),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pop(context);
                      },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Sign up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF2D3436),
              ),
            ),
            SizedBox(height: 16),
            _buildInputField('Email', 'Email address', _emailController),
            SizedBox(height: 16),
            _buildPasswordField('Password', 'Password', _passwordController, isConfirmField: false),
            SizedBox(height: 16),
            _buildPasswordField('Confirm Password', 'Confirm password', _confirmPasswordController, isConfirmField: true),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6C5CE7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Center(
                child: Text(
                  'Sign up',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ],
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

  Widget _buildPasswordField(String label, String hint, TextEditingController controller, {required bool isConfirmField}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Color(0xFF2D3436), fontSize: 12)),
        SizedBox(height: 8),
        StatefulBuilder(builder: (context, setState) {
          final isObscured = isConfirmField ? _isObscuredConfirmPassword : _isObscuredPassword;
          return TextField(
            controller: controller,
            obscureText: isObscured,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Color(0xFF2D3436), fontSize: 14),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isConfirmField) {
                      _isObscuredConfirmPassword = !_isObscuredConfirmPassword;
                    } else {
                      _isObscuredPassword = !_isObscuredPassword;
                    }
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
