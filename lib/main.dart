import 'package:easy_localization/easy_localization.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
//Component
import 'package:smartsocietystaff/Common/Constants.dart';
import 'package:smartsocietystaff/Component/NotificationAnswerDialog.dart';
import 'package:smartsocietystaff/Screens/AddDocument.dart';
import 'package:smartsocietystaff/Screens/AddEvent.dart';
import 'package:smartsocietystaff/Screens/AddNotice.dart';
import 'package:smartsocietystaff/Screens/AddRules.dart';
import 'package:smartsocietystaff/Screens/AddVisitorForm.dart';
import 'package:smartsocietystaff/Screens/BalanceSheet.dart';
import 'package:smartsocietystaff/Screens/Complaints.dart';
import 'package:smartsocietystaff/Screens/Dashboard.dart';
import 'package:smartsocietystaff/Screens/Directory.dart';
import 'package:smartsocietystaff/Screens/Document.dart';
import 'package:smartsocietystaff/Screens/Emergency.dart';
import 'package:smartsocietystaff/Screens/Events.dart';
import 'package:smartsocietystaff/Screens/Expense.dart';
import 'package:smartsocietystaff/Screens/ExpenseByMonth.dart';
import 'package:smartsocietystaff/Screens/Income.dart';
import 'package:smartsocietystaff/Screens/IncomeByMonth.dart';
//Screens
import 'package:smartsocietystaff/Screens/Login.dart';
import 'package:smartsocietystaff/Screens/MemberProfile.dart';
import 'package:smartsocietystaff/Screens/Notice.dart';
import 'package:smartsocietystaff/Screens/Polling.dart';
import 'package:smartsocietystaff/Screens/Splash.dart';
import 'package:smartsocietystaff/Screens/Staff.dart';
import 'package:smartsocietystaff/Screens/StaffInOut.dart';
import 'package:smartsocietystaff/Screens/Visitor.dart';
import 'package:smartsocietystaff/Screens/VisitorHistoryList.dart';
import 'package:smartsocietystaff/Screens/WatchmanDashboard.dart';

import 'Screens/AddAMC.dart';
import 'Screens/AddExpense.dart';
import 'Screens/AddIncome.dart';
import 'Screens/AddPolling.dart';
import 'Screens/AddStaff.dart';
import 'Screens/RulesAndRegulations.dart';
import 'Screens/StaffList.dart';
import 'Screens/amcList.dart';

void main() {
  runApp(EasyLocalization(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print("onMessage");
      print(message);
      Get.to(NotificationAnswerDialog(message));
    }, onResume: (Map<String, dynamic> message) {
      print("onResume");
    }, onLaunch: (Map<String, dynamic> message) {
      print("onLaunch");
      print(message);
    });

    //For Ios Notification
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Setting reqistered : $settings");
    });

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings);
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'Easy Permission Validator',
    );
    permissionValidator.microphone();
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: MaterialApp(
        navigatorKey: Get.key,
        debugShowCheckedModeBanner: false,
        title: 'My JINI Staff',
        initialRoute: '/',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          EasyLocalizationDelegate(
            locale: data.locale,
            path: 'resources/langs',
          ),
        ],
        supportedLocales: [
          Locale('en', 'US'),
          Locale('hi', 'IN'),
          Locale('gu', 'IN'),
          Locale('mr', 'IN')
        ],
        locale: data.savedLocale,
        routes: {
          '/': (context) => Splash(),
          '/Login': (context) => Login(),
          '/Dashboard': (context) => Dashboard(),
          '/WatchmanDashboard': (context) => WatchmanDashboard(),
          '/AddNotice': (context) => AddNotice(),
          '/AddDocument': (context) => AddDocument(),
          '/Directory': (context) => Directory(),
          '/Notice': (context) => Notice(),
          '/Document': (context) => Document(),
          '/Visitor': (context) => Visitor(),
          '/Staff': (context) => Staff(),
          '/RulesAndRegulations': (context) => RulesAndRegulations(),
          '/AddRules': (context) => AddRules(),
          '/Complaints': (context) => Complaints(),
          '/MemberProfile': (context) => MemberProfile(),
          '/Emergency': (context) => Emergency(),
          '/Events': (context) => Events(),
          '/AddEvent': (context) => AddEvent(),
          '/Income': (context) => Income(),
          '/Expense': (context) => Expense(),
          '/BalanceSheet': (context) => BalanceSheet(),
          '/ExpenseByMonth': (context) => ExpenseByMonth(),
          '/IncomeByMonth': (context) => IncomeByMonth(),
          '/AddIncome': (context) => AddIncome(),
          '/AddExpense': (context) => AddExpense(),
          '/Polling': (context) => Polling(),
          '/AddPolling': (context) => AddPolling(),
          '/AddVisitorForm': (context) => AddVisitorForm(),
          '/AddStaff': (context) => AddStaff(),
          '/StaffList': (context) => StaffList(),
          '/amcList': (context) => amcList(),
          '/AddAMC': (context) => AddAMC(),
          '/VisitorHistoryList': (context) => VisitorHistoryList(),
          '/StaffInOut': (context) => StaffInOut(),
        },
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primarySwatch: appPrimaryMaterialColor,
          accentColor: appPrimaryMaterialColor,
          buttonColor: Colors.deepPurple,
        ),
      ),
    );
  }

  showNotification(String title, String body) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max, playSound: false);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, '$title', '$body', platform,
        payload: 'MY JINI');
  }
}
