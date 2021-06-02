import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glinic_manager/data/rest/rest_ds.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Theme.dart' as CustomTheme;
import '../text_style.dart';
// import 'package:path/path.dart';

import 'create_contact.dart';

class SendSMStoGroup extends StatefulWidget {
  final dynamic group;

  SendSMStoGroup(this.group);

  @override
  _CreateOrderState createState() => new _CreateOrderState([this.group,]);
}

class _CreateOrderState extends State<SendSMStoGroup>
    with AfterLayoutMixin<SendSMStoGroup> {
  String message;
  List<GroupsModel> list_groups = new List();
  List<dynamic> list_groups_raw = new List();
  final List<dynamic> list_groups_selected;
  List<String> mobile_numbers = [];
  RestDatasource api = new RestDatasource();
  _CreateOrderState(this.list_groups_selected);

  bool dropDown = false;
  List<String> districts = List();
  String currentcity;
  FirebaseUser _firebaseUser;
  final _formKey = GlobalKey<FormState>();

  bool formSaving = false;

  saveForm() async {
    final form = _formKey.currentState;

    if(form.validate()){
      form.save();
      setState(() {
        formSaving=true;
      });

      List<dynamic> selected_g =[];
      List<dynamic> recep =[];
      String recep_mobiles = "";
      List<String> recep_mobiles_list = [];

      bool success = false;
      // list_groups_selected.forEach((element) {
      //   String mtitle = "";
      //   list_groups_raw.forEach((melement) {
      //     if(melement["slug"]==element){
      //       mtitle = melement["title"];
      //     }
      //   });
      //   selected_g.add({
      //     'slug':element,
      //     'title':mtitle
      //   });
      //
      // });

      QuerySnapshot district_obj = await Firestore.instance.collection('contacts').where('group', arrayContainsAny: list_groups_selected).getDocuments();

      print(district_obj.documents);
      int index =0;
      district_obj.documents.forEach((element) {
        String ext = "";
        if(index!=0)
        {
          ext = ",";
        }
        else{
          index=1;

        }
        mobile_numbers.add(element.data["contact"]);
        recep.add({

          "mobiles":"91"+element.data["contact"],
          "VAR1":"s",
          "VAR2":"u"
        });

        recep_mobiles = recep_mobiles+ext+element.data["contact"];
        recep_mobiles_list.add("91"+element.data["contact"]);

      });
      mobile_numbers=mobile_numbers.toSet().toList();

      print(recep);
      print(recep_mobiles);

      this.api.sendbulkSMS(recep,recep_mobiles,message).then((onValue) async {
        success= true;
      }).catchError((onError){
      });
      DocumentReference documentReference = await Firestore.instance.collection('messages')
          .add(
          {
            'message': message,
            'groups': selected_g,
            'mobile_numbers':mobile_numbers,
            "created_at":DateTime.now().millisecondsSinceEpoch.toString(),
            "success":success

          });

      setState(() {
        form.reset();
        formSaving=false;
      });

      print("Order Created");
    }


  }

  loadData() async {
    QuerySnapshot district_obj =
    await Firestore.instance.collection('groups').getDocuments();
    for (DocumentSnapshot i in district_obj.documents) {
      print(i.data);
      list_groups.add(GroupsModel.fromJson(i.data));
      list_groups_raw.add(i.data);
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,

          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Send Bulk SMS")),
      body: new SingleChildScrollView(
        child: Card(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        onSaved: (val) => this.message = val,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                          ),
                          labelText: "Message",
                          hintStyle: TextStyle(
                              fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),



                      Divider(),
                      !formSaving?showPrimaryButton():
                      Center(child:
                      Loading(indicator: BallPulseIndicator(), size: 25.0, color:CustomTheme.Colors.appthemeColor),
                      )
                    ],
                  ),
                ))),
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: CustomTheme.Colors.appthemeColor,
            child: new Text('Send SMS',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: saveForm,
          ),
        ));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    loadData();
  }
}

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed, this.onDownload})
      : super(key: key);

  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;

  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status: ${_bytesTransferred(snapshot)} bytes sent');
        } else {
          subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task #${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
