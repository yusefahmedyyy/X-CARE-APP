// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:xcare/medical_home_page.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Register(),
  ),
);

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _selectedRole; // Role selector (Doctor or Patient)
  String? _authToken; 

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://ai-x-care.future-developers.cloud/accounts/register/'),  headers: {
      // 'Authorization': 'Bearer your_auth_token_here',  // Replace with your actual token
      'X-API-KEY': 'zkzk_sonbol_2020',  // Replace with your actual API key
    },
        body: {
          'username': _usernameController.text,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'group_name': _selectedRole ?? 'patient', // Default role
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        _authToken = responseBody['access']; // Save the token
        // You could also store the token in SharedPreferences for persistence
       String errorMessage = responseBody['message'] ?? 'success , here is token: $_authToken';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
            );
      } else {
        String errorMessage = responseBody['message'] ?? 'Registration failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
    // Handle specific types of errors
    if (e is http.ClientException) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to the server. Please check your internet connection.')),
      );
    } else if (e is FormatException || e is TypeError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to parse server response. Please try again later.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred. Please try again later.')),
      );
    }
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
            begin: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 5, 137, 245),
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
                    "Register",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  Text(
                    "Create your account",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
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
                            TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                hintText: " Username",
                                border: InputBorder.none,
                              ),
                            ),
                            const Divider(color: Colors.grey),
                            TextField(
                              controller: _firstNameController,
                              decoration: const InputDecoration(
                                hintText: " First Name",
                                border: InputBorder.none,
                              ),
                            ),
                            const Divider(color: Colors.grey),
                            TextField(
                              controller: _lastNameController,
                              decoration: const InputDecoration(
                                hintText: " Last Name",
                                border: InputBorder.none,
                              ),
                            ),
                            const Divider(color: Colors.grey),
                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                hintText: " Email",
                                border: InputBorder.none,
                              ),
                            ),
                            const Divider(color: Colors.grey),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,  // To hide the password
                              decoration: const InputDecoration(
                                hintText: " Password",
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Register as"),
                      DropdownButton<String>(
                        value: _selectedRole,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRole = newValue ?? 'patient';
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: "doctors",
                            child: Text("Doctor"),
                          ),
                          DropdownMenuItem(
                            value: "patient",
                            child: Text("Patient"),
                          ),
                        ],
                      ),
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
              Color.fromARGB(255, 251, 60, 19),
              Color.fromARGB(255, 248, 80, 51),   
              //   Color.fromARGB(255, 248, 100, 68),
              // Color.fromARGB(255, 6, 170, 250),
               Color.fromARGB(255, 6, 145, 246),
              Color.fromARGB(255, 6, 86, 243),
               Color.fromARGB(255, 6, 53, 185),
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
                              onPressed: _register,
                              child: const Text(
                                "Register",
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
