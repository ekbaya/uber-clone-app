// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:riderapp/screens/LoginScreen.dart';
import 'package:riderapp/screens/MainScreen.dart';
import 'package:riderapp/screens/RegistrationScreen.dart';
import 'package:provider/provider.dart';

import 'dataHandler/appData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("users");
DatabaseReference rideRequestRef =
    FirebaseDatabase.instance.reference().child("Ride Requests").push();
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Taxi Rider App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: firebaseAuth.currentUser == null ? LoginScreen.idScreen: MainScreen.idScreen,
        routes: {
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
        },
      ),
    );
  }
}
