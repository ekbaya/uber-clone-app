 import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void displayToastMessage(BuildContext context,String message){
     Fluttertoast.showToast(msg: message);
  }