import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartsocietystaff/Common/Constants.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class VisitorOutSideComponent extends StatefulWidget {
  var _visitorOutSideList;

  VisitorOutSideComponent(this._visitorOutSideList);

  @override
  _VisitorOutSideComponentState createState() =>
      _VisitorOutSideComponentState();
}

class _VisitorOutSideComponentState extends State<VisitorOutSideComponent> {

  var date,newDt,monthNumber,dateNumber;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(int.parse(widget._visitorOutSideList["Date"].toString().split(" ")[0].split("/")[0])< 10){
      monthNumber = "0" + widget._visitorOutSideList["Date"].toString().split(" ")[0].split("/")[0];
    }
    else{
      monthNumber = widget._visitorOutSideList["Date"].toString().split(" ")[0].split("/")[0];
    }
    if(int.parse(widget._visitorOutSideList["Date"].toString().split(" ")[0].split("/")[1])< 10){
      dateNumber = "0" + widget._visitorOutSideList["Date"].toString().split(" ")[0].split("/")[1];
    }
    else{
      dateNumber = widget._visitorOutSideList["Date"].toString().split(" ")[0].split("/")[1];
    }
    date = DateTime.parse(
        widget._visitorOutSideList["Date"].toString().split(" ")[0].split("/")[2]+
            "-"+
            monthNumber +
        "-"
            +dateNumber+ " "+
    "00:00:00.000000");
    newDt = DateFormat.yMMMEd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0),
            child: ClipOval(
                child: FadeInImage.assetNetwork(
                    placeholder: 'images/Logo.png',
                    image: "${IMG_URL + widget._visitorOutSideList["Image"]}",
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Text(
                    '${widget._visitorOutSideList["Name"]}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('${widget._visitorOutSideList["CompanyName"]}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                      "Flat No: ${widget._visitorOutSideList["WingId"]}- ${widget._visitorOutSideList["FlatId"]}"),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right:35.0),
            child: Text("$newDt",
            style: TextStyle(
              color: Colors.red
            ),
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.call,
                color: Colors.green,
              ),
              onPressed: () {
                UrlLauncher.launch(
                    'tel:${widget._visitorOutSideList["ContactNo"]}');
              }),
        ],
      ),
    );
  }
}
