import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smartsocietystaff/Common/Services.dart';
import 'package:smartsocietystaff/Component/NoDataComponent.dart';
import 'package:smartsocietystaff/Component/VisitorInsideComponent.dart';

class VisitorInsideList extends StatefulWidget {
  @override
  _VisitorInsideListState createState() => _VisitorInsideListState();
}

class _VisitorInsideListState extends State<VisitorInsideList> {
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
        Future res = Services.getInsideVisitorData();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _visitorInsideList = data;
              isLoading = false;
            });
            _visitorInsideList = _visitorInsideList.reversed.toList();
          } else {
            setState(() {
              _visitorInsideList = data;
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

  showMsg(String msg, {String title = 'My Jini'}) {
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
    return Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : _visitorInsideList.length > 0
                ? ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return VisitorInsideComponent(
                          _visitorInsideList[index], index, (type) {
                        if (type == "false")
                          setState(() {
                            _getInsideVisitor();
                          });
                        else if (type == "loading")
                          setState(() {
                            isLoading = true;
                          });
                      });
                    },
                    itemCount: _visitorInsideList.length,
                  )
                : NoDataComponent());
  }
}
