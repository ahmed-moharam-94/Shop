import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = 'SplashScreen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[500],
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0),
                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4.0, -4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0),
                ]),
            child: Icon(Icons.home, size: 50),
          ),
        ),
      ),
    );
  }
}
