import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

  // Color(0xFFF53D47),red
  //             Color(0xFF1AB1DD),blue
  //           Color(0xFF00507C), dark blue

class Doctor {
  final String name;
  final String specialty;
  final String image;
  final String price;
  final String description;

  Doctor({
    required this.name,
    required this.specialty,
    required this.image,
    required this.price,
    required this.description,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    // Extracting profile and organization details
    final profile = json['profile'][0];
    final speciality = json['specialites'][0];
    final price = json['price'];

    return Doctor(
      name: profile['name'],
      specialty: speciality['name'],
      image: 'https://ai-x-care.future-developers.cloud${profile['photo']}',
      description: speciality['description'],
      price: price,
    );
  }
}

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({super.key});

  @override
  DoctorListPageState createState() => DoctorListPageState();
}

class DoctorListPageState extends State<DoctorListPage> {
  List<Doctor> doctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    final response = await http.get(Uri.parse('https://ai-x-care.future-developers.cloud/accounts/doctors/') ,headers: {
      // 'Authorization': 'Bearer your_auth_token_here',  // Replace with your actual token
      'X-API-KEY': 'zkzk_sonbol_2020',  // Replace with your actual API key
    },);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        doctors = data.map((json) => Doctor.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  Color _randomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctors',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
         
          ),
        ),   backgroundColor: Color(0xFF1AB1DD),

      ),    backgroundColor: const Color.fromARGB(167, 97, 197, 247),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Image.asset(
              'assets/strip.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            color: const Color.fromARGB(38, 0, 0, 0).withOpacity(0.4),
          ),
          Column(
            children: [
              Expanded( 

      child:ListView.builder(
        
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return DoctorCard(
            doctor: doctors[index],
            color: _randomColor(),
          );
        },
      ), 
            ),
            ],
            ),
            ],
            ),
              );
  }
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final Color color;
  @override
  // ignore: overridden_fields
  final Key? key;

  const DoctorCard({
    required this.doctor,
    required this.color,
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(doctor.image),
        ),
        title: Text(
          doctor.name,
          style: const TextStyle(
          color: Colors.white,
          fontStyle: FontStyle.normal,
             fontWeight: FontWeight.bold,
          fontSize: 25,
          // backgroundColor: Color.fromARGB(115, 177, 177, 177)
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor.specialty,
              style: const TextStyle(color: Colors.white,   fontWeight: FontWeight.bold),
            ),
            Text(
              "Price: ${doctor.price}",
              
              style: const TextStyle(color: Colors.white,   fontWeight: FontWeight.w600),
            ),
            Text(
              doctor.description,
              style: const TextStyle(color: Colors.white),
            ),
            // You can add more details here if needed
          ],
        ),
        onTap: () {
          // Navigate to doctor's detail page
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: DoctorListPage(),
  ));
}
