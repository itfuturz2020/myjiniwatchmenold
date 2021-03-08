import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:smartsocietystaff/Common/ClassList.dart';
import 'package:smartsocietystaff/Common/Constants.dart' as constant;
import 'package:smartsocietystaff/Common/Services.dart';
import 'package:smartsocietystaff/Component/masktext.dart';

import 'AddDocument.dart';

class StaffProfile extends StatefulWidget {
  var staffData;

  StaffProfile({this.staffData});

  @override
  _StaffProfileState createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  TextEditingController nameText = new TextEditingController();
  TextEditingController contactText = new TextEditingController();
  TextEditingController addressText = new TextEditingController();
  TextEditingController vehicleText = new TextEditingController();
  TextEditingController workText = new TextEditingController();
  TextEditingController purposeText = new TextEditingController();

  List<WingClass> wingclasslist = [];
  WingClass wingClass;
  List _selectedFlatlist = [];
  List FlatData = [];
  List allWingList = [];
  List finalSelectList = [];
  List allFlatList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  setData() {
    nameText.text = widget.staffData["Name"];
    contactText.text = widget.staffData["ContactNo"];
    vehicleText.text = widget.staffData['lastentry'][0]["VehicleNo"];
    workText.text = widget.staffData["Work"];
    purposeText.text = widget.staffData["Purpose"];
    addressText.text = widget.staffData["Address"];
  }

  GetFlatData(String WingId) async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          pr.show();
        });

        Services.getFlatData(WingId).then((data) async {
          setState(() {
            pr.hide();
          });
          if (data != null && data.length > 0) {
            setState(() {
              FlatData = data;
            });
            print("----->" + data.toString());
          } else {
            setState(() {
              pr.hide();
            });
          }
        }, onError: (e) {
          setState(() {
            pr.hide();
          });
          showHHMsg("Try Again.", "");
        });
      } else {
        setState(() {
          pr.hide();
        });
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
  }

  showHHMsg(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              color: Colors.grey[100],
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.staffData);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Edit Staff",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: widget.staffData["Image"] != '' &&
                        widget.staffData["Image"] != null
                    ? FadeInImage.assetNetwork(
                        placeholder: '',
                        image: "http://smartsociety.itfuturz.com/" +
                            "${widget.staffData["Image"]}",
                        width: 60,
                        height: 60,
                        fit: BoxFit.fill)
                    : Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(75),
                          color: constant.appPrimaryMaterialColor,
                        ),
                        child: Center(
                          child: Text(
                            "${widget.staffData["Name"].toString().substring(0, 1).toUpperCase()}",
                            style: TextStyle(fontSize: 35, color: Colors.white),
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: nameText,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                      counterText: "",
                      labelText: "Staff Name",
                      hasFloatingPlaceholder: true,
                      labelStyle: TextStyle(fontSize: 13)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: contactText,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                      counterText: "",
                      labelText: "Contact Number",
                      hasFloatingPlaceholder: true,
                      labelStyle: TextStyle(fontSize: 13)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  inputFormatters: [
                    MaskedTextInputFormatter(
                      mask: 'xx-xx-xx-xxxx',
                      separator: '-',
                    ),
                  ],
                  controller: vehicleText,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                      counterText: "",
                      labelText: "Enter Vehicle Number",
                      hintText: "XX-00-XX-0000",
                      hasFloatingPlaceholder: true,
                      labelStyle: TextStyle(fontSize: 13)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: addressText,
                  keyboardType: TextInputType.text,
                  maxLength: 10,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                      counterText: "",
                      labelText: "Staff Address",
                      hasFloatingPlaceholder: true,
                      labelStyle: TextStyle(fontSize: 13)),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                  child: Text(
                    "Select Wing",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6.0))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<WingClass>(
                        icon: Icon(
                          Icons.chevron_right,
                          size: 20,
                        ),
                        hint: wingclasslist.length > 0
                            ? Text("Select Wing",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600))
                            : Text(
                                "Wing Not Found",
                                style: TextStyle(fontSize: 14),
                              ),
                        value: wingClass,
                        onChanged: (val) {
                          print(val.WingName);
                          setState(() {
                            wingClass = val;
                            _selectedFlatlist.clear();
                            FlatData.clear();
                          });
                          GetFlatData(val.WingId);
                        },
                        items: wingclasslist.map((WingClass wingclass) {
                          return new DropdownMenuItem<WingClass>(
                            value: wingclass,
                            child: Text(
                              wingclass.WingName,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      )),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      child: MultiSelectFormField(
                        autovalidate: false,
                        titleText: "Select Flat",
                        dataSource: FlatData,
                        textField: "FlatNo",
                        valueField: 'FlatNo',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'CANCEL',
                        hintText: 'Select Flat',
                        value: _selectedFlatlist,
                        onSaved: (value) {
                          setState(() {
                            setState(() {
                              _selectedFlatlist = value;
                            });
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: RaisedButton(
                      child: Text(
                        "+",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      onPressed: () {
                        if (!allWingList.contains(wingClass)) {
                          for (int i = 0; i < _selectedFlatlist.length; i++) {
                            finalSelectList.add({
                              "WingId": wingClass.WingId,
                              "FlatId": _selectedFlatlist[i]
                            });
                          }
                          setState(() {
                            allFlatList.add(_selectedFlatlist);
                            allWingList.add(wingClass);
                          });
                          setState(() {
                            _selectedFlatlist = [];
                            wingClass = null;
                          });
                        } else {
                          int index = allWingList.indexOf(wingClass);
                          print(index);
                          setState(() {
                            allWingList.removeAt(index);
                            allFlatList.removeAt(index);
                          });
                          for (int i = 0; i < _selectedFlatlist.length; i++) {
                            finalSelectList.add({
                              "WingId": wingClass.WingId,
                              "FlatId": _selectedFlatlist[i]
                            });
                          }
                          setState(() {
                            allFlatList.add(_selectedFlatlist);
                            allWingList.add(wingClass);
                          });
                          setState(() {
                            _selectedFlatlist = [];
                            wingClass = null;
                          });
                        }
                      }),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Selected Wing & Flat"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: allWingList.length * 60.0,
                child: ListView.separated(
                  itemCount: allWingList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                              allWingList[index].WingName +
                                  '-' +
                                  allFlatList[index]
                                      .toString()
                                      .replaceAll("[", "")
                                      .replaceAll("]", ""),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Update Staff",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      color: Colors.green,
                      onPressed: () {})),
            ),
          ],
        ),
      ),
    );
  }
}
