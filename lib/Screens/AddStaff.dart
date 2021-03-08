import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietystaff/Common/ClassList.dart';
import 'package:smartsocietystaff/Common/Constants.dart';
import 'package:smartsocietystaff/Common/Services.dart';
import 'package:smartsocietystaff/Common/Constants.dart' as constant;
import 'package:smartsocietystaff/Component/masktext.dart';

class AddStaff extends StatefulWidget {
  @override
  _AddStaffState createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  List<staffClass> _staffTypeList = [];
  staffClass _staffClass;
  bool isLoading = false;
  File image;
  ProgressDialog pr;
  int wingflatcount = 0;
  File _image;
  String Gender;

  TextEditingController txtName = TextEditingController();
  TextEditingController txtaddress = TextEditingController();
  TextEditingController txtagencyname = TextEditingController();
  TextEditingController txtContactNo = TextEditingController();
  TextEditingController txtvoterId = TextEditingController();
  TextEditingController txtwingflatcount = TextEditingController();
  TextEditingController vehiclenotext = TextEditingController();
  TextEditingController adharnumbertxt = TextEditingController();
  TextEditingController worktext = TextEditingController();
  TextEditingController purposetext = TextEditingController();
  TextEditingController txtemergencyNo = TextEditingController();

  List<WingClass> wingclasslist = [];
  String SelectType;
  String SocietyId;
  WingClass wingClass;
  bool _WingLoading = false;
  List FlatData = [];
  List _selectedFlatlist = [];
  StaffType staffType;
  bool _StaffLoading = false;
  List<StaffType> stafftypelist = [];

