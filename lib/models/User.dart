import 'package:firebase_database/firebase_database.dart';

class CurrentUser {
  String id, email, phone, name;

  CurrentUser(
      {required this.id,
      required this.email,
      required this.phone,
      required this.name});

  factory CurrentUser.fromSnapshot(DataSnapshot snapshot) =>
      userFromSnapshot(snapshot);
}

CurrentUser userFromSnapshot(DataSnapshot snapshot) {
  return CurrentUser(
      id: snapshot.key,
      email: snapshot.value["email"],
      phone: snapshot.value["phone"],
      name: snapshot.value["name"]);
}
