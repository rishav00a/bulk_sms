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

class CreateOrderPage extends StatefulWidget {
  @override
  _CreateOrderState createState() => new _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrderPage>
    with AfterLayoutMixin<CreateOrderPage> {
  String message;
  List<GroupsModel> list_groups = new List();
  List<dynamic> list_groups_raw = new List();
  List<dynamic> list_groups_selected = new List();
  List<String> mobile_numbers = [];
  RestDatasource api = new RestDatasource();
  String over_booked_var;

  String drc_state, drc_date, drc_val1, drc_val2, drc_val3;
  String rcprc_state, rcprc_date, rcprc_val1, rcprc_val2, rcprc_val3, rcprc_val4, rcprc_val5, rcprc_val6, rcprc_val7, rcprc_val8, rcprc_val9;



  bool dropDown = false;
  List<String> districts = List();
  String currentcity;
  FirebaseUser _firebaseUser;
  final _formKey = GlobalKey<FormState>();

  String _chosenValue;

  bool formSaving = false;
  List<Widget> getSpecificForm(){
    if(_chosenValue == "over_booked"){
      return <Widget>[Container(
        child: TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter Date";
            }
            return null;
          },
          onSaved: (val) => this.over_booked_var = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Date",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),
      )];
    }
    else if (_chosenValue == "dealer_rate_change"){
      return <Widget>[
        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter State";
            }
            return null;
          },
          onSaved: (val) => this.drc_state = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "State",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),
        SizedBox(height: 30,),


        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter Date";
            }
            return null;
          },
          onSaved: (val) => this.drc_date = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Date",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),
        SizedBox(height: 30,),

        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter Pricing 1";
            }
            return null;
          },
          onSaved: (val) => this.drc_val1 = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "12,16,20,25 MM Price",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),
        SizedBox(height: 30,),

        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter Pricing 2";
            }
            return null;
          },
          onSaved: (val) => this.drc_val2 = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "10 MM Price",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),
        SizedBox(height: 30,),
        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter Pricing 3";
            }
            return null;
          },
          onSaved: (val) => this.drc_val3 = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "08 & 32 MM Price",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),

      ];
    }
    else if (_chosenValue == "rcp_rate_change"){
      return <Widget>[
        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter State";
            }
            return null;
          },
          onSaved: (val) => this.rcprc_state = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "State",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),
        SizedBox(height: 30,),


        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter Date";
            }
            return null;
          },
          onSaved: (val) => this.rcprc_date = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Date",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),
        SizedBox(height: 30,),

        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter Pricing 1";
            }
            return null;
          },
          onSaved: (val) => this.rcprc_val1 = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "5.5mm Price",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),
        SizedBox(height: 30,),

        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter Pricing 2";
            }
            return null;
          },
          onSaved: (val) => this.rcprc_val2 = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "08mm Price",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),
        SizedBox(height: 30,),
        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter Pricing 3";
            }
            return null;
          },
          onSaved: (val) => this.rcprc_val3 = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "10mm Price",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),


        SizedBox(height: 30,),

        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter Pricing 4";
            }
            return null;
          },
          onSaved: (val) => this.rcprc_val4 = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "12mm Price",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),
        SizedBox(height: 30,),

        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter Pricing 5";
            }
            return null;
          },
          onSaved: (val) => this.rcprc_val5 = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "16mm Price",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),
        SizedBox(height: 30,),
        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter Pricing 6";
            }
            return null;
          },
          onSaved: (val) => this.rcprc_val6 = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "20mm Price",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),


        SizedBox(height: 30,),

        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter Pricing 7";
            }
            return null;
          },
          onSaved: (val) => this.rcprc_val7 = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "25mm Price",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),
        SizedBox(height: 30,),

        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter Pricing 8";
            }
            return null;
          },
          onSaved: (val) => this.rcprc_val8 = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "28mm Price",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),
        SizedBox(height: 30,),
        TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter Pricing 9";
            }
            return null;
          },
          onSaved: (val) => this.rcprc_val9 = val,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "32mm Price",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
          ),
        ),


      ];

    }
    else{
      return <Widget>[Container()];
    }
  }

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
      list_groups_selected.forEach((element) {
        String mtitle = "";
        list_groups_raw.forEach((melement) {
          if(melement["slug"]==element){
            mtitle = melement["title"];
          }
        });
        selected_g.add({
          'slug':element,
          'title':mtitle
        });

      });

      QuerySnapshot district_obj = await Firestore.instance.collection('contacts').where('group', arrayContainsAny: selected_g).getDocuments();

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
        if(_chosenValue == "over_booked"){
          recep.add({

            "mobiles":"91"+element.data["contact"],
            "var":over_booked_var,

          });
        }
        else if (_chosenValue == "dealer_rate_change"){
          recep.add({

            "mobiles":"91"+element.data["contact"],
            "state":drc_state,
            "date":drc_date,
            "group1":"12,16,20,25 MM - Rs",
            "val1":drc_val1+"/- pmt",
            "group2":"10 MM - Rs",
            "val2":drc_val2+"/- pmt",
            "group3":"08 & 32 MM - Rs",
            "val3":drc_val3+"/- pmt",

          });
        }
        else if (_chosenValue == "rcp_rate_change"){
          recep.add({

            "mobiles":"91"+element.data["contact"],
            "state":rcprc_state,
            "date":rcprc_date,
            "price1":rcprc_val1,
            "price2":rcprc_val2,
            "price3":rcprc_val3,
            "price4":rcprc_val4,
            "price5":rcprc_val5,
            "price6":rcprc_val6,
            "price7":rcprc_val7,
            "price8":rcprc_val8,
            "price9":rcprc_val9
          });
        }



        recep_mobiles = recep_mobiles+ext+element.data["contact"];
        recep_mobiles_list.add("91"+element.data["contact"]);

      });
      mobile_numbers=mobile_numbers.toSet().toList();

      print(recep);
      print(recep_mobiles);
      String flow_id = "";


      if(_chosenValue == "over_booked"){
        flow_id = "609e5518c6109f777641c4aa";

      }
      else if(_chosenValue == "dealer_rate_change"){
        flow_id = "60a60fa0b848384e4a5a4924";
      }
      else if(_chosenValue == "rcp_rate_change"){
        flow_id = "60a621bae98c812dc57d3e43";
      }


      this.api.sendbulkSMSM(recep,recep_mobiles,message, flow_id).then((onValue) async {
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
                      MultiSelect(
                          autovalidate: false,
                          titleText: "Group",
                          validator: (value) {
                            if (value == null) {
                              return 'Please select one or more option(s)';
                            }
                          },
                          errorText: 'Please select one or more option(s)',
                          dataSource:list_groups_raw,
                          textField: 'title',
                          valueField: 'slug',

                          filterable: true,
                          required: true,
                          value: null,
                          onSaved: (value) {
                            list_groups_selected = value;
                            print('The value is $value');
                          }
                      ),
                      SizedBox(height: 30,),
    Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 30),
      width: MediaQuery.of(context).size.width-40,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color:Colors.black54)
      ),
    child:DropdownButtonHideUnderline (child:DropdownButton<String>(
                        focusColor:Colors.white,
                        value: _chosenValue,
                        //elevation: 5,
                        style: TextStyle(color: Colors.white),
                        iconEnabledColor:Colors.black,
                        items: <String>[
                          'over_booked',
                          'dealer_rate_change',
                          'rcp_rate_change'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,style:TextStyle(color:Colors.black),),
                          );
                        }).toList(),
                        hint:Text(
                          "Select SMS Type",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _chosenValue = value;
                          });
                        },
                      ),)),

                      Column(
                        // physics: NeverScrollableScrollPhysics(),
                        // shrinkWrap: true,
                      children: getSpecificForm(),
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
            onPressed: _chosenValue!=null? saveForm:null,
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
