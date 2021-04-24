import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:riderapp/main.dart';
import 'package:riderapp/screens/RegistrationScreen.dart';
import 'package:riderapp/utils/MainAppToast.dart';

import 'MainScreen.dart';

class LoginScreen extends StatelessWidget {
  static const idScreen = 'login';
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 35.0,
              ),
              Image(
                image: AssetImage("assets/images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "Login as a Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand-Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 14.0),
                        hintStyle:
                            TextStyle(fontSize: 10.0, color: Colors.grey),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: passwordEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 14.0),
                        hintStyle:
                            TextStyle(fontSize: 10.0, color: Colors.grey),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.yellow),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0))),
                      ),
                      onPressed: () {
                        if (!emailEditingController.text.contains("@")) {
                          displayToastMessage(
                              context, "Email address is not valid.");
                        } else if (passwordEditingController.text.isEmpty) {
                          displayToastMessage(context, "Password is required.");
                        } else {
                          loginUser(context);
                        }
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 35,
                          child: Center(
                              child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: 'Brand-Bold'),
                          ))),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegistrationScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Do not have an Account? Register Here.",
                  style:
                      TextStyle(fontFamily: 'Brand-Bold', color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginUser(BuildContext context) async {
    try {
      final User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: emailEditingController.text,
              password: passwordEditingController.text))
          .user!;
      //check if we have user's data in our database
      userRef
          .child(user.uid)
          .once()
          .then((DataSnapshot dataSnapshot) {
                if (dataSnapshot.value != null) {
                  displayToastMessage(
                      context, "You have been logged in successfully");
                  Navigator.pushNamedAndRemoveUntil(
                      context, MainScreen.idScreen, (route) => false);
                } else {
                  firebaseAuth.signOut();
                  displayToastMessage(context,
                      "No record exist for this user, please create new account");
                }
              });
    } catch (e) {
      displayToastMessage(context, "Error: " + e.toString());
    }
  }
}
