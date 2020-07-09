import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show MethodChannel;
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:schedule_m/shcedule/schedule_view.dart';
import 'package:connectivity/connectivity.dart';


class FireBaseController {

  final FirebaseMessaging messaging = FirebaseMessaging();

  FireBaseController(){

//    Future.delayed(Duration(seconds: 1), () {
//
//    }
//    );

    messaging.configure(onMessage: _onMessage,
                          onLaunch: _onLaunch,
                          onResume: _onResume,
//        onBackgroundMessage: myBackgroundMessageHandler
    );



    messaging.requestNotificationPermissions();
  }



  Future<dynamic> _onMessage(Map<String, dynamic> message) async {
    if (buildContext != null)
    {
//      print(message);
        Flushbar(title: message['notification']['title'],
          message: message['notification']['body'] ,)..show(buildContext);


//        print(message['notification']['title']);


        refreshScreen = true;
        (buildContext as Element).markNeedsBuild();



    }
  }

  Future<dynamic> _onLaunch(Map<String, dynamic> message) async {
    refreshScreen = true;
    (buildContext as Element).markNeedsBuild();
  }

  Future<dynamic> _onResume(Map<String, dynamic> message) async {
    refreshScreen = true;
    (buildContext as Element).markNeedsBuild();
  }

//   Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//    if (message.containsKey('data')) {
//      // Handle data message
//      final dynamic data = message['data'];
//    }
//
//    if (message.containsKey('notification')) {
//      // Handle notification message
//      final dynamic notification = message['notification'];
//    }
//
//
//
//    // Or do other work.
//  }





  Future<String> getToken(){
    return messaging.getToken();
  }

  Future<void> sendTokenToServer(String userToken){
    return Future<void>(() async {

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile
          || connectivityResult == ConnectivityResult.wifi) {


        String token = await getToken();
//      print(token);

        if(token.isNotEmpty){
          var client = http.Client();
          var resp = (await client.post('http://ruslan.wwspace.ru/api/fcmToken',
              body: {'fcmToken': token, 'userToken': userToken}));
          client.close();
        }

      }


    });
  }

  static FireBaseController instance = null;


  static FireBaseController getInstance(){
    if (instance == null){
      instance = FireBaseController();
    }
    return instance;
  }


  BuildContext buildContext ;


}