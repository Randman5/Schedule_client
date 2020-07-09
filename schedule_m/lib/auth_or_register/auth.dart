import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schedule_m/shared_settings/shared_io.dart';
import 'firebaseController.dart';
import 'package:schedule_m/MainClass/main_window.dart';

import 'package:connectivity/connectivity.dart';



class Auth extends StatefulWidget{

  @override
  _AuthPage createState() => _AuthPage();
}

class _AuthPage extends State<Auth>{
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  _AuthPage(){
    loadAuthView();
  }

  String _login = '';
  String _password = '';
  bool _autoAuth = false;

  TextEditingController loginController  = TextEditingController();
  TextEditingController passwordController  = TextEditingController();



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey ,
      appBar: AppBar(
        title: Text('Авторизация'),
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[

                  SizedBox.fromSize(
                    size: Size(75,75),
                    child: Image.asset('images/login.png'),
                  ),

                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-mail'),
                    style: TextStyle(fontSize: 23.0),
                    controller: loginController,
                    validator: (log){

                      final alphanumeric = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.'
                      r'[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]'
                      r'{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+'
                      r'[a-zA-Z]{2,}))$');

                      if (log.isEmpty) {
                        return 'пожалуйста введите email';
                      }
                      if (alphanumeric.hasMatch(log) != true) {
                        return 'неккоректный email адрес';
                      }


                    },
                    onSaved: (log) => _login = log,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Пароль'),
                    style: TextStyle(fontSize: 23.0),
                    obscureText: true,
                    controller: passwordController,
                    validator: (pas){
                      if (pas.isEmpty) {
                        return 'вы не указали пароль';
                      }
                    },
                    onSaved: (pas) => _password = pas,
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          value: _autoAuth,
                          onChanged: (value){
                            setState(() {
                              _autoAuth = !_autoAuth;
                            });
                          },
                        ),
                        Text('Запомнить меня')
                      ],
                    ),
                  ),


                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: SizedBox(
                      width: 300,
                      height: 35,
                      child: RaisedButton(
                        color: Colors.deepPurple,
                        child: Text('Войти',
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
//
                            getDataAuth(_login, _password).then(onReceiveDataAuth)
                                .catchError((value){
                              showErrorSnackBar('Отсутствует интернет соединение');
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: SizedBox(
                      width: 300,
                      height: 35,
                      child: RaisedButton(
                        color: Colors.deepPurple,
                        child: Text('Регистрация',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                        ),
                        onPressed: (){

                          Navigator.pushNamed(context, '/register');
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  //авторизация
  Future<http.Response> getDataAuth(String email, String password) {
    return Future<http.Response>(() async {


      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile
          || connectivityResult == ConnectivityResult.wifi) {

        var client = http.Client();
        var resp = (await client.post('http://ruslan.wwspace.ru/api/auth',
            body: {'email': email, 'password': password}));
        client.close();

        return resp;
      }
      return null;


    });
  }

// парсинг полученных данных
  void onReceiveDataAuth(http.Response data) {

//    print(jsonDecode(data.body)[0]['remember_token']);
    if (data == null) showErrorSnackBar('Отсутствует интернет соединение');
    else if (data.statusCode == 200) {

      List<dynamic> dataMap = jsonDecode(data.body);

      ShPref shPref = ShPref();

      shPref.getOrCreate().then((value){

        shPref.token = dataMap[0]["remember_token"];

        shPref.email = _login;
        shPref.password = _autoAuth ? _password : '';
        shPref.autoAuth = _autoAuth;


        FireBaseController.getInstance().sendTokenToServer(shPref.token);
        
        shPref.upDate().then((value){

          Navigator.pop(context);

          Navigator.pushNamed(context, '/settingsPush');

        });

      });
    }
    else if (data.statusCode == 401)
    {
      showErrorSnackBar('Неверный э-мейл или пароль');
    }
    setState(() {});
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

  void loadAuthView(){
    ShPref shPref = ShPref();
    shPref.getOrCreate().then((value){


      if (shPref.email.isNotEmpty
          && shPref.token.isNotEmpty
      )
      {
        loginController.text = shPref.email;
        passwordController.text = shPref.password;
        _autoAuth = shPref.autoAuth;
      }
      setState(() { });

    });
  }

}