import 'package:shared_preferences/shared_preferences.dart';



class ShPref {

  String email = '';
  String password = '';
  String token = '';
  bool   autoAuth = false;

  String employeeId = '';
  String authRole = '';


  String city = '';
  String institution = '';
  String groupOrEmployee = '';
  bool   isEmploee = false;

  String pushCity = '';
  String pushInstitution = '';
  String pushGroupOrEmployee = '';

  String name = '';
  String surName = '';
  String patronymic = '';

  ShPref(){

  }

  //получить или создать
  Future<bool> getOrCreate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool checkEmail = prefs.containsKey('email');
    bool checkPassword = prefs.containsKey('password');
    bool checkToken = prefs.containsKey('token');
    bool checkAutoAuth = prefs.containsKey('autoAuth');

    bool checkEmployeeId = prefs.containsKey('employeeId');
    bool checkAuthRole = prefs.containsKey('authRole');

    bool isStudent = prefs.containsKey('isEmploee');

    bool checkCity = prefs.containsKey('city');
    bool checkInstitution = prefs.containsKey('institution');
    bool checkGroupOrEmployee = prefs.containsKey('groupOrEmployee');

    bool checkPushCity = prefs.containsKey('pushCity');
    bool checkPushInstitution = prefs.containsKey('pushInstitution');
    bool checkPushGroupOrEmployee = prefs.containsKey('pushGroupOrEmployee');

    bool checkname = prefs.containsKey('name');
    bool checksurName = prefs.containsKey('surName');
    bool patronymic = prefs.containsKey('patronymic');

    if (checkEmail && checkPassword && checkToken && checkAutoAuth
        && checkAuthRole && checkCity && checkInstitution && checkEmployeeId
        && checkGroupOrEmployee && checkPushCity && checkPushInstitution
        && checkPushGroupOrEmployee && checkname && checksurName
        && patronymic && isStudent){

      this.email = prefs.getString('email');
      this.password = prefs.getString('password');
      this.token = prefs.getString('token');
      this.autoAuth = prefs.getBool('autoAuth');

      this.employeeId = prefs.getString('employeeId');
      this.authRole = prefs.getString('authRole');

      this.isEmploee = prefs.getBool('isEmploee');

      this.city = prefs.getString('city');
      this.institution = prefs.getString('institution');
      this.groupOrEmployee = prefs.getString('groupOrEmployee');

      this.pushCity = prefs.getString('pushCity');
      this.pushInstitution = prefs.getString('pushInstitution');
      this.pushGroupOrEmployee = prefs.getString('pushGroupOrEmployee');

      this.name = prefs.getString('name');
      this.surName = prefs.getString('surName');
      this.patronymic = prefs.getString('patronymic');

      return true;
    }

    prefs.setString('email', "");
    prefs.setString('password', "");
    prefs.setString('token', "");
    prefs.setBool('autoAuth', false);

    prefs.setString('employeeId', "");
    prefs.setString('authRole', "Ученик");

    prefs.setBool('isEmploee', false);

    prefs.setString('city', "");
    prefs.setString('institution', "");
    prefs.setString('groupOrEmployee', "");

    prefs.setString('pushCity', "");
    prefs.setString('pushInstitution', "");
    prefs.setString('pushGroupOrEmployee', "");

    prefs.setString('name', "");
    prefs.setString('surName', "");
    prefs.setString('patronymic', "");

    return false;
  }

  Future<bool> upDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {

      prefs.setString('email', this.email);
      prefs.setString('password', this.password);
      prefs.setString('token', this.token);
      prefs.setBool('autoAuth', this.autoAuth);

      prefs.setString('employeeId', this.employeeId);
      prefs.setString('authRole', this.authRole);

      prefs.setBool('isEmploee', this.isEmploee);

      prefs.setString('city', this.city);
      prefs.setString('institution', this.institution);
      prefs.setString('groupOrEmployee', this.groupOrEmployee);

      prefs.setString('pushCity', this.pushCity);
      prefs.setString('pushInstitution', this.pushInstitution);
      prefs.setString('pushGroupOrEmployee', this.pushGroupOrEmployee);

      prefs.setString('name', this.name);
      prefs.setString('surName', this.surName);
      prefs.setString('patronymic', this.patronymic);

      return true;

    } on Exception catch (_) {

      return false;
    }
  }

  Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('email', "");
      prefs.setString('password', "");
      prefs.setString('token', "");
      prefs.setBool('autoAuth', false);

      prefs.setString('employeeId', "");
      prefs.setString('authRole', "");

      prefs.setBool('isEmploee', false);

      prefs.setString('city', "");
      prefs.setString('institution', "");
      prefs.setString('groupOrEmployee', "");

      prefs.setString('pushCity', "");
      prefs.setString('pushInstitution', "");
      prefs.setString('pushGroupOrEmployee', "");

      prefs.setString('name', "");
      prefs.setString('surName', "");
      prefs.setString('patronymic', "");

      return true;
  }



}