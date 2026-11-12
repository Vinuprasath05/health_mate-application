import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {

  String userName = '';

  void updateUserName(String name) {

    userName = name;

    notifyListeners();
  }
}
