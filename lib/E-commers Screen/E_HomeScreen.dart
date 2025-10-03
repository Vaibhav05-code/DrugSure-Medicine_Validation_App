import 'package:drugsuremva/E-commers%20Screen/navScreens/cartScreen.dart';
import 'package:drugsuremva/E-commers%20Screen/navScreens/defaultScreen.dart';
import 'package:drugsuremva/E-commers%20Screen/navScreens/orderScreen.dart';
import 'package:drugsuremva/E-commers%20Screen/navScreens/profile_screen.dart';
import 'package:drugsuremva/E-commers%20Screen/providers/user_provider_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EHomescreen extends StatefulWidget {
  const EHomescreen({super.key});

  @override
  State<EHomescreen> createState() => _EHomescreenState();
}

class _EHomescreenState extends State<EHomescreen> {

  int chosenIndex = 0 ;

  List navPages = [
    Defaultscreen(),
    Orderscreen(),
    Cartscreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navPages[chosenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: chosenIndex,
        onTap: (index){
          setState(() {
            chosenIndex = index;
          });
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_max_outlined),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined),label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined),label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.manage_accounts_outlined),label: "Profile"),
        ],

      ),

    );
  }
}
