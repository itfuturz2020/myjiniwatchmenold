import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietystaff/Common/ClassList.dart';
import 'package:smartsocietystaff/Common/Constants.dart';
import 'package:smartsocietystaff/Common/Services.dart';
import 'package:smartsocietystaff/Component/masktext.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:smartsocietystaff/Common/Constants.dart' as constant;

class AddVisitorForm extends StatefulWidget {
  String visitortype;

  AddVisitorForm({this.visitortype});

  @override
  _AddVisitorFormState createState() => _AddVisitorFormState();
}

class _AddVisitorFormState extends State<AddVisitorForm> {
  int step = 1;
  File _image;
  SpeechRecognition _speechRecognitionName = new SpeechRecognition();
  SpeechRecognition _speechRecognitionPurpose = new SpeechRecognition();
  TextEditingController resultText = new TextEditingController();
  TextEditingController mobilenotext = new TextEditingController();
  TextEditingController vehiclenotext = new TextEditingController();
  TextEditingController purposeText = new TextEditingController();
  PermissionStatus _permissionStatus = PermissionStatus.unknown;

  int selected_Index;

  String _selectedCompanyName;
  String _selectedCompanyLogo;

  String vehicleNumber = "";

  String _selectedVisitorType;
  String _selectedVisitorIcon;
  int _selectedvisitorId;
  String _FlateNo;
  String MemberId;

  bool isLoading = false;
  List WingData = new List();
  String SocietyId, WatchManId;
  bool _WingLoading = false;
  List VisitorTypeData = new List();
  List FlatData = new List();
  List CompanyData = new List();
  ProgressDialog pr;

