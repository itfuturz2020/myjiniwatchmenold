import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietystaff/Common/settings.dart';

// import 'package:wakelock/wakelock.dart';

class JoinPage extends StatefulWidget {
  final String channelName;

  JoinPage({
    this.channelName,
  });

  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  static final _users = <int>[];
  bool muted = true;
  AgoraRtmChannel _channel;
  bool completed = false;
  bool accepted = false;
  bool loading = true;

  @override
  void initState() {
    initialize();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  // static Future<void> SaveVisitor(body) async {
  //   print(body.toString());
  //   String url = API_URL + 'SaveVisitorsV1';
  //   final response = await dio.post(url,data: body);
  //   print("SaveVisitorData url : " + url);
  //   print(response.data);
  // }

  Future<void> initialize() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = preferences.getString('data');
    print("smit watchman2 ${data}");
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, data, null, 0);
    setState(() {
      loading = false;
    });
  }

  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
    //await AgoraRtcEngine.muteLocalAudioStream(true);
  }

  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      // Wakelock.enable();...........
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        _users.remove(uid);
      });
    };
  }

  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [];
    //user.add(widget.channelId);
    _users.forEach((int uid) {
      list.add(AgoraRenderWidget(uid));
    });
    list.add(AgoraRenderWidget(0, local: true, preview: true));

    return list;
  }

  Widget _videoView(view) {
    return Column(
      children: [
        Expanded(
          // Commented by anirudh
          child: ClipRRect(
            child: view,
          ),
        ),
      ],
    );
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  // / Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    log("${views.length}");

    switch (views.length) {
      case 1:
        return _videoView(views[0]);
      case 2:
        return Column(
          children: <Widget>[
            // Container(
            //   decoration: BoxDecoration(
            //     border: Border.all(),
            //   ), //             <--- BoxDecoration here
            //   child: Expanded(child: views[0]),
            // ),
            Expanded(child: views[0]),
            Divider(
              thickness: 2,
              color: Colors.deepPurple,
            ),
            Expanded(child: views[1]),
            // Expanded(child: views[1]),
            // _expandedVideoRow([views[0]]),
            // _expandedVideoRow([views[1]])
          ],
        );
        break;
      default:
        return Container();
    }
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MY JINI'),
      ),
      body: Center(
        child: loading
            ? CircularProgressIndicator()
            : Stack(
                children: <Widget>[
                  _viewRows(),
                  _toolbar(),
                ],
              ),
      ),
    );
  }
}
