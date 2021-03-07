import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:smartsocietystaff/Common/Constants.dart' as cnst;
import 'package:smartsocietystaff/Common/Constants.dart';
import 'package:smartsocietystaff/Common/Services.dart';
import 'package:smartsocietystaff/Component/LoadingComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProgressDialog pr;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txtUserName = new TextEditingController();
  TextEditingController txtPassword = new TextEditingController();

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

  checkLogin() async {
    if (txtUserName.text != "" &&
        txtUserName.text != null &&
        txtPassword.text != "" &&
        txtPassword.text != null) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          pr.show();
          Future res = Services.MemberLogin(txtUserName.text, txtPassword.text);
          res.then((data) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (data != null && data.length > 0) {
              pr.hide();
              await prefs.setString(
                Session.MemberId,
                data[0]["Id"].toString(),
              );
              await prefs.setString(
                Session.RoleId,
                data[0]["RoleId"].toString(),
              );
              await prefs.setString(
                Session.SocietyId,
                data[0]["SocietyId"].toString(),
              );
              await prefs.setString(
                Session.Name,
                data[0]["Name"].toString(),
              );
              await prefs.setString(
                Session.UserName,
                data[0]["UserName"].toString(),
              );
              await prefs.setString(
                Session.Password,
                data[0]["Password"].toString(),
              );
              await prefs.setString(
                Session.Role,
                data[0]["Role"].toString(),
              );
              data[0]["Role"].toString() == "Watchmen"
                  ? Navigator.pushReplacementNamed(context, '/WatchmanDashboard')
                  : Navigator.pushReplacementNamed(context, '/Dashboard');
            } else {
              pr.hide();
              showMsg("Invalid login Detail.");
            }
          }, onError: (e) {
            pr.hide();
            print("Error : on Login Call $e");
            showMsg("Something Went Wrong Please Try Again");
          });
        } else {
          pr.hide();
          showMsg("No Internet Connection.");
        }
      } on SocketException catch (_) {
        showMsg("No Internet Connection.");
      }
    } else {
      showMsg("Please Fill All Details");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset("images/Logo.png",
                      width: 120.0, height: 120.0, fit: BoxFit.contain),
                  Padding(
                    padding: const EdgeInsets.only(bottom:40.0,top: 8.0),
                    child: Text("MY JINI",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: txtUserName,
                      scrollPadding: EdgeInsets.all(0),
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          prefixIcon: Icon(
                            Icons.supervised_user_circle,
                            //color: cnst.appPrimaryMaterialColor,
                          ),
                          hintText: "User Name"),
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: txtPassword,
                      scrollPadding: EdgeInsets.all(0),
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          prefixIcon: Icon(
                            Icons.lock,
                            //color: cnst.appPrimaryMaterialColor,
                          ),
                          hintText: "Password"),
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10),
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: cnst.appPrimaryMaterialColor,
                      minWidth: MediaQuery.of(context).size.width - 20,
                      onPressed: () {
                        checkLogin();
                      },
                      child: Text(
                        "SIGN IN",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
