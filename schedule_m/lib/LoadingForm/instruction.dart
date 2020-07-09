


import 'package:flutter/material.dart';




class Instruction extends StatefulWidget {


  @override
  _InstructionState createState() => _InstructionState();

}


class _InstructionState extends State<Instruction>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.child_care)),
                Tab(icon: Icon(Icons.schedule)),
                Tab(icon: Icon(Icons.settings)),
                Tab(icon: Icon(Icons.supervised_user_circle)),
                Tab(icon: Icon(Icons.create)),
                Tab(icon: Icon(Icons.verified_user)),
                Tab(icon: Icon(Icons.comment)),
                Tab(icon: Icon(Icons.notifications)),
              ],
            ),
            title: Text('Инструкция'),
          ),
          body: TabBarView(
            children: [

              //пункт приветствие
              ListView(children: <Widget>[

                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.child_care,
                        size: 100,
                        color: Colors.deepPurple,
                      ),

                      Text(
                          'Дорогой пользователь, приветствую тебя-'
                          +'это раздел инструкции, в котором ты узнаешь, '
                          +'как пользоваться приложением\n' ,

                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      Text(
                        ' \"Твоё расписание\"' ,
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 35,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      Container(
                        margin:  EdgeInsets.only(top: 30, bottom: 20),
                        child: SizedBox.fromSize(
                          size: Size(350, 150),
                          child: Image.asset('images/menuInstruction.png'),
                        ),
                      ),

                      Text(
                        'На рисунке выше красной линией подчеркнуты '
                        +'пункты меню инструкции. Перемещение по пунктам '
                        +'осуществляется с помощью нажатия на иконку, '
                        +'либо свайпа влево или вправо. '
                        +'Текущий пункт подчеркнут белой линией. '
                        +'На рисунке на него указывает красная стрелка. ',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.start,
                      ),

                    ],
                  ),
                )

              ],),


              // пункт расписания
              ListView(children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[

                      Icon(Icons.schedule,
                        size: 100,
                        color: Colors.deepPurple,
                      ),

                      Text(
                        'Пункт расписания\n',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 35,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      Container(
                        margin:  EdgeInsets.only( bottom: 20),
                        child: SizedBox(
                          width: 300,
                          child: Image.asset('images/View.png'),
                        ),
                      ),
                      Text(
                        'На рисунке выше показан интерфейс расписания'
                        +'и отмеченны элементы управления:' ,
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Text(
                        '1)отслеживаемое расписание;\n\n'+

                        '2)открыть инструкцию;\n\n'+

                        '3)расписание, сгруппированное по дням ;\n\n'+

                        '4)настройки расписания;\n\n'+

                        '5)личный кабинет с возможностью настроки уведомлений'
                            +'(уведомления настраиваются только у учеников).\n'
                            +'Для доступа в личный кабинет нужно '
                            +'авторизоваться либо зарегистрироваться '
                            +'\n\n',

                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      Text(
                        'Плитка дня расписания\n',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      Container(
                        margin:  EdgeInsets.only( bottom: 20),
                        child: SizedBox(
                          width: 300,
                          child: Image.asset('images/plate.png'),
                        ),
                      ),

                      Text(
                        'На рисунке выше показана интерфейс плитки для одного'
                            +' дня недели:',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Text(
                        '1)День недели;\n\n'+

                        '2)Дата проведения занятий; \n\n'+

                        '3)Кнопка одного занятия; \n\n'+

                        '4)Время начала занятия; \n\n'+

                        '5)Имя преподавателя или имя группы(зависит от '
                            +'того какая у вас роль); \n\n'+

                        '6)название занятия; \n\n'+

                        '7)Иконка комментария. она появляется только, если '
                            +' преподаватель оставил комментарий.'
                            +' открытый комментарий будет доступен для '
                            +' редактирования \n\n'+

                        '8)время окончания занятия; \n\n'+

                        '9)Номер кабинета, в котором проводится занятие; \n\n'+

                        '10)Индикатор проведения пары. Если он зеленого цвета, '
                        +'то занятие состоится, красный - отменено. \n\n',

                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),


                Image.asset('images/refresh.gif'),

                Text(
                  'Для принудительного обновления страницы '
                  +'потяните за экран сверху вниз',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),

              ],
              ),

              //настроки расписания
              ListView(children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.settings,
                        size: 100,
                        color: Colors.deepPurple,
                      ),

                      Text(
                        'Настройки расписания\n',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 35,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(
                        width: 350,
                        child: Image.asset('images/FullSettingsSchedule.png'),
                      ),

                      Text(
                        'На рисунке выше показана интерфейс окна '
                            +'настроек расписания :',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      Text(
                        '1)город, где расположено учебное заведение; \n\n'+

                        '2)название учебного заведения; \n\n'+

                        '3)отслеживаемое расписание. \n'
                        +'При первом запуске первые 3 пункта не отображаются; \n\n'+


                        '4)список доступныз городов; \n\n'+

                        '5)список учебных заведений, доступных в выбранном городе; \n\n'+

                        '6)фильтр по преподавателю или группе/классу ; \n\n'+

                        '7)выбор отслеживаемого расписания '
                            +'(зависит от предыдущего фильтра); \n\n'+

                        '8)Кнопка для применения настроек; \n\n',

                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      Text(
                        'Стандартный элемент выбора из списка представлен на '
                            +' следующем рисунке:',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        width: 300,
                        child:  Image.asset('images/Search.png'),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Text(
                        '1)поиск; \n\n'+

                        '2)Доступные элементы \n\n'+

                        '3)Кнопка закрыть\n\n',

                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                    ],
                  ),
                )

              ],),

              // авторизация
              ListView(children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.supervised_user_circle,
                        size: 100,
                        color: Colors.deepPurple,
                      ),

                      Text(
                        'Авторизация\n',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 35,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(
                        width: 350,
                        child: Image.asset('images/auth.png'),
                      ),

                      Text(
                        'На рисунке выше показана интерфейс окна '
                            +'авторизации :',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Text(
                        '1)Поле для ввода электронной почты '
                            +'от зарегистрированного аккаунта\n\n'+

                        '2)Поле для ввода пароля; \n\n'+

                        '3)Флажок для который отвечает за '
                          +'запоминание вашего адреса эл.почты и пароля \n\n'+

                        '4)Кнопка входа в личный кабинет; \n\n'+

                        '5)Кнопка перехода в меню регистрации ; \n\n' ,

                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),



                    ],
                  ),
                )

              ],),

              // регистрация
              ListView(children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.create,
                        size: 100,
                        color: Colors.deepPurple,
                      ),

                      Text(
                        'Регистрация\n',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 35,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(
                        width: 350,
                        child: Image.asset('images/RegStudent.png'),
                      ),

                      Text(
                        'На рисунке выше показана интерфейс окна '
                            +'регистрации  ученика:',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      Text(
                        '1)выбор роли; \n\n'+

                        '2)поле ввода Фамилии; \n\n'+

                            '3)поле ввода имени; \n\n'+


                            '4)поле ввода отчества; \n\n'+

                            '5)поле ввода адреса эл.почты; \n\n'+

                            '6)поле ввода пароля; \n\n'+

                            '7)поле ввода повторного пароля; \n\n' +
                        '8)кнопка регистрации; \n\n' ,

                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),



                      SizedBox(
                        width: 350,
                        child: Image.asset('images/RegEmployee.png'),
                      ),
                      Text(
                        'На рисунке выше показана интерфейс окна '
                        +'регистрации преподавателя:',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      Text(
                        '1)Переключатель между учеником и преподавателем; \n\n'+

                        '2)Поле ввода ключа преподавателя который выдают'+

                        ' в вашем учебном учреждении для подтверждения вашей личности; \n\n'+

                        '3)поле ввода адреса эл.почты; \n\n'+

                        '4)поле ввода пароля; \n\n'+

                        '5)поле ввода повторного пароля; \n\n' +

                        '6)кнопка регистрации. \n\n' ,

                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                    ],
                  ),
                )

              ],),

              // личный кабинет
              ListView(children: <Widget>[

                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.verified_user,
                        size: 100,
                        color: Colors.deepPurple,
                      ),

                      Text(
                        'Личный кабинет\n',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 35,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(
                        width: 350,
                        child: Image.asset('images/VerifiedStudent.png'),
                      ),

                      Text(
                        'На рисунке выше показана интерфейс окна '
                            +'личного кабинета ученика:',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      Text(
                        '1)Ф.И.О. владельца аккаунта; \n\n'+

                        '2)роль пользователя; \n\n'+

                        '3)переключатель, который отвечает'
                          +' за получение уведомлений; \n\n'+


                        '4)город, где расположено учебное заведение; \n\n'+

                        '5)название учебного заведения; \n\n'+

                        '6)отслеживаемое расписание. \n'
                        +'При первом запуске первые 3 пункта не отображаются; \n\n'+


                        '7)выбор города; \n\n'+

                        '8)выбор учебного заведения; \n\n'+

                        '9)выбор отслеживаемого расписания; \n\n'+

                        '10)кнопка для применения настроек. \n\n',

                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(
                        width: 350,
                        child: Image.asset('images/VerifiedEmployee.png'),
                      ),

                      Text(
                        'На рисунке выше показана интерфейс окна '
                            +'личного кабинета преподавателя:',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      Text(
                        '1)Ф.И.О. владельца аккаунта; \n\n'+

                        '2)Роль пользователя; \n\n'+

                        '3)Переключатель, который отвечает'
                        +' за получение уведомлений; \n\n'+


                        '4)Город, где расположено учебное заведение; \n\n'+

                        '5)название учебного заведения; \n\n',

                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      Image.asset('images/refresh.gif'),

                      Text(
                        'Для принудительного обновления страницы '
                            +'потяните за экран сверху вниз.',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),

                    ],
                  ),
                )


              ],),
              // Комментарии
              ListView(children: <Widget>[


                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.comment,
                        size: 100,
                        color: Colors.deepPurple,
                      ),

                      Text(
                        'Комментарии\n',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 35,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(
                        width: 350,
                        child: Image.asset('images/Comment.png'),
                      ),

                      Text(
                        'на рисунке выше показана интерфейс окна '
                            +' комментария :',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Text(
                        '1)Название пары \n\n'+

                        '2)Номер кабинета; \n\n'+

                        '3)поле для ввода комментария. Ввод доступен '
                          +'только преподователю, который проводит эту пару; \n\n'+

                          '4)Кнопка отправки комментария. присутствует только, '
                          +'если вы авторизировались, как преподаватель,'
                          +' который проводит данную пару. \n\n' ,

                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),



                    ],
                  ),
                ),
              ],),

              //уведомления
              ListView(children: <Widget>[

                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.notifications,
                        size: 100,
                        color: Colors.deepPurple,
                      ),

                      Text(
                        'Уведомления\n',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 35,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(
                        width: 350,
                        child: Image.asset('images/pushInApp.png'),
                      ),

                      Text(
                        'на рисунке выше показано как выглядят уведомления '
                            +' когда приложение открыто.\n',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        width: 350,
                        child: Image.asset('images/InBackPush.png'),
                      ),

                      Text(
                        'на рисунке выше показано как выглядят уведомления '
                            +' когда приложение свернуто либо закрыто.\n',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )

              ],),
            ],
          ),
        ),
      ),
    );
  }
}