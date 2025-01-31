import 'package:flutter/material.dart';
import 'package:flutter_provider_utilities/flutter_provider_utilities.dart';
import 'package:hackathon_app/app_core/iservices/iuser_services.dart';
import 'package:hackathon_app/domain/db/user_db.dart';
import 'package:hackathon_app/domain/models/Entities/user.dart';

class UserProvider extends ChangeNotifier with MessageNotifierMixin {
  IUserServices _iUserServices;
  User? user;

  UserProvider({required IUserServices iUserServices})
      : _iUserServices = iUserServices;

  Future<void> create(User userU) async {
    try {
      int userValue = await _iUserServices.create(userU);
      if (userValue >= 0) {
        userU.userId = userValue;
        user = userU;
      }
    } catch (e) {
      notifyError(e);
      notifyListeners();
    }
  }

  Future<int> createUser(User userU) async {
    try {
      int userValue = await _iUserServices.create(userU);
      if (userValue >= 0) {
        userU.userId = userValue;
        user = userU;
        return userValue;
      }
      return 0;
    } catch (e) {
      notifyError(e);
      notifyListeners();
      return 0;
    }
  }

  Future<void> verifyUser(String userName, password) async {
    try {
      user = await _iUserServices.verifyUser(userName, password);
      var db = await UserDB.instance.database;
    } catch (e) {
      notifyError(e);
      notifyListeners();
    }
  }

  Future<String> changeState(bool state) async {
    return await _iUserServices.changeState(user!.userId!, state);
  }

  void changeError() {
    notifyListeners();
  }

  Future<List<User>> readUser() async {
    try {
      return await _iUserServices.read();
    } catch (e) {
      notifyError(e);
      return [];
    }
  }
}
