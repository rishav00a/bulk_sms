import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../Theme.dart' as CustomTheme;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../text_style.dart';
import 'add_group.dart';
import 'create_contact.dart';
import 'group_detail.dart';

class ListGroups extends StatefulWidget {
  //TODO: Event summary constructor with event model class initialized in it

  @override
  _ListGroupsState createState() => _ListGroupsState();
}

class _ListGroupsState extends State<ListGroups>{
  TextEditingController searchcontroller= new TextEditingController();


  @override
  Widget build(BuildContext context) {
    void searchListener(){
      print(searchcontroller.text);
      setState(() {

      });
    }
    searchcontroller.addListener(searchListener);
    return SingleChildScrollView(
      child: Column(

        children: <Widget>[
          Row(
            children: <Widget>[
              Form(
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width-50,

                  child:TextFormField(
                    controller: searchcontroller,

                    decoration: InputDecoration(
                        labelText: "Search Groups",
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
              ),

              IconButton(
                onPressed: (){
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new AddGroupPage()));
                },
                icon: Icon(FontAwesomeIcons.solidPlusSquare, color: CustomTheme.Colors.appthemeColor,),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 70),

            // height: MediaQuery.of(context).size.height-150,
            child: ListDelvs(searchcontroller),
          )

        ],
      ),
    );
  }



}

class ListDelvs extends StatefulWidget {
  final TextEditingController searchcontroller;
  //TODO: Event summary constructor with event model class initialized in it
  ListDelvs(this.searchcontroller);

  @override
  _ListDelvsState createState() => _ListDelvsState();
}

class _ListDelvsState extends State<ListDelvs> with AfterLayoutMixin<ListDelvs> {


  List<String> districts = List();
  String currentcity;
  FirebaseUser _firebaseUser;
  List<DocumentReference> list_districts=new List();
  List<GroupsModel> list_groups = new List();


  loadData() async {
    // QuerySnapshot district_obj =
    // await Firestore.instance.collection('groups').getDocuments();
    // for (DocumentSnapshot i in district_obj.documents) {
    //   print(i.data);
    //   list_groups.add(GroupsModel.fromJson(i.data));
    // }
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    Widget urgencyIndicator() {
      return new Container(
          alignment: FractionalOffset.centerRight,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(8.0),
            color: CustomTheme.Colors.appthemeColor,

          )

      );
    }

    Widget orderCardContent(data) {
      return InkWell(
          onTap: (){
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new ListgroupPeople({"slug":data["slug"],"title":data["title"]})));
          },
          child:Container(

        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        margin: new EdgeInsets.only(right: 20, bottom: 2),

        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: new Color(0xFFFFFFFF),
          borderRadius: new BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(data["title"]!=null?data["title"]:"N/A", style: CustomStyle.customTextStyleBlue),

                Padding(padding: EdgeInsets.all(4),),

              ],
            )

          ],
        ),
      ));
    }

    Widget _orderCard(orderData){
      return Column(
        children: <Widget>[
          Container(
            height: 80.0,
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            child: new Stack(
              children: <Widget>[
                urgencyIndicator(),
                orderCardContent(orderData),

              ],
            ),
          ),



        ],
      );
    }


      return StreamBuilder(
        stream: Firestore.instance.collection('groups').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data... Please wait');
          return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, i){

                return snapshot.data.documents[i]["title"].toLowerCase().contains(widget.searchcontroller.text.toLowerCase())?_orderCard(snapshot.data.documents[i]):null;
              }
          );}

    );
  }


  @override
  void afterFirstLayout(BuildContext context) {
    loadData();

  }
}