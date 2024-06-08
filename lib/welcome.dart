import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xcare/news.dart';

void main() {
  runApp(const MedicalWelcomePage());
}

  // Color(0xFFF53D47),red
  //             Color(0xFF1AB1DD),blue
  //           Color(0xFF00507C), dark blue

class MedicalWelcomePage extends StatelessWidget {
  const MedicalWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          // title: Image.asset('assets/logo.png',width: 100,),
          title: const Text(
            'Welcome to XCare',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor:  Color(0xFF1AB1DD),
          elevation: 0,
        ),
        body: Stack(
          children: [
            // Background image
            // Image.asset(
            //      'assets/bg.jpg',
            //  fit: BoxFit.cover,
            //  width: double.infinity,
            //  height: double.infinity ),
            Opacity(opacity: 0.5,
            child: Positioned.fill(
              
              child: Image.asset(
                'assets/bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity ),
            
            ),),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // PhysicalModel(
                  //   color: Colors.blue,
                  //   elevation: 8,
                  //   borderRadius: BorderRadius.circular(100),
                  //   child: const CircleAvatar(
                  //     radius: 70,
                  //     backgroundColor: Colors.blue,
                  //     child: Icon(
                  //       Icons.local_hospital,
                  //       color: Colors.white,
                  //       size: 80,
                  //     ),
                  //   ),
                  // ),
          Transform.translate(offset: Offset(60,-85),
          child: Image.asset('assets/logo2.png',
                  width: 310,
                  ) ,),
SizedBox(height: 230,),

                  // const Text(
                  //   'XCare',
                  //   style: TextStyle(
                  //     fontSize: 36,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.blue,
                  //   ),
                  // ),
                  // SizedBox(height: 20,),
      
                  // const Text(
                  //   'Your Trusted Health Partner',
                  //   style: TextStyle(
                  //     fontSize: 25,
                  //       fontWeight: FontWeight.bold,
                  //     color: Colors.blue,
                  //   ),
                  // ),
                  // const SizedBox(height: 30),
                   Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 80),
                          decoration: BoxDecoration( 
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            colors: [
             Color(0xFFF53D47),
           
              Color(0xFF1AB1DD),
            Color(0xFF00507C),
            ],
          ),
        
                            borderRadius: BorderRadius.circular(17),
                           
                          ),
                          child: Center(
                            
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Make the button's background transparent
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(300),
                ),
              ),
                                          onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NewsApp()),
                      );
                    },
                              child: const Text(
                                "Get Started",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
