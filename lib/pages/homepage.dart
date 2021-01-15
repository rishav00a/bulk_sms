import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glinic_manager/pages/send_bulk_sms.dart';
import 'package:glinic_manager/pages/create_contact.dart';
import 'package:glinic_manager/services/authentication.dart';
import '../Theme.dart' as CustomTheme;
import '../text_style.dart';
import 'list_groups.dart';
import 'list_people.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex=0;

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
//        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
//        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
//        _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
//        _homeScreenText = "Push Messaging token: $token";
      });

    });
  }

  void changePage(int index){
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double page_height = MediaQuery.of(context).size.height;
    List<Widget> tabBodies = [CreateContact(),ListGroups(),ListPharmacyParent()];

    return Scaffold(
      drawer: Drawer(
        child: Column(
          // Important: Remove any padding from the ListView.
          mainAxisSize: MainAxisSize.max,

          children: <Widget>[

            Container(

              height: page_height*0.25,
              decoration: BoxDecoration(
                color: CustomTheme.Colors.appthemeColor,


              ),
              child: Row(
                children: <Widget>[
                  Column()
                ],
              ),
            ),


//            ListTile(
//              title: Text('Item 1'),
//              onTap: () {
//                Navigator.pop(context);
//              },
//            ),
//            ListTile(
//              title: Text('Item 2'),
//              onTap: () {
//
//                Navigator.pop(context);
//              },
//            ),
            new Expanded(
              child: new Align(
                  alignment: Alignment.bottomCenter,
                  child:

                  new InkWell(
                      onTap: signOut,
                      child:Container(
                        padding: EdgeInsets.all(10),
                        color: CustomTheme.Colors.appthemeColor,
                        child:Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.power_settings_new, color: CustomTheme.Colors.appthemeColor5,),
                            Padding(padding: EdgeInsets.all(5),),
                            Text("Logout", style: CustomStyle.customTextStyleWhite,),
                          ],
                        ),))
              ),
            ),
          ],
        ),
      ),

      appBar: AppBar(
        centerTitle: true,

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Bulk SMS"),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        fabLocation: BubbleBottomBarFabLocation.end,
        hasNotch: true,
        hasInk: true,
        opacity: .2,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(backgroundColor: Colors.red, icon: Icon(FontAwesomeIcons.plus, color: Colors.black,), activeIcon: Icon(FontAwesomeIcons.plus, color: Colors.red,), title: Text("Add")),
          BubbleBottomBarItem(backgroundColor: Colors.deepPurple, icon: Icon(FontAwesomeIcons.users, color: Colors.black,), activeIcon: Icon(FontAwesomeIcons.users, color: Colors.deepPurple,), title: Text("Groups")),
          BubbleBottomBarItem(backgroundColor: Colors.indigo, icon: Icon(FontAwesomeIcons.user, color: Colors.black,), activeIcon: Icon(FontAwesomeIcons.user, color: Colors.indigo,), title: Text("People")),
       ],
      ),
      body: tabBodies[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => new CreateOrderPage()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}