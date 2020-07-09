
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:schedule_m/shared_settings/shared_io.dart';
import 'package:schedule_m/shcedule/schedule_view.dart';

class Comment extends StatelessWidget{

  String comment;
  String dayName;
  String date;
  String lessonId;

//  bool canWrite;
  bool readOnly;

  int sizeButton = 2;



  TextEditingController commentController  = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Comment(this.lessonId ,this.dayName, this.date, this.comment, this.readOnly){
    commentController.text = this.comment;

    if (readOnly) sizeButton = 0;
    else sizeButton = 1;

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                  children: <Widget>[
                    Flexible(
                    flex: 5,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '$dayName',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$date',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
      body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child:
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    readOnly: readOnly,
                    maxLength: 700,
                    maxLines: 90,
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "Введите сообщение",
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                  ),
                )
            ),
            Expanded(
              flex: sizeButton,
              child:  readOnly
                  ? SizedBox()
                  : Container(
                  margin: EdgeInsets.only( left: 10, right: 10, bottom: 20),
                  child:SizedBox.expand(
                    child: RaisedButton(
                      color: Colors.deepPurple,
                      child: Text('Отправить',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)
                      ),
                      onPressed: () {
                        ShPref sh = ShPref();
                        sh.getOrCreate().then((value){
//                            print(sh.token);
                          if (sh.employeeId !='')
                            getData(sh.token,sh.employeeId).then(onReceiveData);
                          else _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Недостаточно прав'),
                                backgroundColor: Colors.red,
                              )
                          );
                        });
                      },
                    ),
                  )

              ),
            )
          ],
      )
    );
  }

  Future<http.Response>
  getData(String token, String employeeId) {
    return Future<http.Response>(() async {
      var client = http.Client();
      var resp = (await client.post('http://ruslan.wwspace.ru/api/CommentChange',
          body: {
            'id': lessonId.toString(),
            'Comment' : commentController.text,
            'Token' : token,
            'Employee': employeeId.toString()
          }

      ));
//      print(lessonId.toString() + ' ' + commentController.text.toString() + ' ' + token.toString() + ' ' + employeeId.toString());
      client.close();
      refreshScreen = true;
      return resp;
    });
  }

// парсинг полученных данных
  void onReceiveData(http.Response data) {


    if (data.statusCode == 200) {
      List<dynamic> dataMap = jsonDecode(data.body);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Изменено',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));

    }
    else if (data.statusCode == 400) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'нет доступа',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

}