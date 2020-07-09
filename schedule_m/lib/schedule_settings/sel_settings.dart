
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_m/shared_settings/shared_io.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:search_choices/search_choices.dart';
import 'package:schedule_m/shcedule/schedule_view.dart';

import 'package:schedule_m/auth_or_register/firebaseController.dart';

import 'package:connectivity/connectivity.dart';



class SettingsPush extends StatefulWidget{

  @override
  _SettingsPagePush createState() => _SettingsPagePush();
}

class _SettingsPagePush extends State<SettingsPush>{

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget viewSettingsWidget = SizedBox();


  String selectedCity;
  String selectedInstitution;
  String selectedGroup;
  String switchGroupOrEmployee = 'Группа';


  bool cityIsSelected = true;
  bool institutionIsSelected = true;
  bool groupIsSelected = true;

  bool pushGetOrNo = false;
  String pushGetOrNoName = 'Игнорировать уведомления';

  String name = '';
  String surname = '';
  String patronymic = '';

  String _login = '';
  String _password = '';

  String authRole = '';


  _SettingsPagePush(){
//    haveSettings();
    getUserInfo();

  }


  String selectedValueUpdateFromOutsideThePlugin;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    refreshScreen = true;
//    if(refreshScreen){
//      print('Билд настроек');
//
//      refreshScreen = false;
//
//    }


    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Личный кабинет'),
          automaticallyImplyLeading: true,
          actions: <Widget>[




            IconButton(
              icon: Icon(Icons.exit_to_app,color: Colors.white),
              onPressed: (){
                refreshScreen = true;

                ShPref shPref = ShPref();
                shPref.getOrCreate().then((value){
                  shPref.autoAuth = false;
                  shPref.password = '';
                  shPref.employeeId = '';

                  shPref.authRole = '';

                  shPref.pushInstitution = '';
                  shPref.pushCity = '';
                  shPref.pushGroupOrEmployee = '';
//
                  shPref.upDate().then((value){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/auth');
                  });
                });
              },
            )
          ],
        ),
        body: RefreshIndicator(

          onRefresh: _handelRefresh,

          child: ListView(
            children: <Widget>[



              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.verified_user,color: Colors.deepPurple,),
                          Text(surname,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 25
                            ),
                          ),
                          Text(name,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 25
                            ),
                          ),
                          Text(patronymic,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 25
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),



                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(Icons.info,
                                color: Colors.deepPurple,
                                size: 17,
                              ),

                              Text(authRole,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 12
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 2,
                      child: Container(
                        color: Colors.deepPurple,
                      ),
                    ),

                    Row(
                      children: <Widget>[
                        Switch(
                          value: pushGetOrNo,
                          onChanged: (value) {
                            setState(() {
                              pushGetOrNo = value;
                              pushGetOrNoName =
                              (value == true) ? 'Получать уведомления' : 'Игнорировать уведомления' ;

                            });


                              ShPref sh = new ShPref();
                              sh.getOrCreate().then((value){
                                getData('NotificationON',
                                    {
                                      'token' : sh.token,
                                      'value' : pushGetOrNo.toString(),
                                    })
                                    .then((x){
                                      if(x == null)
                                        showErrorSnackBar(
                                            'Отсутствует интернет соединение');
                                      }).catchError((value){
                                  showErrorSnackBar('Отсутствует интернет соединение');
                                      });

                              });


                          },
                          activeTrackColor: Colors.deepPurple,
                          activeColor: Colors.deepPurpleAccent,
                        ),
                        Wrap(
                          children: <Widget>[
                            GestureDetector(
                              child: Text(pushGetOrNoName),
                              onTap: (){
                                pushGetOrNo = !pushGetOrNo;
                                pushGetOrNoName =
                                (pushGetOrNo == true) ?
                                  'Получать уведомления'
                                    : 'Игнорировать уведомления' ;
                                setState(() {

                                });
                              },
                            )
                          ],
                        )
                      ],
                    ),
                    //////

                    viewSettingsWidget,

                    authRole == '1' || authRole == 'Ученик' ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: 25,
                        ),

                        SearchChoices.single(
                          items: listCity,
                          value: selectedCity,
                          hint: Text('Город',style: TextStyle(color: Colors.black,fontSize: 20),),
                          searchHint: null,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.black,
                          onChanged: (value) {
                            setState(() {
//                      print(value);
                              if(value != null){
                                selectedCity = value;
                                cityIsSelected = false;

                                getData('settingsInstitution',{'city': selectedCity,})
                                    .then(onReceiveDataInstitution)
                                    .catchError((value){
                                  showErrorSnackBar('Отсутствует интернет соединение');
                                });
                              }
                            });
                          },
                          onClear: () {
                            setState(() {
                              selectedCity = null;

                              selectedInstitution = null;
                              cityIsSelected = true;

                              selectedGroup = null;
                              institutionIsSelected = true;
                            });
                          },
                          closeButton: "Закрыть",
                          isExpanded: true,
                          readOnly: false,
                        ),


                        SearchChoices.single(
                          items: listInstitution,
                          value: selectedInstitution,
                          hint: Text('Заведения',style: TextStyle(color: Colors.black,fontSize: 20),),
                          searchHint: null,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.black,
                          onChanged: (value) {
                            setState(() {
                              if (value != null){
                                selectedInstitution = value;
                                institutionIsSelected = false;
                                getData('settingsGroupOrEmployee',
                                    {
                                      'City': selectedCity,
                                      'institution' : selectedInstitution,
                                      'employee' : false.toString()
                                    })
                                    .then(onReceiveDataGroupOrEmployee)
                                    .catchError((value){
                                  showErrorSnackBar('Отсутствует интернет соединение');
                                });
                              }
                            });
                          },
                          onClear: () {
                            setState(() {
                              selectedInstitution = null;
                              institutionIsSelected = true;

                              selectedGroup = null;
                              institutionIsSelected = true;

                            });
                          },
                          closeButton: "Закрыть",
                          isExpanded: true,
                          readOnly: cityIsSelected,
                        ),


                        SearchChoices.single(
                          items: listGroupOrEmployee,
                          value: selectedGroup,
                          hint: Text(
                            'Каласс/Группа',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20),
                          ),
                          searchHint: null,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.black,
                          onChanged: (value) {
                            setState(() {
                              selectedGroup = value;
                            });
                          },
                          onClear: () {
                            setState(() {
                              selectedGroup = null;
                            });
                          },
                          closeButton: "Закрыть",
                          isExpanded: true,
                          readOnly: institutionIsSelected,
                        ),


                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: SizedBox(
                            width: 300,
                            child: RaisedButton(
                              color: Colors.deepPurple,
                              child: Text('Применить',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0)
                              ),
                              onPressed: (){
                                if(
                                selectedCity != null &&
                                    selectedInstitution != null &&
                                    selectedGroup != null
                                )
                                {
                                  ShPref sh = new ShPref();
                                  sh.getOrCreate()
                                      .then((x){


                                    getData('NotificationSet',
                                        {
                                          'token' : sh.token,
                                          'institution' : selectedInstitution,
                                          'group': selectedGroup,
                                          'city': selectedCity
                                        }
                                    ).then((resp){
                                        if (resp == null) showErrorSnackBar(
                                            'Отсутствует интернет соединение');
                                        else if (resp.statusCode == 200) {
                                          _scaffoldKey.currentState
                                              .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Успешно'
                                                ),
                                                backgroundColor: Colors.green,
                                              )
                                          );
                                          getUserInfo();
                                        }
                                    }).catchError((value){
                                      showErrorSnackBar('Отсутствует интернет соединение');
                                    });

                                    sh.upDate()
                                        .then((x){
                                      setState(() {

                                      });
                                    });
                                  });
                                }
                                else _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Вы не указали все данные',
                                        style: TextStyle(fontSize: 25,color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    )
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                    : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  List<DropdownMenuItem> items(){
    List<DropdownMenuItem<String>> ls = List<DropdownMenuItem<String>>();
    ls.add(DropdownMenuItem(
      child: Text(''),
      value: '',
    ));
    for (int i=1; i<10; i++){
      ls.add(DropdownMenuItem(
        child: Text('wordPair' + i.toString()),
        value: 'wordpair'+ i.toString(),
      ));
    }
    return ls;
  }


  //получение данных  с помощью http клиента по адресу, где развернуто приложение Laravel
  Future<http.Response>  getData(String chunkPath, dynamic bodyf){
    return Future<http.Response>(() async {

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile
          || connectivityResult == ConnectivityResult.wifi) {

        var client = http.Client();
        var resp = (await client.post('http://ruslan.wwspace.ru/api/' + chunkPath,
            body: bodyf
        ));
//      var body = resp.body;

        client.close();
        return  resp;
      }

      return null;

    });
  }

  List<DropdownMenuItem> listCity = List<DropdownMenuItem>();
