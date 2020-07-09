import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_m/shared_settings/shared_io.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:search_choices/search_choices.dart';
import 'package:schedule_m/shcedule/schedule_view.dart';



class Settings extends StatefulWidget{

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<Settings>{

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget viewSettingsWidget = SizedBox();

  String selectedCity;
  String selectedInstitution;
  String selectedGroup;
  String switchGroupOrEmployee = 'Группа';

  bool isSwitchedEmployee = false;
  bool cityIsSelected = true;
  bool institutionIsSelected = true;
  bool groupIsSelected = true;


  _SettingsPage() {
    haveSettings();
    getData('settingsCity',{'settingsType': 'city',}).then(onReceiveDataCity);
  }


  String selectedValueUpdateFromOutsideThePlugin;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    print('Билд настроек');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Настройки расписания'),
        automaticallyImplyLeading: true,
      ),
      body: WillPopScope(
        onWillPop: () async{
          if (Navigator.canPop(context)) {
            refreshScreen = true;
            Navigator.pop(context);

            setState(() { });

            return false;
          }
          return true;
        },
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  viewSettingsWidget,

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
                              .then(onReceiveDataInstitution);
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

                  // выбор заведения
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
                                'city': selectedCity,
                                'institution' : selectedInstitution,
                                'employee' : isSwitchedEmployee.toString()
                              })
                              .then(onReceiveDataGroupOrEmployee);
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

                  // чекбокс на выбор ученик или преподаватель
                  Row(
                    children: <Widget>[
                      Switch(
                        value: isSwitchedEmployee,
                        onChanged: (value) {
                          setState(() {
                            selectedGroup = null;
                            isSwitchedEmployee = value;
                            switchGroupOrEmployee =
                            (value == true) ? 'Преподаватель' : 'Группа' ;

                          });

                            if (selectedInstitution != null
                                && selectedInstitution != ''
                            )
                            {
                              getData('settingsGroupOrEmployee',
                                  {
                                    'City' : selectedCity,
                                    'institution' : selectedInstitution,
                                    'employee' : isSwitchedEmployee.toString()
                                  })
                                  .then(onReceiveDataGroupOrEmployee);
                            }


                        },
                        activeTrackColor: Colors.deepPurple,
                        activeColor: Colors.deepPurpleAccent,
                      ),
                      Wrap(
                        children: <Widget>[
                          Text(switchGroupOrEmployee)
                        ],
                      )
                    ],
                  ),

                  // список выбора преподавателя или  учеников
                  SearchChoices.single(
                    items: listGroupOrEmployee,
                    value: selectedGroup,
                    hint: Text(
                      'Группа/преподаватель',
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

                  // кнопка применить
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: SizedBox(
                      width: 300,
                      height: 35,
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
                              sh.city = selectedCity;
                              sh.institution = selectedInstitution;
                              sh.groupOrEmployee = selectedGroup;
                              sh.isEmploee = isSwitchedEmployee;
                              sh.upDate()
                                  .then((x){
                                setState(() {
                                  haveSettings();
                                  refreshScreen = true;
                                  Navigator.pop(context);

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
      var client = http.Client();
      var resp = (await client.post('http://ruslan.wwspace.ru/api/' + chunkPath,
          body: bodyf
      ));
      var body = resp.body;

      client.close();
      return  resp;
    });
  }

  List<DropdownMenuItem> listCity = List<DropdownMenuItem>();
// парсинг городов
  void onReceiveDataCity (http.Response data) {
    listCity.clear();

    List<dynamic> dataMap = jsonDecode(data.body);
//    print(dataMap);
    if (data.statusCode == 200){

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

    List<dynamic> dataMap = jsonDecode(data.body);
//    print(dataMap);
    if (data.statusCode == 200){

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

    List<dynamic> dataMap = jsonDecode(data.body);
//    print(dataMap);
    if (data.statusCode == 200){
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
      if(sh.city.isNotEmpty &&
          sh.institution.isNotEmpty &&
          sh.groupOrEmployee.isNotEmpty)
      {
        viewSettingsWidget = Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Wrap(children: <Widget>[
                  Icon(Icons.location_city,color: Colors.deepPurple,),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                        sh.city,
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
                  Icon(Icons.school,color: Colors.deepPurple,),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                        sh.institution,
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
                child: Wrap(
                  children: <Widget>[
                    Icon(Icons.group,color: Colors.deepPurple,),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                          sh.groupOrEmployee,
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
                  Text('Укажите Настроки расписания ниже'),
                ],
              ),
            ),
          ],
        );
      }
      setState((){});
    });

  }

}