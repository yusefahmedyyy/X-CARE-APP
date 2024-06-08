import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xcare/login/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _secureStorage = FlutterSecureStorage();
  // ignore: unused_field
  String _authToken = '';
  String _name = '';
  String _email = '';
  int _age = 0;
  String _address = '';
  String _gender = '';
  String _photo = '';
  String _emergencyPhone = '';
  String _bloodType = '';
  String _phone = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final authToken = await _secureStorage.read(key: 'auth_token');
      final response = await http.get(
        Uri.parse('https://ai-x-care.future-developers.cloud/accounts/profile/'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'X-API-KEY': 'zkzk_sonbol_2020',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          _authToken = authToken ?? '';
          _name = userData['name'] ?? '';
          _email = userData['email'] ?? '';
          _age = userData['age'] ?? 0; // Ensure age is an integer
          _address = userData['address'] ?? '';
          _gender = userData['gender'] ?? '';
          _photo = 'https://ai-x-care.future-developers.cloud/${userData['photo']}';
          _emergencyPhone = userData['emgo_phone'] ?? '';
          _bloodType = userData['blood_type'] ?? '';
          _phone = userData['phone'] ?? '';
          _isLoading = false;
        });
      } else {
        _showErrorSnackBar('Error: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error: ${e}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),backgroundColor:  Color(0xFF1AB1DD),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildProfile(),
    );
  }

  Widget _buildProfile() {
    return Stack(
      children: [
        Positioned(
          top: 210, // Adjust the top value for the desired offset
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            color:  Color(0xFF1AB1DD), // Background color
          ),
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: _buildPhoto(_photo),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetail('Name', _name),
                        _buildDetail('Email', _email),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetail('Age', _age.toString()),
                        _buildDetail('Phone', _phone),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetail('Address', _address),
                        _buildDetail('Emergency Phone', _emergencyPhone),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetail('Gender', _gender),
                        _buildDetail('Blood Type', _bloodType),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _logout,
                  child: Text('Logout'),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoto(String imageUrl) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(imageUrl),
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'auth_token');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
