import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schedule_m/shcedule/schedule_structures.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schedule_m/shared_settings/shared_io.dart';
import 'package:schedule_m/auth_or_register/firebaseController.dart';

import 'package:connectivity/connectivity.dart';

bool refreshScreen = false;

BuildContext app;


class ScheduleView extends StatefulWidget {


  @override
  _ScheduleView createState() => _ScheduleView();
}

class _ScheduleView extends State<ScheduleView> with WidgetsBindingObserver {

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  String scheduleTitel = '';
  List<Widget> tables = [];


  _ScheduleView() {
    updateSchedule();
    isAuth();
  }



  //////
  void authJump(){
    ShPref shPref = ShPref();
    shPref.getOrCreate().then((value){

      if(shPref.email.isNotEmpty
          && shPref.password.isNotEmpty
          && shPref.token.isNotEmpty
          && shPref.autoAuth
      )
      {
        Navigator.pushNamed(context,'/settingsPush');

      }
      else
        Navigator.pushNamed(context,'/auth');
    });
  }

  void isAuth(){
    ShPref shPref = ShPref();
    shPref.getOrCreate().then((value){

      if(shPref.email.isNotEmpty
          && shPref.password.isNotEmpty
          && shPref.token.isNotEmpty
          && shPref.autoAuth
      )
      {
        FireBaseController.getInstance().sendTokenToServer(shPref.token);
        print(shPref.token);
      }
    });
  }



  //////


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if(refreshScreen){
      updateSchedule();
      refreshScreen = false;
    }

    FireBaseController.getInstance().buildContext = context;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Расписание' + scheduleTitel),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help_outline, color: Colors.white,),
              onPressed: (){
                Navigator.pushNamed(context, '/Instruction');
              },
            )
          ],
        ),

        body:Container(
          color: Colors.white,

          child: RefreshIndicator(
              color: Colors.deepPurple,
              backgroundColor: Colors.white,
              onRefresh: _handelRefresh,

              child: ListView(
                children: <Widget>[
                  Column(children: tables),

                ],
              )
          ),
        ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple,
        currentIndex: 0,
        selectedItemColor: Colors.white,
        onTap:(int value){
          switch(value){
            case 0:
              {
                 Navigator.pushNamed(context, '/scheduleSettings');
              }break;
            case 1:
              {
                authJump();
              }break;
          }
          setState(() {

          });
        } ,
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.settings,color: Colors.white,size: 35,),
            title: SizedBox(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle,color: Colors.white,size: 35),
            title: SizedBox(),
          ),
        ],
      ),

    );
  }


  AppLifecycleState state;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed){
      updateSchedule();
    }
  }


  //получение данных  с помощью http клиента по адресу, где развернуто приложение Laravel
  Future<http.Response>
    getData(String city, String institution, String group, bool isEmploee) {

    return Future<http.Response>(() async {

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile 
          || connectivityResult == ConnectivityResult.wifi) {
        
        var client = http.Client();
        var resp = (await client.post('http://ruslan.wwspace.ru/api/flat',
            body: {
              'city': city,
              'institution': institution,
              'groupOrEmploee': group,
              'isEmploee': isEmploee.toString(),
            }
        ));
        client.close();

        return resp;
        
      }
      else return null;
      

      
    });
  }

// парсинг полученных данных
  void onReceiveData(http.Response data) {

    
    if(data == null) ethernetError();
    else if (data.statusCode == 200) {
      List<dynamic> dataMap = jsonDecode(data.body);
      tables.clear();


      ShPref sh = new ShPref();
      sh.getOrCreate()
          .then((x){

        for (var value in dataMap) {
          List<Widget> row = new List<Widget>();
          String dateDay = '';
          String day_name = '';
          for (var value1 in value) {
            HttpRow htt = new HttpRow(value1);

//            htt.myID = sh.employeeId;
            dateDay = htt.date;
            day_name = htt.day_name;

            row.add(htt.getScheduleRow());
          }
          tables.add(DayTable(dateDay, day_name, row));
        }

        sh.upDate().then((x){
          setState(() { });
        });
      });


    }
    else if (data.statusCode == 204) {
      tables.clear();
      tables.add(
        Center(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.terrain,
                size: 200,
                color: Colors.grey[400],
              ),
              Text('На ближайшие время расписание отсутствует',
                style: TextStyle( fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    }

    setState(() {});
  }


  void ethernetError() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        'Отсутствует соединение с интернетом',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ));

    if (tables.isEmpty){
      tables.add(
        Center(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.sync_disabled,
                size: 200,
                color: Colors.grey[400],
              ),
              Text('нет сети',
                style: TextStyle( fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    }
    setState(() {

    });
  }

  void error() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        'произошла ошибка',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ));

    if (tables.isEmpty){
      tables.add(
        Center(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.sync_disabled,
                size: 200,
                color: Colors.grey[400],
              ),
              Text('Отсутствует соединение с интернетом error',
                style: TextStyle( fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    }
  }

  void updateSchedule() {
    ShPref sh = new ShPref();
    sh.getOrCreate().then((x) {
      if (  sh.city.isNotEmpty
            && sh.institution.isNotEmpty
            && sh.groupOrEmployee.isNotEmpty
      )
      {
        getData(sh.city, sh.institution, sh.groupOrEmployee, sh.isEmploee)
            .then(onReceiveData)
            .catchError((value){
              ethernetError();
            });
        scheduleTitel = ' ' + sh.groupOrEmployee;
      }
      else {
        tables.clear();
        tables.add(
          Center(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.settings,
                  size: 200,
                  color: Colors.grey[400],
                ),
                Text('вы не указали настроки расписания',
                  style: TextStyle( fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        );
        scheduleTitel = '';
      }

      setState(() {});
    });
  }

  Future<Null> _handelRefresh() async {
    Completer<Null> completer = new Completer<Null>();

    await new Future.delayed(new Duration(seconds: 1)).then((_) {
      completer.complete();
      updateSchedule();
    });
    return completer.future;
  }
}



