import 'package:flutter/material.dart';
import 'package:riderapp/screens/LoginScreen.dart';
import 'package:riderapp/screens/MainScreen.dart';
import 'package:riderapp/screens/RegistrationScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taxi Rider App',
      theme: ThemeData(
        fontFamily: 'Brand-Bold',
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginScreen.idScreen,
      routes: {
        RegistrationScreen.idScreen: (context)=> RegistrationScreen(),
        LoginScreen.idScreen: (context)=> LoginScreen(),
        MainScreen.idScreen: (context)=> MainScreen(),
      },
    );
  }
}