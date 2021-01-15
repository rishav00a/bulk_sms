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
import 'send_bulk_sms.dart';

class ListPharmacyParent extends StatefulWidget {
  //TODO: Event summary constructor with event model class initialized in it

  @override
  _ListPharmacyParentState createState() => _ListPharmacyParentState();
}

class _ListPharmacyParentState extends State<ListPharmacyParent> {
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
                  width: MediaQuery.of(context).size.width,

                  child:TextFormField(
                    controller: searchcontroller,

                    decoration: InputDecoration(
                        labelText: "Search People",
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
              ),

            ],
          ),
          Container(

            height: MediaQuery.of(context).size.height-150,
            child: ListPharmacy(searchcontroller),
          )

        ],
      ),
    );
  }
}

class ListPharmacy extends StatefulWidget {
  final TextEditingController searchcontroller;
  //TODO: Event summary constructor with event model class initialized in it
  ListPharmacy(this.searchcontroller);

  @override
  _ListPharmacyState createState() => _ListPharmacyState();
}

class _ListPharmacyState extends State<ListPharmacy>  with AfterLayoutMixin<ListPharmacy> {

  List<String> districts = List();
  String currentcity;
  FirebaseUser _firebaseUser;
  List<DocumentReference> list_districts=new List();

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

    String getGroups(List<dynamic> groups){

      String ret="";
      int index = 0;
      groups.forEach((element) {
        if(index == 0){
          index =1;
          ret = ret+element["title"];
        }
        else{
          ret = ret+", "+element["title"];
        }
      });

      return ret;
    }
    Widget orderCardContent(data) {
      return Container(
        height: 120.0,
        padding: EdgeInsets.all(15),
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
                Text(data["name"]!=null?data["name"]:"N/A", style: CustomStyle.customTextStyleBlue),
                Padding(padding: EdgeInsets.all(2),),
                Text("Group :"+(data["group"]!=null?getGroups(data["group"]):"N/A"), style: CustomStyle.smallHeader),

                Container(
                  width: MediaQuery.of(context).size.width-70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
//                    IconButton(
//                      onPressed: () async {
//                        launch('mailto:'+this.owners_list[index].user.email);
//                      },
//                      icon: Icon(FontAwesomeIcons.envelope, color: CustomTheme.Colors.appthemeColor8,),
//                    ),

                    IconButton(
                      onPressed: () async {
                        var whatsappUrl ="whatsapp://send?phone=91"+data["contact"];
                        await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                      },
                      icon: Icon(FontAwesomeIcons.whatsapp, color: Colors.greenAccent,),
                    ),
                    IconButton(
                      onPressed: (){
                        launch('tel:'+data["contact"]);

                      },
                      icon: Icon(FontAwesomeIcons.phone, color: CustomTheme.Colors.appthemeColor),
                    ),


                  ],))


              ],
            )

          ],
        ),
      );
    }

    Widget _orderCard(orderData){
      return Column(
        children: <Widget>[
          Container(
            height: 125.0,
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
        stream: Firestore.instance.collection('contacts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data... Please wait');
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, i){

                return snapshot.data.documents[i]["name"].toLowerCase().contains(widget.searchcontroller.text.toLowerCase())?

                InkWell(

                    child:_orderCard( snapshot.data.documents[i])):null;
              }
          );}

    );
  }

  @override
  void afterFirstLayout(BuildContext context) {


  }
}