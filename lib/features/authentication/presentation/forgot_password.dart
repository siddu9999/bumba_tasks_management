import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/authentication_bloc.dart';
import '../data/authentication_model.dart';
import '../data/database_helper.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/bumba_icon.svg', height: 40),
                SizedBox(width: 8),
                SvgPicture.asset('assets/icons/bumbaText_icon.svg', height: 40),
              ],
            ),
            SizedBox(height: 24),
            // Rich Text
            RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(color: Color(0xFF2D3436), fontSize: 12),
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
              'New password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            SizedBox(height: 16),
            // Email Input
            _buildInputField('EMAIL', 'Email address', _emailController),
            SizedBox(height: 16),
            // New Password
            _buildPasswordField('NEW PASSWORD', 'Password', _passwordController),
            SizedBox(height: 16),
            // Confirm Password
            _buildPasswordField('CONFIRM PASSWORD', 'Confirm Password', _confirmPasswordController),
            SizedBox(height: 24),
            // Continue Button
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text.trim();
                final newPassword = _passwordController.text.trim();
                final confirmPassword = _confirmPasswordController.text.trim();

                if (email.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('All fields are required!')),
                  );
                  return;
                }

                if (newPassword != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords do not match!')),
                  );
                  return;
                }

                final db = DatabaseHelper();
                final user = await db.getUserByEmail(email);

                if (user != null) {
                  // Use the new updatePasswordByEmail method
                  await db.updatePasswordByEmail(email, newPassword);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Password reset successfully!')),
                  );

                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Email not found!')),
                  );
                }
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
                  'Continue',
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

  Widget _buildPasswordField(String label, String hint, TextEditingController controller) {
    bool _isObscured = true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Color(0xFF2D3436), fontSize: 12)),
        SizedBox(height: 8),
        StatefulBuilder(
          builder: (context, setState) {
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
                    padding: const EdgeInsets.all(12.0),
                    child: Transform.scale(
                      scale: 0.8,
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
          },
        ),
      ],
    );
  }
}
