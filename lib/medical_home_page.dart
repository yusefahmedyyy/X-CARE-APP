 import 'package:xcare/main.dart';
import 'package:flutter/material.dart';
import 'package:xcare/welcome.dart';
import 'package:xcare/profile.dart';
import 'package:xcare/doctor.dart';


  // Color(0xFFF53D47),red
  //             Color(0xFF1AB1DD),blue
  //           Color(0xFF00507C), dark blue


class MedicalHomePage extends StatefulWidget {
  const MedicalHomePage({super.key, String? authToken});

  @override
  MedicalHomePageState createState() => MedicalHomePageState();
}

class MedicalHomePageState extends State<MedicalHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[ 
    
    MedicalWelcomePage(), 
     DoctorListPage(),
     ChatPage(),
   ProfileScreen(),
   
    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
         unselectedItemColor:       Color(0xFF1AB1DD), // Selected item color
          selectedItemColor: const  Color(0xFFF53D47), // Unselected item color
          selectedLabelStyle: const TextStyle(color: Color.fromARGB(255, 3, 142, 248)),
          unselectedLabelStyle:const TextStyle(color: Color.fromARGB(255, 249, 250, 252)), 
          showUnselectedLabels: true,
            
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem( backgroundColor: Color.fromARGB(255, 247, 241, 241), 
            icon: Icon(Icons.home,color: Color(0xFF1AB1DD)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy,color:  Color(0xFF1AB1DD)),
            label: 'Doctor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat,color:  Color(0xFF1AB1DD)),
            label: 'chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded,color:  Color(0xFF1AB1DD)),
            label: 'Profile',
          )
        ],
        currentIndex: _selectedIndex,

        onTap: _onItemTapped,
      ),
    );
  }
}

