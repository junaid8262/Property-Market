import 'package:flutter/material.dart';

class Trending extends StatefulWidget {

  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 180,
          child: Center(
            child: Image.asset('assets/images/comingSoon.png'),
          ),

        ),
      )
    );
  }
}