  List<WingClass> _winglist = [];
  WingClass _wingClass;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(step.toString());
    initSpeechRecognizer();
    // initSpeechRecognizer2();
    _getLocaldata();
    _WingListData();
    GetVisitorType();

    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait..",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
              //backgroundColor: cnst.appPrimaryMaterialColor,
              ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
    WatchManId = prefs.getString(constant.Session.MemberId);
  }

  Widget numberKeyboard() {
    return TextFormField(
      inputFormatters: [
        MaskedTextInputFormatter(
          mask: 'xx-xx-xx-xxxx',
          separator: '-',
        ),
      ],
      onChanged: (value) {
        print(value.length);
        setState(() {
          vehicleNumber = value;
        });
      },
      initialValue: vehicleNumber,
      keyboardType: TextInputType.number,
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
    );
  }

  Widget textKeyboard() {
    return TextFormField(
      inputFormatters: [
        MaskedTextInputFormatter(
          mask: 'xx-xx-xx-xxxx',
          separator: '-',
        ),
      ],
      onChanged: (value) {
        print(value.length);
        setState(() {
          vehicleNumber = value;
        });
      },
      initialValue: vehicleNumber,
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
    );
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
              _winglist = data;
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

  _OnWingSelect(val) {
    setState(() {
      print(val.WingName);
      _wingClass = val;
    });
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

  SaveVisitorData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (_wingClass != null) {
          if (resultText.text != "" && mobilenotext.text != "") {
            pr.show();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String SocietyId = prefs.getString(constant.Session.SocietyId);
            String filename = "";
            String filePath = "";
            File compressedFile;

            if (_image != null) {
              ImageProperties properties =
                  await FlutterNativeImage.getImageProperties(_image.path);

              compressedFile = await FlutterNativeImage.compressImage(
                _image.path,
                quality: 80,
                targetWidth: 600,
                targetHeight:
                    (properties.height * 600 / properties.width).round(),
              );

              filename = _image.path.split('/').last;
              filePath = compressedFile.path;
            }

            String code = "";

            var rnd = new Random();
            setState(() {
              code = "";
            });
            for (var i = 0; i < 4; i++) {
              code = code + rnd.nextInt(9).toString();
            }

            FormData formData = new FormData.fromMap({
              "Id": 0,
              "Name": resultText.text,
              "SocietyId": SocietyId,
              "ContactNo": mobilenotext.text,
              "MSId": "",
              "CompanyName": _selectedCompanyName,
              "VisitorTypeId": _selectedvisitorId.toString(),
              "Purpose": purposeText.text,
              "VehicleNo": vehiclenotext.text,
              "WingId": _wingClass.WingId,
              "FlatId": _FlateNo,
              "AddedBy": "Security",
              "Image": (filePath != null && filePath != '')
                  ? await MultipartFile.fromFile(filePath,
                      filename: filename.toString())
                  : null,
              "CompanyImage": _selectedCompanyLogo,
              "WatchmanId": WatchManId
            });

            print("Save visitorData Data = ${formData.fields}");
           Services.SaveVisitorsV1(formData).then((data) async {
              pr.hide();
              if (data.Data != "0" && data.IsSuccess == true) {
                print("smit watchman1 ${data.Data}");
                SharedPreferences preferences = await SharedPreferences.getInstance();
                await preferences.setString('data', data.Data);
                showMsg(data.Message, title: "Success");
              } else {
                showMsg(data.Message, title: "Error");
              }
            }, onError: (e) {
              pr.hide();
              showMsg("Try Again.");
            });
          } else
            Fluttertoast.showToast(
                msg: "name or contact number can't be empty",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                gravity: ToastGravity.TOP);
        } else
          Fluttertoast.showToast(
              msg: "Please Select Wing",
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              toastLength: Toast.LENGTH_LONG);
      } else
        showMsg("No Internet Connection.");
    } on SocketException catch (_) {
      pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg, {String title = 'My JINI'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Image.asset(
            'images/success.png',
            width: 60,
            height: 60,
          ),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/WatchmanDashboard', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[
      PermissionGroup.microphone
    ];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);

    setState(() {
      print(permissionRequestResult);
      _permissionStatus = permissionRequestResult[permission];
      print(_permissionStatus);
    });
    if (permissionRequestResult[permission] == PermissionStatus.granted) {
    } else
      Fluttertoast.showToast(
          msg: "Permission Not Granted",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT);
  }

  initSpeechRecognizer() {
    _speechRecognitionName.setRecognitionResultHandler(
      (String speech) => setState(() => resultText.text = speech),
    );
  }

  // initSpeechRecognizer2() {
  //   _speechRecognitionPurpose.setRecognitionResultHandler(
  //     (String speech) => setState(() => purposeText.text = speech),
  //   );
  // }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  get visitortype {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            "Visitor Type",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          onTap: () {
            _visitorTypeSelection(context);
          },
          child: Card(
            elevation: 2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _selectedVisitorIcon != ""
                          ? Image.network('$_selectedVisitorIcon')
                          : Image.asset(
                              'images/noimg.png',
                              width: 50,
                              height: 50,
                            )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _selectedVisitorType == null
                            ? 'Select Visitor Type'
                            : '$_selectedVisitorType',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right)
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            "Company Name",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          onTap: () {
            if (CompanyData.length > 0) {
              _companySelectBottomSheet(context);
            } else
              GetCompanyName();
          },
          child: Card(
            elevation: 2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Image.network('$IMG_URL' + '$_selectedCompanyLogo')),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _selectedCompanyName == null
                            ? 'Select Company Name'
                            : '$_selectedCompanyName',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right)
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            "Photo & Name",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          onTap: () {
            _selectedVisitorIcon == null ||
                    _selectedVisitorIcon == "" &&
                        _selectedVisitorType == null ||
                    _selectedVisitorType == ""
                ? Fluttertoast.showToast(
                    msg: "Please Select Visitor Type",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0)
                : setState(() {
                    step = 2;
                  });
          },
          child: Card(
            elevation: 2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.person_add)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Visitor Photo & Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  get photoname {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      setState(() {
                        step = 1;
                      });
                    })
              ],
            ),
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
                                    image: AssetImage('images/user.png'),
                                    fit: BoxFit.cover),
                                borderRadius:
                                    BorderRadius.all(new Radius.circular(75.0)),
                                border: Border.all(
                                    width: 2.5, color: Colors.white)),
                          )
                        : Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                                image: new DecorationImage(
                                    image: FileImage(_image),
                                    fit: BoxFit.cover),
                                borderRadius:
                                    BorderRadius.all(new Radius.circular(75.0)),
                                border: Border.all(
                                    width: 2.5, color: Colors.white)),
                          ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: resultText,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                      counterText: "",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.mic),
                        onPressed: () {
                          requestPermission(PermissionGroup.microphone);
                          _speechRecognitionName
                              .listen(locale: "en_US")
                              .then((result) => print('####-$result'));
                        },
                      ),
                      labelText: "Visitor Name",
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
                  controller: mobilenotext,
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
                child: vehicleNumber.length >= 3
                    ? numberKeyboard()
                    : textKeyboard(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: purposeText,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                      // suffixIcon: IconButton(
                      //   icon: Icon(Icons.mic),
                      //   onPressed: () {
                      //     requestPermission(PermissionGroup.microphone);
                      //     _speechRecognitionPurpose
                      //         .listen(locale: "en_US")
                      //         .then((result) => print('$result'));
                      //   },
                      // ),
                      counterText: "",
                      labelText: "Purpose of Visitor",
                      hasFloatingPlaceholder: true,
                      labelStyle: TextStyle(fontSize: 13)),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                      child: Text(
                        "Select Wing",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<WingClass>(
                            icon: Icon(
                              Icons.chevron_right,
                              size: 20,
                            ),
                            hint: _winglist != null &&
                                    _winglist != "" &&
                                    _winglist.length > 0
                                ? Text("Select Wing",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600))
                                : Text(
                                    "Wing Not Found",
                                    style: TextStyle(fontSize: 14),
                                  ),
                            value: _wingClass,
                            onChanged: (val) {
                              _OnWingSelect(val);
                              GetFlatData(_wingClass.WingId);
                            },
                            items: _winglist.map((WingClass wingclass) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                      child: Text(
                        "Select Flat",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          border: Border.all(color: Colors.black)),
                      width: 120,
                      height: 50,
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              _FlateNo == "" || _FlateNo == null
                                  ? 'Flat No'
                                  : '$_FlateNo',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 18,
                          )
                        ],
                      )),
                    )
                  ],
                )
              ],
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
                            "Save Visitor",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      color: Colors.green,
                      onPressed: () {
                        SaveVisitorData();
                      })),
            ),
          ],
        ),
      ),
    );
  }

  setdata(data) {
    for (int i = 0; i < data.length; i++) {
      if (data[i]["VisitorTypeName"] == 'Courier/ Delivery Boy') {
        setState(() {
          _selectedVisitorType = VisitorTypeData[i]["VisitorTypeName"];
          _selectedVisitorIcon = IMG_URL + VisitorTypeData[i]["Icon"];
          _selectedvisitorId = VisitorTypeData[i]["Id"];
        });
      }
    }
  }

  GetVisitorType() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          pr.show();
        });

        Services.getVisitorType('Visitor').then((data) async {
          setState(() {
            pr.hide();
          });
          if (data != null && data.length > 0) {
            setState(() {
              VisitorTypeData = data;
            });
            _visitorTypeSelection(context);
            if (widget.visitortype != null) setdata(data);
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
            _flatSelectionBottomsheet(context);
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

  GetCompanyName() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          pr.show();
        });

        Services.getCompanyName().then((data) async {
          setState(() {
            pr.hide();
          });
          if (data != null && data.length > 0) {
            setState(() {
              CompanyData = data;
            });
            _companySelectBottomSheet(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Visitor",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      body: step == 1 ? visitortype : photoname,
    );
  }

  _visitorTypeSelection(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Select Visitor Type",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: VisitorTypeData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              if (VisitorTypeData.length > 0) {
                                setState(() {
                                  _selectedVisitorType =
                                      VisitorTypeData[index]["VisitorTypeName"];
                                  _selectedVisitorIcon = VisitorTypeData[index]
                                              ["Icon"] !=
                                          null
                                      ? IMG_URL + VisitorTypeData[index]["Icon"]
                                      : "";
                                  _selectedvisitorId =
                                      VisitorTypeData[index]["Id"];
                                });
                                Navigator.pop(context);
                              } else
                                GetVisitorType();
                            },
                            child: Card(
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child:
                                          VisitorTypeData[index]["Icon"] != null
                                              ? Image.network(
                                                  '${IMG_URL}' +
                                                      '${VisitorTypeData[index]["Icon"]}',
                                                  width: 50,
                                                  height: 50,
                                                )
                                              : Image.asset(
                                                  'images/noimg.png',
                                                  width: 60,
                                                  height: 60,
                                                ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        '${VisitorTypeData[index]["VisitorTypeName"]}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                        ;
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      )),
                )
              ],
            ),
          );
        });
  }

  _flatSelectionBottomsheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Select Flat",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: FlatData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: InkWell(
                          onTap: () {
                            if (FlatData.length > 0) {
                              setState(() {
                                _FlateNo = FlatData[index]["FlatNo"];
                                MemberId = FlatData[index]["MemberId"];
                              });
                              print(FlatData[index]["MemberId"].toString());
                              Navigator.pop(context);
                            }
                          },
                          child: Card(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      '${FlatData[index]["FlatNo"].toString()}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                      ;
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    )),
              )
            ],
          );
        });
  }

  _companySelectBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.grey[200],
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  " Select Company",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: CompanyData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                            if (CompanyData.length > 0) {
                              setState(() {
                                _selectedCompanyName =
                                    CompanyData[index]["CompanyName"];
                                _selectedCompanyLogo =
                                    CompanyData[index]["Image"];
                              });
                              print(_selectedCompanyLogo);
                              Navigator.pop(context);
                            } else {
                              GetCompanyName();
                            }
                          },
                          child: Card(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: CompanyData[index]["Image"] != null
                                        ? Image.network(
                                            '${IMG_URL}' +
                                                '${CompanyData[index]["Image"]}',
                                            height: 60,
                                            width: 60,
                                          )
                                        : Container(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      '${CompanyData[index]["CompanyName"]}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    )),
              )
            ],
          );
        });
  }
}
