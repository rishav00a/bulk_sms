import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slugify/slugify.dart';
import '../Theme.dart' as CustomTheme;
import '../text_style.dart';
import 'package:path/path.dart';

class AddGroupPage extends StatefulWidget {
  @override
  _AddGroupPageState createState() => new _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage>
    with AfterLayoutMixin<AddGroupPage> {
  String _name;
  String _mobile;
  String _alternative_mobile;
  String _whatsapp;
  String _address;
  String email;

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

      QuerySnapshot district_obj = await Firestore.instance.collection('districts').where('district', isEqualTo: currentcity).getDocuments();


      await Firestore.instance.collection('groups').document()
          .setData(
          { 'title': _name,
            'slug':Slugify(_name),
            "created_at":DateTime.now().millisecondsSinceEpoch.toString()

          });

      setState(() {
        form.reset();
        formSaving=false;
      });

      print("Order Created");
    }
  }

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    districts = await prefs.getStringList("districts");
    _firebaseUser = await FirebaseAuth.instance.currentUser();
    print(districts);
    setState(() {
      currentcity = districts[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,

          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Add Group")),
      body: new SingleChildScrollView(
        child: Card(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter Title";
                          }
                          return null;
                        },
                        onSaved: (val) => this._name = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Title",
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
            child: new Text('Add Group',
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
