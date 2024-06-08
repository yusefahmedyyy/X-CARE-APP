// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xcare/medical_home_page.dart';
import 'package:xcare/login/register.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _secureStorage = FlutterSecureStorage();

  bool _isLoading = false;
 // Variable to hold the token


 Future<void> _login() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final response = await http.post(
      Uri.parse('https://ai-x-care.future-developers.cloud/accounts/login/'),
      headers: {
        'X-API-KEY': 'zkzk_sonbol_2020',
      },
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      final authToken = responseBody['access'];
      // Save the token securely
      await _secureStorage.write(key: 'auth_token', value: authToken);
      // Navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MedicalHomePage()),
      );
    } else {
      String errorMessage = responseBody['message'] ?? 'Wrong email or password, please try again';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  } catch (e) {
    // Error handling
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            colors: [
              Color.fromARGB(255, 20, 94, 243),
              Color.fromARGB(255, 64, 166, 250),
              Color.fromARGB(255, 112, 187, 249),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome back",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 60),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(27, 162, 225, 0.298),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromARGB(255, 238, 238, 238),
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  hintText: "Email or Phone number",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromARGB(255, 238, 238, 238),
                                  ),
                                ),
                              ),
                              child: TextField(
                                      controller: _passwordController,
                                      obscureText: true,  // To hide the password input
                                      decoration: const InputDecoration(
                                        hintText: "Password",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,  // This will remove any border
                                      ),
                                    ),

                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text("Forgot Password?", style: TextStyle(color: Colors.grey)),
                  
                   GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  const Register()),
            );
          },
          child: const Text(
            "Register Now",
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
              
            ),)),
                      
                      
                    


                      const SizedBox(height: 40),
                      if (_isLoading)
                        const CircularProgressIndicator(),
                      if (!_isLoading)
                        Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration( 
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            colors: [
             Color(0xFFF53D47),
           
              Color(0xFF1AB1DD),
            Color(0xFF00507C),
            ],
          ),
        
                            borderRadius: BorderRadius.circular(7),
                           
                          ),
                          child: Center(
                            
                            child: ElevatedButton(
                              style: ButtonStyle(
                                
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent,
                                ),
                                elevation: MaterialStateProperty.all<double>(0),
                              ),
                              onPressed: _login,
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 50),
                      const Text("Continue with ", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 30),
                      Row(
                        children: <Widget>[
                          const SizedBox(width: 99),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color.fromARGB(255, 203, 202, 202),
                              ),
                              child: Center(
                                child: Image.asset(
                                  "assets/pngwing.com.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color.fromARGB(255, 203, 202, 202),
                              ),
                              child: Center(
                                child: Image.asset(
                                  "assets/facebooklogo2.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 99),
                        ],
                      ),
                      const SizedBox(height: 0),
                    ],
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
