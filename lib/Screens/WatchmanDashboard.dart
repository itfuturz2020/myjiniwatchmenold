import 'dart:async';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietystaff/Common/Constants.dart';
import 'package:smartsocietystaff/Common/Services.dart';
import 'package:smartsocietystaff/Component/masktext.dart';
import 'package:smartsocietystaff/Screens/AddVisitorForm.dart';
import 'package:smartsocietystaff/Screens/EnterCodeScanScreen.dart';
import 'package:smartsocietystaff/Common/Constants.dart' as constant;
import 'package:smartsocietystaff/Screens/FreqVisitorlist.dart';
import 'package:smartsocietystaff/Screens/Visitor.dart';
import 'package:smartsocietystaff/Screens/watchmanVisitorList.dart';

class WatchmanDashboard extends StatefulWidget {
  @override
  _WatchmanDashboardState createState() => _WatchmanDashboardState();
}

class _WatchmanDashboardState extends State<WatchmanDashboard> {
  DateTime currentBackPressTime;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamSubscription iosSubscription;
  ProgressDialog pr;
  bool isLoading = false;
  List _visitordata = [];

  String barcode = "";
  String fcmToken = "";
  TextEditingController txtvehicle = new TextEditingController();

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
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
    if (Platform.isIOS) {
      iosSubscription =
          _firebaseMessaging.onIosSettingsRegistered.listen((data) {
        print("FFFFFFFF" + data.toString());
        saveDeviceToken();
      });
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    } else {
      saveDeviceToken();
    }
  }

  saveDeviceToken() async {
    _firebaseMessaging.getToken().then((String token) {
      print("Original Token:$token");
      setState(() {
        fcmToken = token;
        sendFCMTokan(token);
      });
      print("FCM Token : $token");
    });
  }

  sendFCMTokan(var FcmToken) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.SendTokanToServer(FcmToken);
        res.then((data) async {}, onError: (e) {
          print("Error : on Login Call");
        });
      }
    } on SocketException catch (_) {}
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press Back Again to Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  // Overridden methods

  // API List

  // _getVisitorData(String VisitorId, String type) async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       SharedPreferences preferences = await SharedPreferences.getInstance();
  //       String SocietyId = preferences.getString(Session.SocietyId);
  //       pr.show();
  //       Future res =
  //           Services.getScanVisitorByQR_or_Code(SocietyId, type, "", VisitorId);
  //       setState(() {
  //         isLoading = true;
  //       });
  //       res.then((data) async {
  //         pr.hide();
  //         if (data != null && data.length > 0) {
  //           setState(() {
  //             _visitordata = data;
  //             isLoading = false;
  //           });
  //           _showVisitorData(data);
  //         } else {
  //           setState(() {
  //             _visitordata = data;
  //             isLoading = false;
  //           });
  //           //showMsg("Data Not Found");
  //         }
  //       }, onError: (e) {
  //         pr.hide();
  //         showMsg("Something Went Wrong Please Try Again");
  //         setState(() {
  //           isLoading = false;
  //         });
  //       });
  //     } else {
  //       showMsg("No Internet Connection.");
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } on SocketException catch (_) {
  //     pr.hide();
  //     showMsg("No Internet Connection.");
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
  _getVisitorData(String VisitorId, String type) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String SocietyId = preferences.getString(Session.SocietyId);
        pr.show();
        Future res = Services.getScanVisitorByQR_or_Code(
            SocietyId, type, "0", VisitorId);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          pr.hide();
          if (data != null && data.length > 0) {
            setState(() {
              _visitordata = data;
              isLoading = false;
            });
            _showVisitorData(data);
          } else {
            setState(() {
              _visitordata = data;
              isLoading = false;
            });
            //showMsg("Data Not Found");
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Something Went Wrong Please Try Again");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
        setState(() {
          isLoading = false;
        });
      }
    } on SocketException catch (_) {
      pr.hide();
      showMsg("No Internet Connection.");
      setState(() {
        isLoading = false;
      });
    }
  }
  _addVisitorEntry() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String SocietyId = preferences.getString(Session.SocietyId);

        pr.show();

        print('_visitordata[0]["lastentry"].toString().isNotEmpty');
        print(_visitordata[0]["lastentry"].isNotEmpty);
        var formData = {
          "Id": "0",
          "SocietyId": SocietyId,
          "TypeId": _visitordata[0]["lastentry"].isNotEmpty  ?  _visitordata[0]["lastentry"]["TypeId"] : "",
          "Type": _visitordata[0]["lastentry"].isNotEmpty ? _visitordata[0]["lastentry"]["Type"] : "",
          "Purpose": "",
          "VehicleNo": txtvehicle.text,
          "WorkId": _visitordata[0]["worklist"]
        };

        Services.CheckInVisitorStaff(formData).then((data) async {
          pr.hide();
          if (data.Data != "0" && data.IsSuccess == true) {
            Fluttertoast.showToast(
                msg: "Visitor CheckIn Successfully",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                textColor: Colors.white);
          } else {
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
  }

  showMsg(String msg, {String title = 'My JINI'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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

  // Future scan() async {
  //   try {
  //     String barcode = await BarcodeScanner.scan();
  //     print(barcode);
  //     var data = barcode.split(",");
  //     if (barcode != null) {
  //       _getVisitorData(data[0], data[1]);
  //     } else
  //       showMsg("Try Again..");
  //   } on PlatformException catch (e) {
  //     if (e.code == BarcodeScanner.CameraAccessDenied) {
  //       setState(() {
  //         this.barcode = 'The user did not grant the camera permission!';
  //       });
  //     } else {
  //       setState(() => this.barcode = 'Unknown error: $e');
  //     }
  //   } on FormatException {
  //     setState(() => this.barcode =
  //         'null (User returned using the "back"-button before scanning anything. Result)');
  //   } catch (e) {
  //     setState(() => this.barcode = 'Unknown error: $e');
  //   }
  // }
  Future scan() async {
    String defaultType = "Visitor";
    try {
      String barcode = await BarcodeScanner.scan();
      print(barcode);
      var data = barcode.split(",");
      print(data[0]);
      print(data[1]);
      print(data[1].runtimeType);
      if (barcode != null) {
        if (data[1].isEmpty == true) {
          _getVisitorData(data[0], defaultType);
        } else {
          _getVisitorData(data[0], data[1]);
        }
      } else
        showMsg("Try Again..");
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
      'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
 /* void _showVisitorData(data) {

    showDialog(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          elevation: 0,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
                child: ClipOval(
                    child: FadeInImage.assetNetwork(
                        placeholder: 'images/Logo.png',
                        image: constant.IMG_URL + "${data[0]["Image"]}",
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill)),
              ),
              Text(
                "${data[0]["Name"]}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700]),
              ),
              Text(
                "${data[0]["ContactNo"]}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700]),
              ),
              Divider(
                color: Colors.grey[300],
                endIndent: 10,
                indent: 10,
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
//                        Text(
//                          "VisitorType",
//                          style: TextStyle(
//                              fontSize: 12,
//                              fontWeight: FontWeight.w600,
//                              color: Colors.grey[700]),
//                        ),
//                        Text(
//                          "${data[0]["VisitorTypeName"]}",
//                          style: TextStyle(
//                              fontSize: 13,
//                              fontWeight: FontWeight.w400,
//                              color: Colors.grey[700]),
//                        ),
                      ],
                    ),
                   *//* Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Company\n Name",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700]),
                            ),
                            Text(
                              "${data[0]["CompanyName"]}",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ],
                    )*//*
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Row(
                  children: <Widget>[
                   *//* Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Purpose of Visit",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700]),
                        ),
                        Text(
                          "${data[0]["Purpose"]}",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ),*//*
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 50,
                  width: 150,
                  color: Colors.grey[200],
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Vehicle No",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700]),
                          ),
                        ),
                        Text(
                          "${data[0]["VehicleNo"]}",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  RaisedButton(
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.green,
                      onPressed: () {
                        Navigator.pop(context);
                        _addVisitorEntry();
                      })
                ],
              )
            ],
          ),
        );
      },
    );
  }*/

  // void _showVisitorData(data) {
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //
  //       return Dialog(
  //         child: SingleChildScrollView(
  //           child: Column(
  //             children: <Widget>[
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: ClipOval(
  //                     child: FadeInImage.assetNetwork(
  //                         placeholder: 'images/Logo.png',
  //                         image: constant.IMG_URL + "${data[0]["Image"]}",
  //                         width: 100,
  //                         height: 100,
  //                         fit: BoxFit.fill)),
  //               ),
  //               Text(
  //                 "${data[0]["Name"]}",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.grey[700]),
  //               ),
  //               Text(
  //                 "${data[0]["Role"]}",
  //                 style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w400,
  //                     color: Colors.grey[700]),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(10.0),
  //                 child: SizedBox(
  //                   height: 50,
  //                   child: TextFormField(
  //                     inputFormatters: [
  //                       MaskedTextInputFormatter(
  //                         mask: 'xx-xx-xx-xxxx',
  //                         separator: '-',
  //                       ),
  //                     ],
  //                     controller: txtvehicle,
  //                     keyboardType: TextInputType.text,
  //                     textCapitalization: TextCapitalization.characters,
  //                     decoration: InputDecoration(
  //                         border: new OutlineInputBorder(
  //                           borderRadius: new BorderRadius.circular(5.0),
  //                           borderSide: new BorderSide(),
  //                         ),
  //                         counterText: "",
  //                         labelText: "Enter Vehicle Number",
  //                         hintText: "XX-00-XX-0000",
  //                         hasFloatingPlaceholder: true,
  //                         labelStyle: TextStyle(fontSize: 13)),
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: <Widget>[
  //                     RaisedButton(
  //                         child: Text(
  //                           "Cancel",
  //                           style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
  //                         ),
  //                         color: Colors.red[600],
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                         }),
  //                     RaisedButton(
  //                         child: Text(
  //                           "Check In",
  //                           style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
  //                         ),
  //                         color: Colors.green,
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                           _addVisitorEntry();
  //                         })
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  void _showVisitorData(data) {
    // print('ssssssssssssssss${data[0]["Role"].runtimeType}');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                      child: FadeInImage.assetNetwork(
                          placeholder: 'images/Logo.png',
                          image: constant.IMG_URL + "${data[0]["Image"]}",
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill)),
                ),
                Text(
                  "${data[0]["Name"]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]),
                ),
                Text(
                  (data[0]["Role"] != null) ? "${data[0]["Role"]}" : "Visitor",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700]),
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
                      controller: txtvehicle,
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
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          color: Colors.red[600],
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              txtvehicle.text = '';
                            });
                          }),
                      RaisedButton(
                          child: Text(
                            "Check In",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          color: Colors.green,
                          onPressed: () {
                            Navigator.pop(context);
                            _addVisitorEntry();
                            setState(() {
                              txtvehicle.text = '';
                            });
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
        onWillPop: onWillPop,
        child: DefaultTabController(
          length: 3,
          child: new Scaffold(
              appBar: new AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: constant.appPrimaryMaterialColor,
                flexibleSpace: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    new TabBar(
                      tabs: [
                        Tab(
                          child: Column(
                            children: <Widget>[
                              new Icon(Icons.keyboard, size: 20),
                              new SizedBox(
                                width: 5.0,
                              ),
                              new Text(
                                "${AppLocalizations.of(context).tr('EnterCode')}",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            children: <Widget>[
                              new Icon(
                                Icons.person,
                                size: 20,
                              ),
                              new SizedBox(
                                width: 5.0,
                              ),
                              new Text(
                                "${AppLocalizations.of(context).tr('FeqVisitor')}",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            children: <Widget>[
                              new Icon(
                                Icons.people,
                                size: 20,
                              ),
                              new SizedBox(
                                width: 5.0,
                              ),
                              new Text(
                                "${AppLocalizations.of(context).tr('Visitor')}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    EnterCodeScanScreen(data),
                    FreqVisitorlist(),
                    visitorlist(),
                  ]),
              bottomNavigationBar: Container(
                height: 60,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.person_add),
                              Text(
                                  "${AppLocalizations.of(context).tr('AddVisitor')}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11))
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/AddVisitorForm');
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'images/scanner.png',
                                width: 24,
                                height: 24,
                              ),
                              Text(
                                  "${AppLocalizations.of(context).tr('ScanCode')}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11))
                            ],
                          ),
                          onTap: () {
                            scan();
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.supervised_user_circle),
                              Text(
                                  "${AppLocalizations.of(context).tr('Staffs')}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11))
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/StaffList');
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
