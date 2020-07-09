import 'package:flutter/material.dart';
import 'package:schedule_m/shcedule/schedule_view.dart';
import 'package:schedule_m/auth_or_register/auth.dart';
import 'package:schedule_m/auth_or_register/register.dart';
import 'package:schedule_m/schedule_settings/select_settings.dart';
import 'package:schedule_m/schedule_settings/sel_settings.dart';
import 'package:schedule_m/shared_settings/shared_io.dart';
import 'package:schedule_m/auth_or_register/firebaseController.dart';

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}


List<int> memorySel = [1];
double heightNavbar = 50;
var _navigatorKey = GlobalKey<NavigatorState>();

class _MainScreenState extends State<MainScreen> {



  int sel = 1;


  _MainScreenState(){
    isAuth();


  }

  void authJump(){
    ShPref shPref = ShPref();
    shPref.getOrCreate().then((value){

      if(shPref.email.isNotEmpty
          && shPref.password.isNotEmpty
          && shPref.token.isNotEmpty
          && shPref.autoAuth
      )
      {
        _navigatorKey.currentState.pushNamed('/settingsPush');

      }
      else
        _navigatorKey.currentState.pushNamed('/auth');
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
      }
    });
  }




  @override
  Widget build(BuildContext context) {

    FireBaseController.getInstance().buildContext = context;
//    print('обновился главный экран');
    return Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            if (_navigatorKey.currentState.canPop()) {
              refreshScreen = true;
              _navigatorKey.currentState.pop();
              memorySel.removeLast();
              setState(() {
                sel = memorySel.last;
              });

              return false;
            }
            return true;
          },
          child: Navigator(
            key: _navigatorKey,
            initialRoute: '/',
            onGenerateRoute: (RouteSettings settings) {
              WidgetBuilder builder;
              // Manage your route names here
              switch (settings.name) {
                case '/':

                  builder = (BuildContext context) => ScheduleView();
                  break;
                case '/register':
                    builder = (BuildContext context) => Register();
                    memorySel.add(2);
                  break;
                case '/auth':
                  builder = (BuildContext context) => Auth();
                  break;
                case '/settings':
                  builder = (BuildContext context) => Settings();
                  break;
                case '/settingsPush':
                  builder = (BuildContext context) => SettingsPush();
                    sel = memorySel.last;
                    setState(() { });
                  break;

                default:
                  throw Exception('Invalid route: ${settings.name}');
              }
              // You can also return a PageRouteBuilder and
              // define custom transitions between pages
              return MaterialPageRoute(
                builder: builder,
                settings: settings,
              );
            },
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: heightNavbar,
            child: Container(
              padding: EdgeInsets.only(bottom: 0,top: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: const Radius.circular(25)
                ),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.red,
                currentIndex: sel,
                selectedItemColor: Colors.white,
                onTap:(int value){
                  switch(value) {
                    case 0:
                      {
                        if (sel != value) {
                          _navigatorKey.currentState.pushNamed('/settings');
                          memorySel.add(value);
                        }
                      }break;
                    case 1:
                      {
                        if (sel != value){
                          _navigatorKey.currentState.pushNamed('/');
                          memorySel.add(value);
                        }
                      }break;
                    case 2:
                      {
                        if (sel != value) {
                          memorySel.add(value);
                          authJump();
                        }
                      }break;
                  }
                  setState(() {
                    sel = value;
                  });
                } ,
                // this will be set when a new tab is tapped
                items: [
                  BottomNavigationBarItem(
                    icon: new Icon(Icons.settings),
                    title: SizedBox(),
                  ),
                  BottomNavigationBarItem(
                    icon: new Icon(Icons.schedule),
                    title: SizedBox(),
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.supervised_user_circle),
                      title: SizedBox(),
                  ),
                ],
              ),
            )
        )
    );
  }


}