  List finalSelectList = [];
  List allFlatList = [];
  List allWingList = [];

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    _StaffType();
    _getLocaldata();
    _WingListData();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
  }

  DateTime SelectedDOB = DateTime.now();
  DateTime SelectedDOJ = DateTime.now();

  Future<Null> _selectDOB(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: SelectedDOB,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2050));
    if (picked != null && picked != SelectedDOB)
      setState(() {
        SelectedDOB = picked;
      });
  }

  Future<Null> _selectedDOJ(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: SelectedDOJ,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2050));
    if (picked != null && picked != SelectedDOJ)
      setState(() {
        SelectedDOJ = picked;
      });
  }

  _WingListData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetWinglistData(SocietyId);
        setState(() {
          _WingLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _WingLoading = false;
              wingclasslist = data;
            });
          } else {
            setState(() {
              _WingLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            _WingLoading = false;
          });
          Fluttertoast.showToast(
              msg: "Something Went Wrong", toastLength: Toast.LENGTH_LONG);
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _WingLoading = false;
      });
      Fluttertoast.showToast(
          msg: "No Internet Access", toastLength: Toast.LENGTH_LONG);
    }
  }

  _StaffType() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getRoleType();
        setState(() {
          _StaffLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _StaffLoading = false;
              stafftypelist = data;
            });
          } else {
            setState(() {
              _StaffLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            _StaffLoading = false;
          });
          Fluttertoast.showToast(
              msg: "Something Went Wrong", toastLength: Toast.LENGTH_LONG);
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _WingLoading = false;
      });
      Fluttertoast.showToast(
          msg: "No Internet Access", toastLength: Toast.LENGTH_LONG);
    }
  }

  showMsg(String msg, {String title = 'My JINI'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

  _SaveStaff() async {
    if (txtName.text != "" && staffType != null) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          String SocietyId = preferences.getString(Session.SocietyId);

          var formData = {
            "Id": "0",
            "SocietyId": SocietyId,
            "Name": txtName.text,
            "ContactNo": txtContactNo.text,
            "Work": worktext.text,
            "VehicleNo": vehiclenotext.text,
            "DateOfBirth": SelectedDOB.toString(),
            "DateOfJoin": SelectedDOJ.toString(),
            "DateOfJoin": SelectedDOJ.toString(),
            "RecruitType": SelectType,
            "AgencyName": txtagencyname.text,
            "AadharCardNo": adharnumbertxt.text,
            "VoterId": txtvoterId.text,
            "EmergencyContactNo": txtemergencyNo.text,
            "Gender": Gender,
            "VehicleNo": vehiclenotext.text,
            "Address": txtaddress.text,
            "RoleId": staffType.TypeId,
            "works": finalSelectList,
            //"WorkId": ,
          };

          print(formData);

          pr.show();
          Services.Savestaff(formData).then((data) async {
            pr.hide();
            if (data.Data != "0" && data.IsSuccess == true) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/WatchmanDashboard', (Route<dynamic> route) => false);
            } else {
              pr.hide();
              showMsg(data.Message, title: "Error");
            }
          }, onError: (e) {
            pr.hide();
            showMsg("Try Again.");
          });
        }
      } on SocketException catch (_) {
        pr.hide();
        showMsg("No Internet Connection.");
      }
    } else
      Fluttertoast.showToast(
          msg: "Please Fill All Fields",
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP,
          textColor: Colors.white);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Staff",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _image == null
                                    ? Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                            image: new DecorationImage(
                                                image: AssetImage(
                                                    'images/user.png'),
                                                fit: BoxFit.cover),
                                            borderRadius: BorderRadius.all(
                                                new Radius.circular(75.0)),
                                            border: Border.all(
                                                width: 2.5,
                                                color: Colors.white)),
                                      )
                                    : Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                            image: new DecorationImage(
                                                image: FileImage(_image),
                                                fit: BoxFit.cover),
                                            borderRadius: BorderRadius.all(
                                                new Radius.circular(75.0)),
                                            border: Border.all(
                                                width: 2.5,
                                                color: Colors.white)),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, top: 10.0),
                              child: Text(
                                "Select StaffType",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0))),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButtonHideUnderline(
                                      child: DropdownButton<StaffType>(
                                    icon: Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                    ),
                                    hint: stafftypelist.length > 0
                                        ? Text("Select Staff Type",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600))
                                        : Text(
                                            "staff Type Not Found",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                    value: staffType,
                                    onChanged: (val) {
                                      print(val.TypeName);
                                      setState(() {
                                        staffType = val;
                                      });
                                    },
                                    items: stafftypelist
                                        .map((StaffType stafftype) {
                                      return new DropdownMenuItem<StaffType>(
                                        value: stafftype,
                                        child: Text(
                                          stafftype.TypeName,
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: txtName,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelText: "Staff Name",
                                  hasFloatingPlaceholder: true,
                                  labelStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: txtContactNo,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
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
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: txtemergencyNo,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  counterText: "",
                                  labelText: "Emergency Contact Number",
                                  hasFloatingPlaceholder: true,
                                  labelStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              inputFormatters: [
                                MaskedTextInputFormatter(
                                  mask: 'xx-xx-xx-xxxx',
                                  separator: '-',
                                ),
                              ],
                              controller: vehiclenotext,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
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
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: worktext,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  counterText: "",
                                  labelText: "Enter Work",
                                  hasFloatingPlaceholder: true,
                                  labelStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: txtaddress,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelText: "Staff Address",
                                  hasFloatingPlaceholder: true,
                                  labelStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, top: 6.0),
                              child: Text(
                                "Gender",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                                value: 'Male',
                                groupValue: Gender,
                                onChanged: (value) {
                                  setState(() {
                                    Gender = value;
                                    print(Gender);
                                  });
                                }),
                            Text("Male", style: TextStyle(fontSize: 13)),
                            Radio(
                                value: 'Female',
                                groupValue: Gender,
                                onChanged: (value) {
                                  setState(() {
                                    Gender = value;
                                    print(Gender);
                                  });
                                }),
                            Text("Female", style: TextStyle(fontSize: 13)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Text(
                                      "Select DOB",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _selectDOB(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, right: 4.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.black54),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Center(
                                          child: Text(
                                            '${SelectedDOB.toLocal()}'
                                                .split(' ')[0],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12.0, right: 2),
                                    child: Text(
                                      "Select Date Of Join",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _selectedDOJ(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10.0,
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.black54),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Center(
                                          child: Text(
                                            '${SelectedDOJ.toLocal()}'
                                                .split(' ')[0],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, top: 6.0),
                              child: Text(
                                "RecruitType",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                                value: 'Through Agency',
                                groupValue: SelectType,
                                onChanged: (value) {
                                  setState(() {
                                    SelectType = value;
                                    print(SelectType);
                                  });
                                }),
                            Text("Through Agency",
                                style: TextStyle(fontSize: 13)),
                            Radio(
                                value: 'Through Society',
                                groupValue: SelectType,
                                onChanged: (value) {
                                  setState(() {
                                    SelectType = value;
                                    print(SelectType);
                                  });
                                }),
                            Text("Through Society",
                                style: TextStyle(fontSize: 13)),
                          ],
                        ),
                        SelectType == 'Through Agency'
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 4.0, left: 4.0, right: 4.0),
                                child: SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    controller: txtagencyname,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          borderSide: new BorderSide(),
                                        ),
                                        labelText: "Agency Name",
                                        hasFloatingPlaceholder: true,
                                        labelStyle: TextStyle(fontSize: 13)),
                                  ),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, right: 4.0, left: 4.0),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              inputFormatters: [
                                MaskedTextInputFormatter(
                                  mask: 'xxxx-xxxx-xxxx-xxxx',
                                  separator: '-',
                                ),
                              ],
                              controller: adharnumbertxt,
                              keyboardType: TextInputType.number,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  counterText: "",
                                  labelText: "Enter Adhar No Number",
                                  hintText: "xxxx-xxxx-xxxx-xxxx",
                                  hasFloatingPlaceholder: true,
                                  labelStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: txtvoterId,
                              keyboardType: TextInputType.text,
                              maxLength: 10,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  counterText: "",
                                  labelText: "Voter Id",
                                  hasFloatingPlaceholder: true,
                                  labelStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 10.0),
                              child: Text(
                                "Select Wing",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0))),
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
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600))
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
                                    items: wingclasslist
                                        .map((WingClass wingclass) {
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
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white),
                                  ),
                                  onPressed: () {
                                    if (!allWingList.contains(wingClass)) {
                                      for (int i = 0;
                                          i < _selectedFlatlist.length;
                                          i++) {
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
                                      int index =
                                          allWingList.indexOf(wingClass);
                                      print(index);
                                      setState(() {
                                        allWingList.removeAt(index);
                                        allFlatList.removeAt(index);
                                      });
                                      for (int i = 0;
                                          i < _selectedFlatlist.length;
                                          i++) {
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
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 45,
          child: MaterialButton(
            color: constant.appPrimaryMaterialColor,
            minWidth: MediaQuery.of(context).size.width - 20,
            onPressed: () {
              _SaveStaff();
            },
            child: Text(
              "Add Staff",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
