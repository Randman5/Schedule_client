import 'package:flutter/material.dart';
import 'auth_or_register/auth.dart';
import 'package:schedule_m/shcedule/schedule_view.dart';
import 'schedule_settings/select_settings.dart';
import 'schedule_settings/sel_settings.dart';
import 'auth_or_register/register.dart';
import 'package:schedule_m/LoadingForm/instruction.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurple,

        // Define the default font family.
        fontFamily: 'Comic Sans MS',

      ),
      debugShowCheckedModeBanner: false,

      initialRoute: '/',
      routes: {
        '/':(BuildContext context) => ScheduleView(),
        '/scheduleSettings':(BuildContext context) => Settings(),
        '/auth':(BuildContext context) => Auth(),
        '/settingsPush':(BuildContext context) => SettingsPush(),
        '/register':(BuildContext context) => Register(),
        '/Instruction' : (BuildContext context) => Instruction()
      },
    );
  }
}


