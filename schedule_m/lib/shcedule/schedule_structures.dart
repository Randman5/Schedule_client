import 'package:flutter/material.dart';
import 'package:schedule_m/Comments/commentStructures.dart';
import 'package:schedule_m/MainClass/main_window.dart';
import 'package:schedule_m/shared_settings/shared_io.dart';


//List<Widget> getrows(){
//  List<Widget> ls = new List<Widget>();
//
//  ls.add(ScheduleRow('08:00', '09:45', 'Математика', 'Аршинова И.И', '35'));
//  ls.add(ScheduleRow('09:45', '11:20', 'О. Экономики', 'Бондарь Е.А', '12'));
//  ls.add(ScheduleRow('11:50', '13:25', 'Основы программирования', 'Фролова Г.Н', '15'));
//  ls.add(ScheduleRow('13:35', '15:10', 'физ-ра', 'Валов Е.А', 'зал'));
//
//  return ls;
//}

class HttpRow {
  int id;
  String lesson_id;
  String group_id;
  String employee_id;
  String employeeName;
  String status_id;
  String cabinet;
  String comment;
  String date;
  String timeStart;
  String timeEnd;
  String day_name;
//  String myID;

  HttpRow(dynamic json){
    this.id = json['id'];
    this.lesson_id = json['lesson_id'];
    this.group_id = json['group_id'];
    this.employee_id = json['employee_id'];
    this.employeeName =json['employeeName'];
    this.status_id = json['status_id'];
    this.cabinet = json['cabinet'];
    this.comment = json['comment'];
    this.date = json['date'];
    this.timeStart = json['timeStart'];
    this.timeEnd = json['timeEnd'];
    this.day_name = json['day_name'];
  }

  ScheduleRow getScheduleRow(){
    return ScheduleRow(
        this.id,
        this.timeStart.substring(0,5),
        this.timeEnd.substring(0,5),
        this.lesson_id,
        this.employeeName,
        this.employee_id,
//        this.myID,
        this.cabinet,
        this.comment,
        this.status_id
    );

  }


}


bool cantRedact = true;

// виджет 1 записи в расписание




class ScheduleRow extends StatelessWidget{

  final int Id;
  final String _timeStart;
  final String _timeEnd;
  final String _lesson;
  final String _teacher;
  final String status_id;
  final String _teacher_id;
  final String _cabinet;
  final String comment;
//  final String myID;

  Color rowColor;
  Widget CommentIcon;

  ScheduleRow(
      this.Id,
      this._timeStart,
      this._timeEnd,
      this._lesson,
      this._teacher,
      this._teacher_id,
//      this.myID,
      this._cabinet,
      this.comment,
      this.status_id
  )
  {
    if (this.comment != null && this.comment != ''){
      rowColor = Colors.green;
      CommentIcon = Expanded(
        flex: 2,
        child: Container(
            alignment: Alignment.center,
            child: Icon(Icons.comment,color: Colors.green, size: 20,)
        ),
      );
    }
    else {
      rowColor = Colors.red;
      CommentIcon = SizedBox(child: Text(''),);
    }


    if (this.status_id == '1' || this.status_id == 'Состоится'){
      rowColor = Colors.green;
    }
    else {
      rowColor = Colors.red;
    }


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: FlatButton(
        splashColor: Colors.deepPurple,
          onPressed: (){
//        print(this.Id.toString());
            memorySel.add(1);
            ShPref sh = ShPref();
            sh.getOrCreate().then((value){
//              if(this._teacher_id == sh.employeeId){
//
//                Navigator.push(context, MaterialPageRoute(
//                    builder: (context)
//                    => Comment(
//                        this.Id.toString(),
//                        this._lesson,
//                        this._cabinet,
//                        this.comment,
//                        false)
//                ),
//                );
//              }
//              else
                if( (this.comment != null && this.comment != '')
                    || this._teacher_id == sh.employeeId)
                {

                cantRedact = this._teacher_id == sh.employeeId ? false: true;

                Navigator.push(context, MaterialPageRoute(
                    builder: (context)
                    => Comment(
                        this.Id.toString(),
                        this._lesson,
                        this._cabinet,
                        this.comment,
                        cantRedact
                    )
                )
                );
              }
            });
//            else Scaffold.of(context).showSnackBar(SnackBar(
//              content: Text('Комментарий отсутствует',
//                style: TextStyle(
//                    color: Colors.red,
//                    fontSize: 15
//                ),
//              ),
//              backgroundColor: Colors.white,
//            ));

          },
          padding: EdgeInsets.all(2),

          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15.0)
          ),

          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[200],
                    Colors.grey[200],
                    rowColor,
                    rowColor
                  ],
                  stops: [0.0, 0.97, 0.97, 1.0],
                )),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2, // 20%
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                            _timeStart,
                            style: TextStyle(
                                fontSize: 16),
                            textAlign: TextAlign.center
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5, // 60%
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[

                            Container(
                              alignment: Alignment.center,
                              child: Text(_lesson,
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            Text(_teacher,
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center
                            )
                          ],
                        ),
                      ),
                    ),
//                    Expanded(
//                      flex: 1, // 20%
//                      child: Container(
//                        alignment: Alignment.centerLeft,
//                          child: Icon(Icons.comment, color: Colors.green,size: 20,),
//                        ),
//                    ),
                    CommentIcon,
                    Expanded(
                      flex: 2, // 20%
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(_timeEnd,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2, // 20%
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(_cabinet,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
//            SizedBox(
//              height: 1,
//              child: Container(
//                alignment: Alignment.center,
//                color: Colors.black,
//              ),
//            ),
              ],
            ),
          )
      ),
    );
  }

}

class DayTable extends StatelessWidget{

  final String _date;
  final String _day;
  final List<Widget> formari;
  //final List<ScheduleRow> _Lessons;// Не забыть переделать под передачу массива

  DayTable(this._date,this._day, this.formari);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
        children:<Widget>[
          Expanded(
              child: Container(
//                    height: 250,
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.all(5.0),
                    child: Column(
                      verticalDirection: VerticalDirection.down,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 5,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '$_day',
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
                                    '$_date',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),

//                              Flexible(
//                                flex: 1,
//                                child: Align(
//                                  alignment: Alignment.centerRight,
//                                  child: IconButton(
//                                    icon: Icon(Icons.comment),
//                                    iconSize: 50,
//                                    onPressed: (){
//
//                                    },
//                                  ),
//                                ),
//                              )
                            ],
                          )
                        ),
                        Column(
                          children: formari,
                        )
                      ],
                    )
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      const Radius.circular(15)
                  ),
                  boxShadow: [
                    BoxShadow (
                      color: const Color(0xcc000000),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                    BoxShadow (
                      color: const Color(0x80000000),
                      offset: Offset(0, 6),
                      blurRadius: 20,
                    ),
                  ],
                ),
              )
          )
        ]
    );
  }
}