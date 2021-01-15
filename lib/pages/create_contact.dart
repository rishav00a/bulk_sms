import 'package:after_layout/after_layout.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Theme.dart' as CustomTheme;
import '../text_style.dart';

class GroupsModel {
  final String title;
  final String slug;

  GroupsModel({this.title, this.slug});

  factory GroupsModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return GroupsModel(title: json["title"], slug: json["slug"]);
  }
}

class CreateContact extends StatefulWidget {
  //TODO: Event summary constructor with event model class initialized in it

  @override
  _CreateContactState createState() => _CreateContactState();
}

class _CreateContactState extends State<CreateContact>
    with AfterLayoutMixin<CreateContact> {
  List<String> districts = List();

  FirebaseUser _firebaseUser;
  List<GroupsModel> list_groups = new List();
  List<dynamic> list_groups_raw = new List();
  List<dynamic> list_groups_selected = new List();
  bool is_saving= false;


  GroupsModel selectedGroup;
  String name;
  String mobile;
  final snackBar = SnackBar(content: Text('Copied to Clipboard'));
  final _formKey = GlobalKey<FormState>();

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

  saveFormData() async {
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();

      setState(() {
        is_saving=true;
      });

      List<dynamic> selected_g =[];
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
      DocumentReference documentReference = await Firestore.instance.collection('contacts')
          .add(
          { 'contact': mobile,
            'name': name,
            'group': selected_g,
            "created_at":DateTime.now().millisecondsSinceEpoch.toString()

          });
        form.reset();

        setState(() {
          is_saving=false;
        });

    }
  }

  @override
  Widget build(BuildContext context) {



    return new Scaffold(
      body: list_groups.length < 1
          ? Column(children: [Text('Loading data... Please wait')])
          : new SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // DropdownSearch<GroupsModel>(
                            //   label: "Group",
                            //   showSearchBox: true,
                            //   // filterFn: (user, filter) => user.userFilterByCreationDate(filter),
                            //   onFind: (String filter) => getData(filter),
                            //   itemAsString: (GroupsModel u) => u.title,
                            //   onChanged: (GroupsModel data) {
                            //   setState(() async {
                            //     selectedGroup = data;
                            //   });
                            //   },
                            //
                            //   selectedItem: selectedGroup,
                            // ),

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
                            SizedBox(height: 20,),

                            TextFormField(
                              onSaved: (val)=>this.name=val,
                              validator: (val) {
                                return (val.length < 1)
                                    ? "Enter Name"
                                    : null;
                              },
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    // borderSide: BorderSide(color: CustomTheme.Colors.appthemeColor5, width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    // borderSide: BorderSide(color: CustomTheme.Colors.appthemeColor4, width: 1.0),
                                  ),
                                  labelText: 'Name',
                                  border: OutlineInputBorder(
                                  )
                              ),
                            ),

                            SizedBox(height: 20,),
                            TextFormField(
                              onSaved: (val)=>this.mobile=val,
                              validator: (val) {
                                return (val.length < 10 || val.length >10)
                                    ? "Enter Mobile"
                                    : null;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    // borderSide: BorderSide(color: CustomTheme.Colors.appthemeColor5, width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    // borderSide: BorderSide(color: CustomTheme.Colors.appthemeColor4, width: 1.0),
                                  ),
                                  labelText: 'Mobile',
                                  border: OutlineInputBorder(
                                  )
                              ),
                            ),
                            SizedBox(height: 20,),

                            !this.is_saving? InkWell(
                              onTap: saveFormData,
                              child: Container(
                                margin: EdgeInsets.only(top: 20),
                                padding:
                                EdgeInsets.only(top: 10, bottom: 10, right: 40, left: 40),

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: CustomTheme.Colors.appthemeColor4,
                                ),
                                child: Text("Add Contact", style: CustomStyle.whiteTextStyle,),
                              ),
                            ):Center(child:
                            Loading(indicator: BallPulseIndicator(), size: 25.0, color:CustomTheme.Colors.appthemeColor),
                            )

                          ],
                        )
                    ),
                  )
              ),
            ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    this.loadData();
  }

  Future<List<GroupsModel>> getData(filter) async {
    List<GroupsModel> mywards = [];

    list_groups.forEach((element) {
      if (element.title.contains(filter)) mywards.add(element);
    });

    return mywards;
  }
}
