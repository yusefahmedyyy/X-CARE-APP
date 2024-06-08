import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Appointment Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DoctorAppointmentPage(),
    );
  }
}

class DoctorAppointmentPage extends StatefulWidget {
  const DoctorAppointmentPage({super.key});      
  @override
  DoctorAppointmentPageState createState() => DoctorAppointmentPageState();
}

class DoctorAppointmentPageState extends State<DoctorAppointmentPage> {
  late List<Doctor> doctors;

  @override
  void initState() {
    super.initState();
    doctors = [
      Doctor(name: 'Dr. John Doe', rating: 4.5, price: 100),
      Doctor(name: 'Dr. Jane Smith', rating: 4.8, price: 120),
      Doctor(name: 'Dr. Michael Brown', rating: 4.3, price: 90),
      Doctor(name: 'Dr. Emily Davis', rating: 4.7, price: 110),
      Doctor(name: 'Dr. yousef ahmed', rating: 4.5, price: 100),
      Doctor(name: 'Dr. mariam medhat', rating: 4.8, price: 120),
      Doctor(name: 'Dr. ali magdy', rating: 4.3, price: 90),
      Doctor(name: 'Dr. Emily Davis', rating: 4.7, price: 110),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Appointment',
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
 backgroundColor: Color(0xFF1AB1DD),
      ),
      backgroundColor: Color.fromARGB(115, 109, 202, 249),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (BuildContext context, int index) {
          final doctor = doctors[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Card(
              elevation: 5, // Adjust elevation for the 3D effect
              child: ListTile(
                title: Text(doctor.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rating: ${doctor.rating.toStringAsFixed(1)}'),
                    Text('Price: \$${doctor.price.toStringAsFixed(2)}'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Implement appointment booking logic
                  },
                  child: const Text('Book'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Doctor {
  final String name;
  final double rating;
  final double price;

  Doctor({
    required this.name,
    required this.rating,
    required this.price,
  });
}
