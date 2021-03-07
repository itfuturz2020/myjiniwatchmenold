import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smartsocietystaff/Common/Services.dart';
import 'package:smartsocietystaff/Component/NoDataComponent.dart';
import 'package:smartsocietystaff/Component/VisitorInsideComponent.dart';
import 'package:smartsocietystaff/Component/VisitorInsideComponent.dart';
import 'package:smartsocietystaff/Component/VisitorOutSideComponent.dart';
import 'package:smartsocietystaff/Common/Constants.dart' as constant;

class VisitorOutSideList extends StatefulWidget {
  @override
  _VisitorOutSideListState createState() => _VisitorOutSideListState();
}

class _VisitorOutSideListState extends State<VisitorOutSideList> {
  List _visitorInsideList = [];
  bool isLoading = false;

  @override
  void initState() {
    _getInsideVisitor();
  }

  _getInsideVisitor() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getOutSideVisitorData();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _visitorInsideList = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: isLoading
              ? Container(child: Center(child: CircularProgressIndicator()))
              : _visitorInsideList.length > 0
                  ? ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return VisitorOutSideComponent(_visitorInsideList[index]);
                      },
                      itemCount: _visitorInsideList.length,
                    )
                  : NoDataComponent()),
    );
  }
}