// парсинг городов
  void onReceiveDataCity (http.Response data) {
    listCity.clear();


//    print(dataMap);
    if (data == null) showErrorSnackBar('Отсутствует интернет соединение');
    else if (data.statusCode == 200){

      List<dynamic> dataMap = jsonDecode(data.body);

      for (int i = 0; i < dataMap.length; i++){
        listCity.add(DropdownMenuItem(
          child: Text(dataMap[i]),
          value: dataMap[i],
        ));
      }
    }
    setState((){});
  }

  List<DropdownMenuItem> listInstitution = List<DropdownMenuItem>();
// парсинг заведений
  void onReceiveDataInstitution (http.Response data) {
    listInstitution.clear();



    if (data == null) showErrorSnackBar('Отсутствует интернет соединение');
    else if (data.statusCode == 200){

      List<dynamic> dataMap = jsonDecode(data.body);

      for (int i = 0; i < dataMap.length; i++){
        listInstitution.add(DropdownMenuItem(
          child: Text(dataMap[i]),
          value: dataMap[i],
        ));
      }
    }
    setState((){});
  }

  List<DropdownMenuItem> listGroupOrEmployee = List<DropdownMenuItem>();
// парсинг групп или преподвавтелей
  void onReceiveDataGroupOrEmployee (http.Response data) {
    listGroupOrEmployee.clear();


    if (data == null) showErrorSnackBar('Отсутствует интернет соединение');
    else if (data.statusCode == 200){

      List<dynamic> dataMap = jsonDecode(data.body);

      for (int i = 0; i < dataMap.length; i++){
        listGroupOrEmployee.add(DropdownMenuItem(
          child: Text(dataMap[i]),
          value: dataMap[i],
        ));
      }
    }
    else if (data.statusCode == 400){

    }

    setState((){});
  }


  void haveSettings(){

    ShPref sh = new ShPref();
    sh.getOrCreate().then((x){

      name = sh.name;
      surname = sh.surName;
      patronymic = sh.patronymic;
      authRole = sh.authRole;


      if(sh.pushCity.isNotEmpty &&
          sh.pushInstitution.isNotEmpty
//          && sh.pushGroupOrEmployee.isNotEmpty
          )
      {
        viewSettingsWidget = Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Wrap(children: <Widget>[
                  Icon(Icons.location_city, color: Colors.deepPurple,),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                        sh.pushCity,
                        softWrap: true, textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 25,color: Colors.black)
                    ),
                  )
                ]),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Wrap(children: <Widget>[
                  Icon(Icons.school, color: Colors.deepPurple),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                        sh.pushInstitution,
                        softWrap: true, textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 25,color: Colors.black)
                    ),
                  )
                ]),
              ),
            ),
            sh.pushGroupOrEmployee.isEmpty ? SizedBox() : Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Wrap(
                  children: <Widget>[
                    Icon(Icons.group, color: Colors.deepPurple),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                          sh.pushGroupOrEmployee,
                          softWrap: true, textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 25,color: Colors.black)
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      }
      else{
        viewSettingsWidget = Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  Text('Укажите Настроки уведомлений ниже'),
                ],
              ),
            ),
          ],
        );
      }
      setState((){});
    });

  }

