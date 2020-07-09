import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';





class Register extends StatefulWidget{


  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<Register>{

  _RegisterPage(){
    setRegisterWidgets();
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget studentOrEmployeeCreate;
  Widget registrButton;

  String _surname = '';
  String _name = '';
  String _patronymic = '';

  String _login = '';
  String _password1 = '';
  String _password2 = '';
  bool _autoAuth = false;
  String _employeeKey = '';

  bool isSwitchedEmployee = false;
  String switchGroupOrEmployee = 'Ученик';

  TextEditingController surnameController  = TextEditingController();
  TextEditingController nameController  = TextEditingController();
  TextEditingController patronymicController  = TextEditingController();

  TextEditingController emailController  = TextEditingController();
  TextEditingController passwordController1  = TextEditingController();
  TextEditingController passwordController2  = TextEditingController();
  TextEditingController employeeKeyController  = TextEditingController();

  Future<http.Response>
  getData(String path, dynamic bodyF ) {

    return Future<http.Response>(() async {
      var client = http.Client();
      var resp = (await client.post('http://ruslan.wwspace.ru/api'+path,
          body: bodyF
      ));

      client.close();

      return resp;
    });
  }

// парсинг полученных данных
  void onReceiveData(http.Response data) {

//    print(data.statusCode.toString());

    if (data.statusCode == 200) {
      List<dynamic> dataMap = jsonDecode(data.body);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Вы были зарегистрированны',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));

    }
    else if (data.statusCode == 460) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Пользователь с таким E-mail уже существует',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
    else if (data.statusCode == 400){
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'неверный код преподавателя',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {});
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('регистрация'),
        automaticallyImplyLeading: true,
      ),
      body:ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Switch(
                        value: isSwitchedEmployee,
                        onChanged: (value) {
                           isSwitchedEmployee = !isSwitchedEmployee;
                           switchGroupOrEmployee = !isSwitchedEmployee ? 'Ученик' : 'Преподаватель';
                           setRegisterWidgets();
                           setState(() {

                           });
                        },
                        activeTrackColor: Colors.deepPurple,
                        activeColor: Colors.deepPurple,
                      ),
                      Wrap(
                        children: <Widget>[
                          Text(switchGroupOrEmployee)
                        ],
                      )
                    ],
                  ),


                  studentOrEmployeeCreate,


                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-mail'),
                    style: TextStyle(fontSize: 23.0),
                    controller: emailController,
                    maxLength: 100,
                    validator: (log){

                      final alphanumeric = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.'
                      r'[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]'
                      r'{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+'
                      r'[a-zA-Z]{2,}))$');

                      if (log.isEmpty) {
                        return 'вы не указали адрес электронной почты';
                      }
                      if (alphanumeric.hasMatch(log) != true) {
                        return 'неккоректный E-mail адрес';
                      }
                      return null;
                    },
                    onSaved: (log) => _login = log,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Пароль'),
                    style: TextStyle(fontSize: 23.0),
                    obscureText: true,
                    maxLength: 50,
                    controller: passwordController1,
                    validator: (pas1){
                      if (pas1.isEmpty) {
                        return 'вы не указали пароль';
                      }
                      return null;
                    },
                    onSaved: (pas1) => _password1 = pas1,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Подтверждение Пароля'),
                    style: TextStyle(fontSize: 23.0),
                    obscureText: true,
                    maxLength: 50,
                    controller: passwordController2,
                    validator: (pas1){
                      if (pas1.isEmpty) {
                        return 'вы не указали пароль';
                      }
                      if(passwordController2.text != passwordController1.text){
                        return 'пароли не совпадают';
                      }
                      return null;
                    },
                    onSaved: (pas1) => _password1 = pas1,
                  ),


                  registrButton
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  void setRegisterWidgets(){

    if (!isSwitchedEmployee)
    {
      studentOrEmployeeCreate = Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Фамилия'),
            style: TextStyle(fontSize: 23.0),
            controller: surnameController,
            maxLength: 30,
            validator: (surname){
              if (surname.isEmpty) {
                return 'поле не должно быть пустым';
              }

              final alphanumeric = RegExp(r'^[A-zА-я ]+$');
              if (!alphanumeric.hasMatch(surname) ) {
                return 'В отчестве должны быть только буквы';
              }

              if (surname.length < 3){
                return 'Слишком короткая фамилия';
              }

              return null;
            },
            onSaved: (surname) => _surname = surname,
          ),

          TextFormField(
            decoration: InputDecoration(labelText: 'Имя'),
            style: TextStyle(fontSize: 23.0),
            controller: nameController,
            maxLength: 30,
            validator: (name){
              if (name.isEmpty) {
                return 'поле не должно быть пустым';
              }

              final alphanumeric = RegExp(r'^[A-zА-я ]+$');
              if (!alphanumeric.hasMatch(name) ) {
                return 'В имени могут быть только буквы';
              }

              if (name.length < 3){
                return 'Слишком короткое имя';
              }

              return null;
            },
            onSaved: (name) => _name = name,
          ),

          TextFormField(
            decoration: InputDecoration(labelText: 'Отчество'),
            style: TextStyle(fontSize: 23.0),
            controller: patronymicController,
            maxLength: 30,
            validator: (patronymic){
              if (patronymic.isEmpty) {
                return 'поле не должно быть пустым';
              }

              final alphanumeric = RegExp(r'^[A-zА-я ]+$');
              if (!alphanumeric.hasMatch(patronymic) ) {
                return 'В отчестве должны быть только буквы';
              }

              if (patronymic.length < 3){
                return 'Слишком короткое отчество';
              }
              return null;
            },
            onSaved: (patronymic) => _patronymic = patronymic,
          ),
        ],
      );

      registrButton = Container(
        margin: EdgeInsets.only(top: 15),
        child: SizedBox(
          width: 300,
          height: 35,
          child: RaisedButton(
            color: Colors.deepPurple,
            child: Text('Зарегистрироваться',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)
            ),
            onPressed: (){
              if (_formKey.currentState.validate()){
                _formKey.currentState.save();

                getData('/registration', {
                  'email': emailController.text.toString(),
                  'password': passwordController1.text.toString(),
                  'name': nameController.text.toString(),
                  'surname': surnameController.text.toString(),
                  'patronymic':patronymicController.text.toString(),
                }).then(onReceiveData);
              }
            },
          ),
        ),
      );
    }
    else {
      studentOrEmployeeCreate = Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Ключ преподавателя'),
              style: TextStyle(fontSize: 23.0),
              maxLength: 4,
              controller: employeeKeyController,
              validator: (surname){

                if (surname.isEmpty) {
                  return 'поле не должно быть пустым';
                }

                return null;
              },
              onSaved: (employeeKey) => _employeeKey = employeeKey,
            ),
          ]
      );

      registrButton = Container(
        margin: EdgeInsets.only(top: 15),
        child: SizedBox(
          width: 300,
          height: 35,
          child: RaisedButton(
            color: Colors.deepPurple,
            child: Text('Зарегистрироваться',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)
            ),
            onPressed: (){
              if (_formKey.currentState.validate()){
                _formKey.currentState.save();

                getData('/registrationEmployee', {
                  'email': emailController.text.toString(),
                  'password': passwordController1.text.toString(),
                  'employeeKey': employeeKeyController.text.toString(),
                }).then(onReceiveData);
              }
            },
          ),
        ),
      );
    }

  }

}