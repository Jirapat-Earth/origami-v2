import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import '../language/translate.dart';
import 'calendar/calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../origami.dart';
import '../main.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:signature/signature.dart';
import 'package:intl/date_symbol_data_local.dart'; // โหลดข้อมูล locale สำหรับการแสดงวันที่
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart'; // สำหรับเลือกไฟล์
import 'package:xml/xml.dart'; // สำหรับอ่าน XML
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'login/origami_login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ใช้สำหรับรอการ initialize
  await initializeDateFormatting('th', null); // เตรียมข้อมูลสำหรับ Locale ภาษาไทย
  checkDeviceType();
  var appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  await Hive.openBox('userBox'); // เปิด Box สำหรับเก็บข้อมูล
  runApp(const MyApp());
}

bool isAndroid = false;
bool isTablet = false;
bool isIPad = false;
bool isIPhone = false;
Future<void> checkDeviceType() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  // ความกว้างของหน้าจอ
  double screenWidth = window.physicalSize.shortestSide;
  // ความยาวของหน้าจอ
  double screenHeight = window.physicalSize.longestSide;
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.isPhysicalDevice) {
      print('Android Device: ${androidInfo.model}');
    }
    if (screenWidth > 1440 || screenHeight <= 1900) {
      isAndroid = false;
      isTablet = true;
      print("This Android device is a Tablet");
    } else {
      isAndroid = true;
      isTablet = false;
      print("This Android device is a Phone");
    }
    isIPad = false;
    isIPhone = false;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    // เช็คชื่อรุ่นว่าเป็น iPad หรือไม่
    if ((iosInfo.model?.toLowerCase().contains("ipad") ?? false) || screenWidth > 1440 || screenHeight <= 1900) {
      isIPad = true;
      isIPhone = false;
      print("This device is an iPad");
    } else {
      isIPad = false;
      isIPhone = true;
      print("This device is an iPhone");
    }
    isAndroid = false;
    isTablet = false;
  }
  print('$isAndroid , $isTablet , $isIPad , $isIPhone');
  if(isAndroid == true || isIPhone == true){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });
  }else{
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // หมุนหน้าจอเป็นแนวนอนอัตโนมัติและล็อคไว้
    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.landscapeRight,
    //     DeviceOrientation.landscapeLeft,
    //   ]);
    // });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Origami',
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Theme.of(context).colorScheme.inversePrimary,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.openSans(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          //GoogleFonts.oswald
          titleLarge: GoogleFonts.openSans(
            fontSize: 28,
          ),
        ),
      ),
      home: LoginPage(num: 0, popPage: 0),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ));
  }
}
