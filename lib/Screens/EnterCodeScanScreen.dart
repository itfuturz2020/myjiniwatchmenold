// import 'dart:async';
// import 'dart:io';
//
// // import 'package:agora_rtc_engine/rtc_engine.dart';
//
// import 'package:easy_localization/easy_localization_provider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smartsocietystaff/Common/Constants.dart' as constant;
// import 'package:smartsocietystaff/Common/Constants.dart';
// import 'package:smartsocietystaff/Common/Services.dart';
// import 'package:smartsocietystaff/Common/call.dart';
// import 'package:smartsocietystaff/Common/join.dart';
// import 'package:smartsocietystaff/Component/masktext.dart';
//
// class EnterCodeScanScreen extends StatefulWidget {
//   var data;
//
//   EnterCodeScanScreen(this.data);
//
//   @override
//   _EnterCodeScanScreenState createState() => new _EnterCodeScanScreenState();
// }
//
// class _EnterCodeScanScreenState extends State<EnterCodeScanScreen>
//     with SingleTickerProviderStateMixin {
//   // Constants
//   final int time = 30;
//
//   ProgressDialog pr;
//
//   // Variables
//   Size _screenSize;
//   int _currentDigit;
//   int _firstDigit;
//   int _secondDigit;
//   int _thirdDigit;
//   int _fourthDigit;
//
//   bool isLoading = false;
//   List _visitordata = [];
//
//   String userName = "";
//   bool didReadNotifications = false;
//   int unReadNotificationsCount = 0;
//   TextEditingController txtvehicle = new TextEditingController();
//   TextEditingController txtpurpose = new TextEditingController();
//
//   final List<String> _visitorType = ["Visitor", "Staff"];
//
//   int selected_Index = 1;
//
//   //video call..............................
//   final _channelController = TextEditingController();
//   bool _validateError = false;
//   // ClientRole _role = ClientRole.Broadcaster;
//   //
//
//   @override
//   void initState() {
//     pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
//     pr.style(
//         message: "Please Wait",
//         borderRadius: 10.0,
//         progressWidget: Container(
//           padding: EdgeInsets.all(15),
//           child: CircularProgressIndicator(
//               //backgroundColor: cnst.appPrimaryMaterialColor,
//               ),
//         ),
//         elevation: 10.0,
//         insetAnimCurve: Curves.easeInOut,
//         messageTextStyle: TextStyle(
//             color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
//     super.initState();
//   }
//
//   void dispose() {
//     // dispose input controller
//     _channelController.dispose();
//     super.dispose();
//   }
//
//   get _getInputField {
//     return new Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         _otpTextField(_firstDigit),
//         _otpTextField(_secondDigit),
//         _otpTextField(_thirdDigit),
//         _otpTextField(_fourthDigit),
//       ],
//     );
//   }
//
//   void _showConfirmDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: new Text("My JINI"),
//           content: new Text("Are You Sure You Want To Logout ?"),
//           actions: <Widget>[
//             // usually buttons at the bottom of the dialog
//             new FlatButton(
//               child: new Text("No",
//                   style: TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.w600)),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             new FlatButton(
//               child: new Text("Yes",
//                   style: TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.w600)),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _logout();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   _logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.clear();
//     Navigator.pushReplacementNamed(context, "/Login");
//   }
//
//   get _getOtpKeyboard {
//     return new Container(
//         height: _screenSize.width - 80,
//         child: new Column(
//           children: <Widget>[
//             new Expanded(
//               child: new Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   _otpKeyboardInputButton(
//                       label: "1",
//                       onPressed: () {
//                         _setCurrentDigit(1);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "2",
//                       onPressed: () {
//                         _setCurrentDigit(2);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "3",
//                       onPressed: () {
//                         _setCurrentDigit(3);
//                       }),
//                 ],
//               ),
//             ),
//             new Expanded(
//               child: new Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   _otpKeyboardInputButton(
//                       label: "4",
//                       onPressed: () {
//                         _setCurrentDigit(4);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "5",
//                       onPressed: () {
//                         _setCurrentDigit(5);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "6",
//                       onPressed: () {
//                         _setCurrentDigit(6);
//                       }),
//                 ],
//               ),
//             ),
//             new Expanded(
//               child: new Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   _otpKeyboardInputButton(
//                       label: "7",
//                       onPressed: () {
//                         _setCurrentDigit(7);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "8",
//                       onPressed: () {
//                         _setCurrentDigit(8);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "9",
//                       onPressed: () {
//                         _setCurrentDigit(9);
//                       }),
//                 ],
//               ),
//             ),
//             new Expanded(
//               child: new Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   new SizedBox(
//                     width: 80.0,
//                   ),
//                   _otpKeyboardInputButton(
//                       label: "0",
//                       onPressed: () {
//                         _setCurrentDigit(0);
//                       }),
//                   _otpKeyboardActionButton(
//                       label: new Icon(
//                         Icons.backspace,
//                         color: constant.appPrimaryMaterialColor,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           if (_fourthDigit != null) {
//                             _fourthDigit = null;
//                           } else if (_thirdDigit != null) {
//                             _thirdDigit = null;
//                           } else if (_secondDigit != null) {
//                             _secondDigit = null;
//                           } else if (_firstDigit != null) {
//                             _firstDigit = null;
//                           }
//                         });
//                       }),
//                 ],
//               ),
//             ),
//           ],
//         ));
//   }
//
//   get _VerifyButton {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         SizedBox(
//           height: 45,
//           width: 150,
//           child: RaisedButton(
//               color: Colors.green,
//               child: Text(
//                 "Verify",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     fontSize: 18),
//               ),
//               onPressed: () {
//                 _getVisitorData('0',
//                     '${_firstDigit.toString() + _secondDigit.toString() + _thirdDigit.toString() + _fourthDigit.toString()}');
//               }),
//         )
//       ],
//     );
//   }
//
//   _getVisitorData(String visitorId, String UniqCode) async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         SharedPreferences preferences = await SharedPreferences.getInstance();
//         String SocietyId = preferences.getString(Session.SocietyId);
//         pr.show();
//         Future res = Services.getScanVisitorByQR_or_Code(
//             SocietyId, _visitorType[selected_Index], UniqCode, visitorId);
//         setState(() {
//           isLoading = true;
//         });
//         res.then((data) async {
//           pr.hide();
//           if (data != null && data.length > 0) {
//             setState(() {
//               _visitordata = data;
//               isLoading = false;
//               txtvehicle.text =
//                   data[0]["lastentry"] == null && data[0]["lastentry"] == ""
//                       ? data[0]["lastentry"]["VehicleNo"]
//                       : "";
//             });
//             if (selected_Index == 0)
//               _showVisitorData(data);
//             else
//               _showStaffData(data);
//           } else {
//             setState(() {
//               _visitordata = data;
//               isLoading = false;
//             });
//             showMsg("Code Is Incorrect");
//           }
//         }, onError: (e) {
//           pr.hide();
//           showMsg("Something Went Wrong Please Try Again");
//           setState(() {
//             isLoading = false;
//           });
//         });
//       } else {
//         showMsg("No Internet Connection.");
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } on SocketException catch (_) {
//       pr.hide();
//       showMsg("No Internet Connection.");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   showMsg(String msg, {String title = 'My JINI'}) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: new Text(title),
//           content: new Text(msg),
//           actions: <Widget>[
//             // usually buttons at the bottom of the dialog
//             new FlatButton(
//               child: new Text("Okay"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showVisitorData(data) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           elevation: 8,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ClipOval(
//                     child: data[0]["Image"] != "" && data[0]["Image"] != null
//                         ? FadeInImage.assetNetwork(
//                             placeholder: 'images/user.png',
//                             image: "${IMG_URL + data[0]["Image"]}",
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.fill)
//                         : Image.asset("images/user.png",
//                             width: 100, height: 100, fit: BoxFit.fill),
//                   ),
//                 ),
//                 Text(
//                   "${data[0]["Name"]}",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey[700]),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       "Visit At :  ",
//                       style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey[800]),
//                     ),
//                     Text(
//                       "${data[0]["worklist"][0]["WingName"]} - ${data[0]["worklist"][0]["FlatId"]}",
//                       style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey[800]),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: SizedBox(
//                     height: 50,
//                     child: TextFormField(
//                       inputFormatters: [
//                         MaskedTextInputFormatter(
//                           mask: 'xx-xx-xx-xxxx',
//                           separator: '-',
//                         ),
//                       ],
//                       controller: txtvehicle,
//                       keyboardType: TextInputType.text,
//                       textCapitalization: TextCapitalization.characters,
//                       decoration: InputDecoration(
//                           border: new OutlineInputBorder(
//                             borderRadius: new BorderRadius.circular(5.0),
//                             borderSide: new BorderSide(),
//                           ),
//                           counterText: "",
//                           labelText: "Enter Vehicle Number",
//                           hintText: "XX-00-XX-0000",
//                           hasFloatingPlaceholder: true,
//                           labelStyle: TextStyle(fontSize: 13)),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: <Widget>[
//                       RaisedButton(
//                           child: Text(
//                             "Cancel",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                           color: Colors.red[600],
//                           onPressed: () {
//                             Navigator.pop(context);
//                           }),
//                       RaisedButton(
//                           child: Text(
//                             "Check In",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                           color: Colors.green,
//                           onPressed: () {
//                             Navigator.pop(context);
//                             _addVisitorEntry();
//                           })
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _showStaffData(data) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           elevation: 8,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ClipOval(
//                       child: FadeInImage.assetNetwork(
//                           placeholder: 'images/Logo.png',
//                           image: constant.IMG_URL + "${data[0]["Image"]}",
//                           width: 100,
//                           height: 100,
//                           fit: BoxFit.fill)),
//                 ),
//                 Text(
//                   "${data[0]["Name"]}",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey[700]),
//                 ),
//                 Text(
//                   "${data[0]["Role"]}",
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.grey[700]),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: SizedBox(
//                     height: 50,
//                     child: TextFormField(
//                       inputFormatters: [
//                         MaskedTextInputFormatter(
//                           mask: 'xx-xx-xx-xxxx',
//                           separator: '-',
//                         ),
//                       ],
//                       controller: txtvehicle,
//                       keyboardType: TextInputType.text,
//                       textCapitalization: TextCapitalization.characters,
//                       decoration: InputDecoration(
//                           border: new OutlineInputBorder(
//                             borderRadius: new BorderRadius.circular(5.0),
//                             borderSide: new BorderSide(),
//                           ),
//                           counterText: "",
//                           labelText: "Enter Vehicle Number",
//                           hintText: "XX-00-XX-0000",
//                           hasFloatingPlaceholder: true,
//                           labelStyle: TextStyle(fontSize: 13)),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: <Widget>[
//                       RaisedButton(
//                           child: Text(
//                             "Cancel",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                           color: Colors.red[600],
//                           onPressed: () {
//                             Navigator.pop(context);
//                           }),
//                       RaisedButton(
//                           child: Text(
//                             "Check In",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                           color: Colors.green,
//                           onPressed: () {
//                             Navigator.pop(context);
//                             _addVisitorEntry();
//                           })
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   _addVisitorEntry() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         SharedPreferences preferences = await SharedPreferences.getInstance();
//         String SocietyId = preferences.getString(Session.SocietyId);
//
//         pr.show();
//
//         print(_visitordata[0]["worklist"]);
//
//         var formData = {
//           "Id": "0",
//           "SocietyId": SocietyId,
//           "TypeId": _visitordata[0]["Id"],
//           "Type": _visitorType[selected_Index],
//           "Purpose": "",
//           "VehicleNo": txtvehicle.text,
//           "WorkId": _visitordata[0]["worklist"]
//         };
//         print(formData);
//
//         Services.checkInVisitorOrStaff(formData).then((data) async {
//           pr.hide();
//           if (data.Data != "0" && data.IsSuccess == true) {
//             Fluttertoast.showToast(
//                 msg: "Visitor Entry Successfully inserted",
//                 backgroundColor: Colors.green,
//                 gravity: ToastGravity.TOP,
//                 textColor: Colors.white);
//             setState(() {
//               _firstDigit = null;
//               _secondDigit = null;
//               _thirdDigit = null;
//               _fourthDigit = null;
//             });
//           } else {
//             showMsg(data.Message, title: "Error");
//           }
//         }, onError: (e) {
//           pr.hide();
//           showMsg("Try Again.");
//         });
//       }
//     } on SocketException catch (_) {
//       pr.hide();
//       showMsg("No Internet Connection.");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _screenSize = MediaQuery.of(context).size;
//     return new Scaffold(
//       backgroundColor: Colors.white,
//       body: new Container(
//         width: _screenSize.width,
//         child: SingleChildScrollView(
//           child: new Column(
//             children: <Widget>[
//               Padding(padding: EdgeInsets.only(top: 10)),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.pushNamed(context, '/VisitorHistoryList');
//                           },
//                           child: Row(
//                             children: <Widget>[
//                               SizedBox(width: 10),
//                               Icon(Icons.search),
//                               SizedBox(width: 5),
//                               Expanded(child: Text("Search Visitor"))
//                             ],
//                           ),
//                         ),
//                         height: 45,
//                         decoration: BoxDecoration(
//                             color: Colors.grey[100],
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(6.0))),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                           child: Center(
//                             child: Icon(Icons.exit_to_app, color: Colors.red),
//                           ),
//                           decoration: BoxDecoration(
//                               color: Colors.red[100],
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(80.0))),
//                           height: 45,
//                           width: 45,
//                         ),
//                         Text("Logout",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 10))
//                       ],
//                     ),
//                     onTap: () {
//                       _showConfirmDialog();
//                     },
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 15, right: 15),
//                     child: PopupMenuButton<String>(
//                       onSelected: (String value) {
//                         if (value == "Hindi") {
//                           setState(() {
//                             widget.data.changeLocale(Locale("hi", "IN"));
//                           });
//                         } else if (value == "English") {
//                           setState(() {
//                             widget.data.changeLocale(Locale("en", "US"));
//                           });
//                         } else if (value == "Gujrati") {
//                           setState(() {
//                             widget.data.changeLocale(Locale("gu", "IN"));
//                           });
//                         } else if (value == "Marathi") {
//                           setState(() {
//                             widget.data.changeLocale(Locale("mr", "IN"));
//                           });
//                         }
//                       },
//                       tooltip: "Change Language",
//                       child: Icon(
//                         Icons.more_horiz,
//                         size: 30,
//                         color: constant.appPrimaryMaterialColor,
//                       ),
//                       itemBuilder: (BuildContext context) =>
//                           <PopupMenuEntry<String>>[
//                         const PopupMenuItem<String>(
//                           value: 'Hindi',
//                           child: Text(
//                             'हिंदी',
//                             style: TextStyle(
//                               fontSize: 13,
//                             ),
//                           ),
//                         ),
//                         const PopupMenuItem<String>(
//                           value: 'Gujrati',
//                           child: Text(
//                             'ગુજરાતી',
//                             style: TextStyle(
//                               fontSize: 13,
//                             ),
//                           ),
//                         ),
//                         const PopupMenuItem<String>(
//                           value: 'English',
//                           child: Text(
//                             'English',
//                             style: TextStyle(
//                               fontSize: 13,
//                             ),
//                           ),
//                         ),
//                         const PopupMenuItem<String>(
//                           value: 'Marathi',
//                           child: Text(
//                             'मराठी',
//                             style: TextStyle(
//                               fontSize: 13,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   // Expanded(
//                   //   child: Padding(
//                   //     padding: const EdgeInsets.all(8.0),
//                   //     child: TextField(
//                   //       controller: _channelController,
//                   //       decoration: InputDecoration(
//                   //         errorText: _validateError
//                   //             ? 'Channel name is mandatory'
//                   //             : null,
//                   //         border: UnderlineInputBorder(
//                   //           borderSide: BorderSide(width: 1),
//                   //         ),
//                   //         hintText: 'Channel name',
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: GestureDetector(
//                       onTap: onJoin,
//                       child: Column(
//                         children: <Widget>[
//                           Image.asset('images/video_call.png',
//                               width: 40, height: 40),
//                           Text(
//                             "VIDEO CALL",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600, fontSize: 12),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(padding: EdgeInsets.only(top: 25)),
//               _getInputField,
//               Padding(
//                 padding: const EdgeInsets.only(top: 15.0),
//                 child: Wrap(
//                   spacing: 10,
//                   children: List.generate(_visitorType.length, (index) {
//                     return ChoiceChip(
//                       backgroundColor: Colors.grey[200],
//                       label: Text(
//                         _visitorType[index],
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                       selected: selected_Index == index,
//                       onSelected: (selected) {
//                         if (selected) {
//                           setState(() {
//                             selected_Index = index;
//                             print(_visitorType[index]);
//                           });
//                         }
//                       },
//                     );
//                   }),
//                 ),
//               ),
//               Padding(padding: EdgeInsets.only(top: 25)),
//               _getOtpKeyboard,
//               Padding(padding: EdgeInsets.only(top: 40)),
//               _firstDigit != null &&
//                       _secondDigit != null &&
//                       _thirdDigit != null &&
//                       _fourthDigit != null
//                   ? _VerifyButton
//                   : Container()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Returns "Otp custom text field"
//   Widget _otpTextField(int digit) {
//     return new Container(
//       width: 35.0,
//       height: 45.0,
//       alignment: Alignment.center,
//       child: new Text(
//         digit != null ? digit.toString() : "",
//         style: new TextStyle(
//           fontSize: 30.0,
//           color: Colors.black,
//         ),
//       ),
//       decoration: BoxDecoration(
// //            color: Colors.grey.withOpacity(0.4),
//           border: Border(
//               bottom: BorderSide(
//         width: 2.0,
//         color: Colors.black,
//       ))),
//     );
//   }
//
//   // Returns "Otp keyboard input Button"
//   Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
//     return Padding(
//       padding: const EdgeInsets.all(3.0),
//       child: new Material(
//         color: Colors.grey[100],
//         child: new InkWell(
//           onTap: onPressed,
//           borderRadius: new BorderRadius.circular(40.0),
//           child: new Container(
//             height: 80.0,
//             width: 80.0,
//             decoration: new BoxDecoration(
//               shape: BoxShape.circle,
//             ),
//             child: new Center(
//               child: new Text(
//                 label,
//                 style: new TextStyle(
//                   fontSize: 30.0,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Returns "Otp keyboard action Button"
//   _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
//     return new InkWell(
//       onTap: onPressed,
//       borderRadius: new BorderRadius.circular(40.0),
//       child: new Container(
//         height: 80.0,
//         width: 80.0,
//         decoration: new BoxDecoration(
//           shape: BoxShape.circle,
//         ),
//         child: new Center(
//           child: label,
//         ),
//       ),
//     );
//   }
//
//   // Current digit
//   void _setCurrentDigit(int i) {
//     setState(() {
//       _currentDigit = i;
//       if (_firstDigit == null) {
//         _firstDigit = _currentDigit;
//       } else if (_secondDigit == null) {
//         _secondDigit = _currentDigit;
//       } else if (_thirdDigit == null) {
//         _thirdDigit = _currentDigit;
//       } else if (_fourthDigit == null) {
//         _fourthDigit = _currentDigit;
//       }
//     });
//   }
//
//   void clearOtp() {
//     _fourthDigit = null;
//     _thirdDigit = null;
//     _secondDigit = null;
//     _firstDigit = null;
//     setState(() {});
//   }
//
//   Future<void> onJoin() async {
//     // update input validation
//     // setState(() {
//     //   _channelController.text.isEmpty
//     //       ? _validateError = true
//     //       : _validateError = false;
//     // });
//     // if (_channelController.text.isNotEmpty) {
//       // await for camera and mic permissions before pushing video page
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => JoinPage(),
//         ),
//       );
//     // }
//   }
//
//   //for video call setings........................
//
//   // Future<void> onJoin() async {
//   //   // update input validation
//   //   setState(() {
//   //     _channelController.text.isEmpty
//   //         ? _validateError = true
//   //         : _validateError = false;
//   //   });
//   //   if (_channelController.text.isNotEmpty) {
//   //     // await for camera and mic permissions before pushing video page
//   //     await _handleCameraAndMic();
//   //     await Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) => CallPage(
//   //           channelName: _channelController.text,
//   //           role: _role,
//   //         ),
//   //       ),
//   //     );
//   //   }
//   // }
//
//   // Future<void> _handleCameraAndMic() async {
//   //   await PermissionHandler().requestPermissions(
//   //     [PermissionGroup.camera, PermissionGroup.microphone],
//   //   );
//   // }
// }
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietystaff/Common/Constants.dart' as constant;
import 'package:smartsocietystaff/Common/Constants.dart';
import 'package:smartsocietystaff/Common/Services.dart';
import 'package:smartsocietystaff/Common/join.dart';
import 'package:smartsocietystaff/Component/masktext.dart';

class EnterCodeScanScreen extends StatefulWidget {
  var data;

  EnterCodeScanScreen(this.data);

  @override
  _EnterCodeScanScreenState createState() => new _EnterCodeScanScreenState();
}

class _EnterCodeScanScreenState extends State<EnterCodeScanScreen>
    with SingleTickerProviderStateMixin {
  // Constants
  final int time = 30;

  ProgressDialog pr;

  // Variables
  Size _screenSize;
  int _currentDigit;
  int _firstDigit;
  int _secondDigit;
  int _thirdDigit;
  int _fourthDigit;

  bool isLoading = false;
  List _visitordata = [];

  String userName = "";
  bool didReadNotifications = false;
  int unReadNotificationsCount = 0;
  TextEditingController txtvehicle = new TextEditingController();
  TextEditingController txtpurpose = new TextEditingController();

  final List<String> _visitorType = ["Visitor", "Staff"];

  int selected_Index = 1;

  //video call..............................
  final _channelController = TextEditingController();
  bool _validateError = false;
  // ClientRole _role = ClientRole.Broadcaster;
  //

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
    super.initState();
  }

  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  get _getInputField {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _otpTextField(_firstDigit),
        _otpTextField(_secondDigit),
        _otpTextField(_thirdDigit),
        _otpTextField(_fourthDigit),
      ],
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("My JINI"),
          content: new Text("Are You Sure You Want To Logout ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacementNamed(context, "/Login");
  }

  get _getOtpKeyboard {
    return new Container(
        height: _screenSize.width - 80,
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "1",
                      onPressed: () {
                        _setCurrentDigit(1);
                      }),
                  _otpKeyboardInputButton(
                      label: "2",
                      onPressed: () {
                        _setCurrentDigit(2);
                      }),
                  _otpKeyboardInputButton(
                      label: "3",
                      onPressed: () {
                        _setCurrentDigit(3);
                      }),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "4",
                      onPressed: () {
                        _setCurrentDigit(4);
                      }),
                  _otpKeyboardInputButton(
                      label: "5",
                      onPressed: () {
                        _setCurrentDigit(5);
                      }),
                  _otpKeyboardInputButton(
                      label: "6",
                      onPressed: () {
                        _setCurrentDigit(6);
                      }),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "7",
                      onPressed: () {
                        _setCurrentDigit(7);
                      }),
                  _otpKeyboardInputButton(
                      label: "8",
                      onPressed: () {
                        _setCurrentDigit(8);
                      }),
                  _otpKeyboardInputButton(
                      label: "9",
                      onPressed: () {
                        _setCurrentDigit(9);
                      }),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
                      onTap: onJoin,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 80,
                          ),
                          Icon(
                            Icons.videocam_rounded,
                            size: 60,
                            color: constant.appPrimaryMaterialColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _otpKeyboardInputButton(
                      label: "0",
                      onPressed: () {
                        _setCurrentDigit(0);
                      }),
                  _otpKeyboardActionButton(
                      label: new Icon(
                        Icons.backspace,
                        size: 40,
                        color: constant.appPrimaryMaterialColor,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_fourthDigit != null) {
                            _fourthDigit = null;
                          } else if (_thirdDigit != null) {
                            _thirdDigit = null;
                          } else if (_secondDigit != null) {
                            _secondDigit = null;
                          } else if (_firstDigit != null) {
                            _firstDigit = null;
                          }
                        });
                      }),
                ],
              ),
            ),
          ],
        ));
  }

  get _VerifyButton {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 45,
          width: 150,
          child: RaisedButton(
              color: Colors.green,
              child: Text(
                "Verify",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18),
              ),
              onPressed: () {
                _getVisitorData('0',
                    '${_firstDigit.toString() + _secondDigit.toString() + _thirdDigit.toString() + _fourthDigit.toString()}');
              }),
        )
      ],
    );
  }

  _getVisitorData(String visitorId, String UniqCode) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String SocietyId = preferences.getString(Session.SocietyId);
        pr.show();
        Future res = Services.getScanVisitorByQR_or_Code(
            SocietyId, _visitorType[selected_Index], UniqCode, visitorId);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          pr.hide();
          if (data != null && data.length > 0) {
            setState(() {
              _visitordata = data;
              isLoading = false;
              txtvehicle.text =
                  data[0]["lastentry"] == null && data[0]["lastentry"] == ""
                      ? data[0]["lastentry"]["VehicleNo"]
                      : "";
            });
            if (selected_Index == 0)
              _showVisitorData(data);
            else
              _showStaffData(data);
          } else {
            setState(() {
              _visitordata = data;
              isLoading = false;
            });
            showMsg("Code Is Incorrect");
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

  void _showVisitorData(data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 8,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: data[0]["Image"] != "" && data[0]["Image"] != null
                        ? FadeInImage.assetNetwork(
                            placeholder: 'images/user.png',
                            image: "${IMG_URL + data[0]["Image"]}",
                            width: 100,
                            height: 100,
                            fit: BoxFit.fill)
                        : Image.asset("images/user.png",
                            width: 100, height: 100, fit: BoxFit.fill),
                  ),
                ),
                Text(
                  "${data[0]["Name"]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Visit At :  ",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800]),
                    ),
                    Text(
                      "${data[0]["worklist"][0]["WingName"]} - ${data[0]["worklist"][0]["FlatId"]}",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800]),
                    ),
                  ],
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

  void _showStaffData(data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 8,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
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
                  "${data[0]["Role"]}",
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

  _addVisitorEntry() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String SocietyId = preferences.getString(Session.SocietyId);

        pr.show();

        print(_visitordata[0]["worklist"]);

        var formData = {
          "Id": "0",
          "SocietyId": SocietyId,
          "TypeId": _visitordata[0]["Id"],
          "Type": _visitorType[selected_Index],
          "Purpose": "",
          "VehicleNo": txtvehicle.text,
          "WorkId": _visitordata[0]["worklist"]
        };
        print(formData);

        Services.checkInVisitorOrStaff(formData).then((data) async {
          pr.hide();
          if (data.Data != "0" && data.IsSuccess == true) {
            Fluttertoast.showToast(
                msg: "Visitor Entry Successfully inserted",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                textColor: Colors.white);
            setState(() {
              _firstDigit = null;
              _secondDigit = null;
              _thirdDigit = null;
              _fourthDigit = null;
            });
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

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Container(
        width: _screenSize.width,
        child: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/VisitorHistoryList');
                          },
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              Icon(Icons.search),
                              SizedBox(width: 5),
                              Expanded(child: Text("Search Visitor"))
                            ],
                          ),
                        ),
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0))),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Center(
                            child: Icon(Icons.exit_to_app, color: Colors.red),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80.0))),
                          height: 45,
                          width: 45,
                        ),
                        Text("Logout",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10))
                      ],
                    ),
                    onTap: () {
                      _showConfirmDialog();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == "Hindi") {
                          setState(() {
                            widget.data.changeLocale(Locale("hi", "IN"));
                          });
                        } else if (value == "English") {
                          setState(() {
                            widget.data.changeLocale(Locale("en", "US"));
                          });
                        } else if (value == "Gujrati") {
                          setState(() {
                            widget.data.changeLocale(Locale("gu", "IN"));
                          });
                        } else if (value == "Marathi") {
                          setState(() {
                            widget.data.changeLocale(Locale("mr", "IN"));
                          });
                        }
                      },
                      tooltip: "Change Language",
                      child: Icon(
                        Icons.more_horiz,
                        size: 30,
                        color: constant.appPrimaryMaterialColor,
                      ),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Hindi',
                          child: Text(
                            'हिंदी',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Gujrati',
                          child: Text(
                            'ગુજરાતી',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'English',
                          child: Text(
                            'English',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Marathi',
                          child: Text(
                            'मराठी',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: TextField(
                  //       controller: _channelController,
                  //       decoration: InputDecoration(
                  //         errorText: _validateError
                  //             ? 'Channel name is mandatory'
                  //             : null,
                  //         border: UnderlineInputBorder(
                  //           borderSide: BorderSide(width: 1),
                  //         ),
                  //         hintText: 'Channel name',
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: GestureDetector(
                  //     onTap: onJoin,
                  //     child: Column(
                  //       children: <Widget>[
                  //         Image.asset('images/video_call.png',
                  //             width: 40, height: 40),
                  //         Text(
                  //           "VIDEO CALL",
                  //           style: TextStyle(
                  //               fontWeight: FontWeight.w600, fontSize: 12),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 25)),
              _getInputField,
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Wrap(
                  spacing: 10,
                  children: List.generate(_visitorType.length, (index) {
                    return ChoiceChip(
                      backgroundColor: Colors.grey[200],
                      label: Text(
                        _visitorType[index],
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      selected: selected_Index == index,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selected_Index = index;
                            print(_visitorType[index]);
                          });
                        }
                      },
                    );
                  }),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 25)),
              _getOtpKeyboard,
              Padding(padding: EdgeInsets.only(top: 40)),
              _firstDigit != null &&
                      _secondDigit != null &&
                      _thirdDigit != null &&
                      _fourthDigit != null
                  ? _VerifyButton
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(int digit) {
    return new Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: new Text(
        digit != null ? digit.toString() : "",
        style: new TextStyle(
          fontSize: 30.0,
          color: Colors.black,
        ),
      ),
      decoration: BoxDecoration(
//            color: Colors.grey.withOpacity(0.4),
          border: Border(
              bottom: BorderSide(
        width: 2.0,
        color: Colors.black,
      ))),
    );
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: new Material(
        color: Colors.grey[100],
        child: new InkWell(
          onTap: onPressed,
          borderRadius: new BorderRadius.circular(40.0),
          child: new Container(
            height: 80.0,
            width: 80.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: new Center(
              child: new Text(
                label,
                style: new TextStyle(
                  fontSize: 30.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
    return new InkWell(
      onTap: onPressed,
      borderRadius: new BorderRadius.circular(40.0),
      child: new Container(
        height: 80.0,
        width: 80.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: new Center(
          child: label,
        ),
      ),
    );
  }

  // Current digit
  void _setCurrentDigit(int i) {
    setState(() {
      _currentDigit = i;
      if (_firstDigit == null) {
        _firstDigit = _currentDigit;
      } else if (_secondDigit == null) {
        _secondDigit = _currentDigit;
      } else if (_thirdDigit == null) {
        _thirdDigit = _currentDigit;
      } else if (_fourthDigit == null) {
        _fourthDigit = _currentDigit;
      }
    });
  }

  void clearOtp() {
    _fourthDigit = null;
    _thirdDigit = null;
    _secondDigit = null;
    _firstDigit = null;
    setState(() {});
  }

  Future<void> onJoin() async {
    // update input validation
    // setState(() {
    //   _channelController.text.isEmpty
    //       ? _validateError = true
    //       : _validateError = false;
    // });
    // if (_channelController.text.isNotEmpty) {
    // await for camera and mic permissions before pushing video page
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JoinPage(),
      ),
    );
    // }
  }

//for video call setings........................

// Future<void> onJoin() async {
//   // update input validation
//   setState(() {
//     _channelController.text.isEmpty
//         ? _validateError = true
//         : _validateError = false;
//   });
//   if (_channelController.text.isNotEmpty) {
//     // await for camera and mic permissions before pushing video page
//     await _handleCameraAndMic();
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CallPage(
//           channelName: _channelController.text,
//           role: _role,
//         ),
//       ),
//     );
//   }
// }

// Future<void> _handleCameraAndMic() async {
//   await PermissionHandler().requestPermissions(
//     [PermissionGroup.camera, PermissionGroup.microphone],
//   );
// }
}
