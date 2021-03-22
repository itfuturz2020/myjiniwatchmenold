import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:smartsocietystaff/Common/Services.dart';
import 'package:smartsocietystaff/Component/NoDataComponent.dart';
import 'package:smartsocietystaff/Component/VisitorOutSideComponent.dart';
import '../Common/Constants.dart' as cnst;

class VisitorOutSideList extends StatefulWidget {
  @override
  _VisitorOutSideListState createState() => _VisitorOutSideListState();
}

class _VisitorOutSideListState extends State<VisitorOutSideList> {
  List _visitorInsideList = [];
  bool isLoading = false;

  @override
  void initState() {
    _fromDate = DateTime.now();
    _toDate = DateTime.now();
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
            _visitorInsideList = _visitorInsideList.reversed.toList();
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

  String month = "", selectedWing = "";
  String _format = 'yyyy-MMMM-dd';
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  DateTime _fromDate;
  DateTime _toDate;

  void _showFromDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Done', style: TextStyle(color: Colors.red)),
        cancel: Text('cancel', style: TextStyle(color: Colors.cyan)),
      ),
      initialDateTime: DateTime.now(),
      dateFormat: _format,
      locale: _locale,
      onChange: (dateTime, List<int> index) {
        setState(() {
          _fromDate = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _fromDate = dateTime;
        });
      },
    );
  }

  void _showToDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Done', style: TextStyle(color: Colors.red)),
        cancel: Text('cancel', style: TextStyle(color: Colors.cyan)),
      ),
      initialDateTime: DateTime.now(),
      dateFormat: _format,
      locale: _locale,
      onChange: (dateTime, List<int> index) {
        setState(() {
          _toDate = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _toDate = dateTime;
        });
      },
    );
  }

  List searchList = [];
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    print(_fromDate);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body:
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _showFromDatePicker();
                          },
                          child: Container(
                            height: 37,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius:
                                BorderRadius.all(Radius.circular(5))),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(left: 5)),
                                Text(
                                  "${_fromDate.toString().substring(8, 10)}-${_fromDate.toString().substring(5, 7)}-${_fromDate.toString().substring(0, 4)}",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Padding(padding: EdgeInsets.only(left: 5)),
                                Container(
                                  width: 50,
                                  height: 55,
                                  decoration: BoxDecoration(
                                      color: cnst.appPrimaryMaterialColor,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5))),
                                  child: Icon(
                                    Icons.date_range,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text("To ",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ),
                        Container(
                          height: 37,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                              BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 5)),
                              Text(
                                "${_toDate.toString().substring(8, 10)}-${_toDate.toString().substring(5, 7)}-${_toDate.toString().substring(0, 4)}",
                                style: TextStyle(fontSize: 13),
                              ),
                              Padding(padding: EdgeInsets.only(left: 5)),
                              GestureDetector(
                                onTap: () {
                                  _showToDatePicker();
                                },
                                child: Container(
                                  width: 50,
                                  height: 55,
                                  decoration: BoxDecoration(
                                      color: cnst.appPrimaryMaterialColor,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5))),
                                  child: Icon(
                                    Icons.date_range,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(left: 4)),
                    Expanded(
                      child: RaisedButton(
                          color: cnst.appPrimaryMaterialColor,
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            searchList.clear();
                            var start,end,formatDate,secondDigit,thirdDigit;
                            if(_fromDate.compareTo(_toDate) > 0){
                              print("not allowed");
                              setState(() {
                                searchList.clear();
                                isSearching = true;
                              });
                            }
                            else{
                              for(int i=0;i<_visitorInsideList.length;i++){
                                start = _fromDate;
                                end = _toDate;
                                if(int.parse(_visitorInsideList[i]["Date"].toString().split(" ")[0].split("/")[0]) < 10){
                                  secondDigit = "0" + _visitorInsideList[i]["Date"].toString().split(" ")[0].split("/")[0];
                                }
                                else{
                                  secondDigit =  _visitorInsideList[i]["Date"].toString().split(" ")[0].split("/")[0];
                                }
                                if(int.parse(_visitorInsideList[i]["Date"].toString().split(" ")[0].split("/")[1]) < 10){
                                  thirdDigit = "0" + _visitorInsideList[i]["Date"].toString().split(" ")[0].split("/")[1];
                                }
                                else{
                                  thirdDigit =  _visitorInsideList[i]["Date"].toString().split(" ")[0].split("/")[1];
                                }
                                formatDate = _visitorInsideList[i]["Date"].toString().split(" ")[0].split("/")[2] +
                                    "-" + secondDigit + "-" + thirdDigit + " " + "00:00:00.000000";
                                Duration difference1 = end.difference(DateTime.parse(formatDate));
                                Duration difference2 = start.difference(DateTime.parse(formatDate));
                                if(int.parse(difference1.toString().split(":")[0]) >=0 && int.parse(difference2.toString().split(":")[0]) <=0){
                                  if(!searchList.contains(_visitorInsideList[i])){
                                    setState(() {
                                      searchList.add(_visitorInsideList[i]);
                                      isSearching = true;
                                    });
                                  }}
                              }
                            }
                            // getStaffData(_fromDate.toString(),
                            //     _toDate.toString(), selectedWing);
                          }),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? Container(child: Center(child: CircularProgressIndicator()))
                  : !isSearching ? _visitorInsideList.length > 0
                  ? Expanded(
                    child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                    return VisitorOutSideComponent(
                        _visitorInsideList[index]);
                },
                itemCount: _visitorInsideList.length,
              ),
                  )
                  : NoDataComponent():searchList.length > 0
                  ? Expanded(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return VisitorOutSideComponent(
                        searchList[index]);
                  },
                  itemCount: searchList.length,
                ),
              )
                  : NoDataComponent(),
            ],
          ),
      ),
    );
  }
}
