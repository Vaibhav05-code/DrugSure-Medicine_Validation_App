import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Orderscreen extends StatefulWidget {
  const Orderscreen({super.key});

  @override
  State<Orderscreen> createState() => _OrderscreenState();
}

class _OrderscreenState extends State<Orderscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Welcome SCreen"),
      ),
    );
  }
}
