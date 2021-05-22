import 'package:firebase_auth/firebase_auth.dart';

import 'models/User.dart';

String mapKey = "AIzaSyAmt-Aj7nbTSgqez21e7ZjgM1HO0G-lWKU";

late User firebaseUser;

CurrentUser currentUser = new CurrentUser(id: "", email: "", phone: "", name: "");