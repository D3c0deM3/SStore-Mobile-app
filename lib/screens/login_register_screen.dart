import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sstore_app/screens/plan_choosing_screen.dart';

void main() {
  runApp(SStoreApp());
}

class SStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginRegisterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginRegisterScreen extends StatefulWidget {
  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  bool isLogin = true;
  bool isLoading = false;

  final TextEditingController marketController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  final Color bgColor = const Color(0xFF042631);
  final Color textColor = const Color(0xFFACA7A7);
  final Color buttonColor = const Color(0xFF4C7273);
  final borderColor = Colors.white.withOpacity(0.3);

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: textColor),
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: buttonColor),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (!isLogin) {
      final market = marketController.text.trim();
      final rePassword = rePasswordController.text.trim();

      if (market.isEmpty ||
          phone.isEmpty ||
          password.isEmpty ||
          rePassword.isEmpty) {
        _showMessage("Please fill all fields");
        return;
      }

      if (password != rePassword) {
        _showMessage("Passwords do not match");
        return;
      }

      setState(() => isLoading = true);

      final response = await http.post(
        Uri.parse('https://sstore-1.onrender.com/api/signup/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'market_name': market,
          'phone_number': phone,
          'password': password,
        }),
      );

      setState(() => isLoading = false);

      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChoosePlanScreen()),
        );
      } else {
        _showMessage(result['error'] ?? 'Registration failed');
      }
    } else {
      if (phone.isEmpty || password.isEmpty) {
        _showMessage("Please fill all fields");
        return;
      }

      setState(() => isLoading = true);

      final response = await http.post(
        Uri.parse('https://sstore-1.onrender.com/api/login/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone_number': phone, 'password': password}),
      );

      setState(() => isLoading = false);

      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChoosePlanScreen()),
        );
      } else {
        _showMessage(result['error'] ?? 'Login failed');
      }
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.05,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: screenHeight * 0.08,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.22,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => isLogin = true),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            color: isLogin ? Colors.white : textColor,
                            fontWeight:
                                isLogin ? FontWeight.w900 : FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      Container(height: 20, width: 1, color: Colors.grey),
                      SizedBox(width: screenWidth * 0.05),
                      GestureDetector(
                        onTap: () => setState(() => isLogin = false),
                        child: Text(
                          "REGISTER",
                          style: TextStyle(
                            color: !isLogin ? Colors.white : textColor,
                            fontWeight:
                                !isLogin ? FontWeight.w900 : FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.30,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!isLogin) ...[
                        _buildTextField("Market Name", marketController),
                        _buildTextField("Phone Number", phoneController),
                        _buildTextField(
                          "Password",
                          passwordController,
                          obscure: true,
                        ),
                        _buildTextField(
                          "Re-enter password",
                          rePasswordController,
                          obscure: true,
                        ),
                      ] else ...[
                        _buildTextField("Phone number", phoneController),
                        _buildTextField(
                          "Password",
                          passwordController,
                          obscure: true,
                        ),
                      ],
                      SizedBox(height: screenHeight * 0.03),
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.1,
                                vertical: screenHeight * 0.02,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              isLogin ? 'LOGIN' : 'REGISTER',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      SizedBox(height: screenHeight * 0.2),
                    ],
                  ),
                ),
              ),
            ),
            if (isLogin)
              Positioned(
                bottom: screenHeight * 0.08,
                left: 0,
                right: 0,
                child: const Center(
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
