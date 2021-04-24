import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riderapp/main.dart';
import 'package:riderapp/screens/LoginScreen.dart';
import 'package:riderapp/screens/MainScreen.dart';
import 'package:riderapp/utils/MainAppToast.dart';
import 'package:riderapp/widgets/ProgressDialog.dart';

class RegistrationScreen extends StatelessWidget {
  static const idScreen = 'register';
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
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
                height: 20.0,
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
                "Register as a Rider",
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
                      controller: nameEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Name',
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
                      controller: phoneEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone',
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
                        if (nameEditingController.text.length < 4) {
                          displayToastMessage(
                              context, "Name must be atleast 4 characters.");
                        } else if (!emailEditingController.text.contains("@")) {
                          displayToastMessage(
                              context, "Email address is not valid.");
                        } else if (phoneEditingController.text.isEmpty) {
                          displayToastMessage(
                              context, "Phone number is required.");
                        } else if (passwordEditingController.text.length < 6) {
                          displayToastMessage(context,
                              "Password must be at least 6 characters.");
                        } else {
                          registerNewUser(context);
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 35,
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: 'Brand-Bold'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Already have an Account? Login Here.",
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

  void registerNewUser(BuildContext context) async {
    showDialog(context: context, 
    barrierDismissible:  false,
    builder: (BuildContext context){
      return ProgressDialog(message: "Registering, please wait...");
    });


    try {
      final User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: emailEditingController.text,
              password: passwordEditingController.text))
          .user!;
      //saving user data to Firebase Database

      Map userDataMap = {
        "name": nameEditingController.text.trim(),
        "email": emailEditingController.text.trim(),
        "phone": phoneEditingController.text.trim(),
      };

      userRef.child(user.uid).set(userDataMap);

      displayToastMessage(context,
          "Congratulations! your account has been created successfully");

      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    } catch (e) {
      Navigator.pop(context);
      displayToastMessage(context, "Error: " + e.toString());
    }
  }
}
