import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProviderProfile extends ChangeNotifier {
  String userId = "";
  bool isLoggedIn = false;

  void isLogged() {
    isLoggedIn = true;
    notifyListeners();
  }

  checkUser() {
    String id = FirebaseAuth.instance.currentUser!.uid;
    return id;
  }
}