//  получение данных  с помощью http клиента по адресу, где развернуто приложение Laravel
  Future<http.Response> getDataUser(String token) {
    return Future<http.Response>(() async {

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile
          || connectivityResult == ConnectivityResult.wifi) {
        var client = http.Client();
        var resp = (await client.post('http://ruslan.wwspace.ru/api/getUserData',
            body: {'token': token}));
        client.close();

        return resp;

      }

      return null;


    });
  }
//   парсинг полученных данных
  void onReceiveDataUser(http.Response data) {


    if (data == null) {
      showErrorSnackBar('Отсутствует интернет соединение');
      Navigator.pop(context);
    }
    else if (data.statusCode == 200) {

      List<dynamic> dataMap = jsonDecode(data.body);

      ShPref shPref = ShPref();

      shPref.getOrCreate().then((value){

        shPref.name = dataMap[0]["name"];
        shPref.surName = dataMap[0]["surname"];
        shPref.patronymic = dataMap[0]["patronymic"];
        shPref.authRole = dataMap[0]["role"];

        shPref.pushCity = dataMap[0]["city"];
        shPref.pushInstitution = dataMap[0]["institution"];
        shPref.pushGroupOrEmployee = dataMap[0]["group"];

        pushGetOrNo = dataMap[0]["notify"];

        pushGetOrNoName =
        (pushGetOrNo == true) ?
        'Получать уведомления'
            : 'Игнорировать уведомления' ;

        FireBaseController.getInstance().sendTokenToServer(shPref.token);

        shPref.upDate().then((value){
          haveSettings();
        });

      });
    }
    else if (data.statusCode == 235)
    {
      List<dynamic> dataMap = jsonDecode(data.body);

      ShPref shPref = ShPref();
      shPref.getOrCreate().then((value){

        shPref.employeeId =  shPref.autoAuth ? dataMap[0]['employee_id']: '';

        shPref.name = dataMap[0]["name"];
        shPref.surName = dataMap[0]["surname"];
        shPref.patronymic = dataMap[0]["patronymic"];
        shPref.authRole = dataMap[0]["role"];

        pushGetOrNo = dataMap[0]["notify"];

        pushGetOrNoName =
        (pushGetOrNo == true) ?
        'Получать уведомления'
            : 'Игнорировать уведомления' ;


        shPref.pushCity = dataMap[0]["city"];
        shPref.pushInstitution = dataMap[0]["institution"];
        shPref.pushGroupOrEmployee = '';

        FireBaseController.getInstance().sendTokenToServer(shPref.token);

        shPref.upDate().then((value){
          pushGetOrNoName =
          (pushGetOrNo) ? 'Получать уведомления' : 'Игнорировать уведомления' ;
            haveSettings();

        });

      });
    }
    else if (data.statusCode == 401)
      Navigator.pop(context);
      refreshScreen = true;

    setState(() {});
  }

  void getUserInfo(){
    ShPref sh = new ShPref();
    sh.getOrCreate().then((value){
      getDataUser(sh.token).then(onReceiveDataUser).catchError((value){
        Navigator.pop(context);
        refreshScreen = true;
      });
      getData('settingsCity',{'settingsType': 'city',}).then(onReceiveDataCity)
          .catchError((value){
        showErrorSnackBar('Отсутствует интернет соединение');
      });
    });

  }



  Future<Null> _handelRefresh() async {
    Completer<Null> completer = new Completer<Null>();

    await new Future.delayed(new Duration(seconds: 1)).then((_) {

      getUserInfo();
      completer.complete();

    });
    return completer.future;
  }

  void showErrorSnackBar(String text){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            text,
            style: TextStyle(
                fontSize: 20,
                color: Colors.white
            ),
          ),
          backgroundColor: Colors.red,
        )
    );
  }

}