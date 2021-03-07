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
