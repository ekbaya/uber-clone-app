import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riderapp/screens/LoginScreen.dart';

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
                        hintStyle: TextStyle(fontSize: 10.0, color: Colors.grey),
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
                        hintStyle: TextStyle(fontSize: 10.0, color: Colors.grey),
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
                        hintStyle: TextStyle(fontSize: 10.0, color: Colors.grey),
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
                        hintStyle: TextStyle(fontSize: 10.0, color: Colors.grey),
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
                        registerNewUser(context);
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 35,
                          child: Center(
                              child: Text(
                            "Create Account",
                            style:
                                TextStyle(fontSize: 18.0, fontFamily: 'Brand-Bold'),
                          ))),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Already have an Account? Login Here.",
                  style: TextStyle(fontFamily: 'Brand-Bold', color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  void registerNewUser(BuildContext context) async{
     try {
       final User user = (await firebaseAuth
     .createUserWithEmailAndPassword(email: emailEditingController.text, 
     password: passwordEditingController.text)).user!;
     } catch (e) {
     }

  }
}
