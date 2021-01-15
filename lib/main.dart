import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:glinic_manager/pages/root_page.dart';
import 'package:glinic_manager/services/authentication.dart';
import 'Theme.dart' as CustomTheme;

void main(){

  runApp(MyApp());
}
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class MyApp extends StatelessWidget {
  FirebaseUser user;



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: CustomTheme.mainColorTheme,
      ),
      home: SplashScreen(),
    );
  }
}



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// Component UI
class _SplashScreenState extends State<SplashScreen> {

  /// Check user
  bool _checkUser = true;

  String link_passed;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool loddedIn=false;




  Future<Null> _function() async {
    FirebaseUser user = await _firebaseAuth.currentUser();


    this.setState(() {
      if (user == null) {
        _checkUser = false;
      } else {
        _checkUser = true;
      }
    });
  }



  @override
  startTime() async {
    return new Timer(Duration(milliseconds: 2000), NavigatorPage);
  }

  void NavigatorPage() {
//    if(!_checkUser){
//      /// if userhas never been login
//      Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> LoginPage()));
//    }else{
    /// if userhas ever been login
    Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> new RootPage(auth: new Auth())));
//    }
  }
  /// Declare startTime to InitState
  @override
  void initState() {
    super.initState();
    startTime();
    _function();
  }
  /// Code Create UI Splash Screen
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        /// Set Background image in splash screen layout (Click to open code)
        color: Colors.white,
        child: Container(
          /// Set gradient black in image splash screen (Click to open code)
          height: MediaQuery.of(context).size.height,

          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[



              Container(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Powered By",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Sans",
                          fontSize: 10.0,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(8),),
                      Image.asset("assets/images/haxo_logo.png",height: 20.0,),

                      Padding(padding: EdgeInsets.all(20),),

                    ],
                  )
              ),
              Container(alignment: Alignment.center,
                  child:  Center(child:Image.asset("assets/images/glinic.png",height: MediaQuery.of(context).size.height*0.25,),
                  )
              ),

            ],
          ),

        ),
      ),

    );
  }
}