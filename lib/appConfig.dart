import 'package:firebase_auth/firebase_auth.dart';

import 'models/User.dart';

String mapKey = "AIzaSyDuSoe0jf81d2kFUHBCED-wX0bR2QbHkQU";

late User firebaseUser;

CurrentUser currentUser = new CurrentUser(id: "", email: "", phone: "", name: "");