import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Defaultscreen extends StatefulWidget {
  const Defaultscreen({super.key});

  @override
  State<Defaultscreen> createState() => _DefaultscreenState();
}

class _DefaultscreenState extends State<Defaultscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Welcome SCreen"),
      ),
    );
  }
}
