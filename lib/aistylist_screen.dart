// 📌 AI Stylist 화면
import 'package:flutter/material.dart';

import 'appbar.dart';
import 'navigationbar.dart';

class AIStylistScreen extends StatefulWidget {
  const AIStylistScreen({super.key});

  @override
  AIStylistState createState() => AIStylistState();
}

class AIStylistState extends State<AIStylistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          ],
        ),
      ),
      bottomNavigationBar: buildNavigationBar(context, 2),
    );
  }
}
