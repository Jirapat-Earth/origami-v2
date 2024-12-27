import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:origami_v2/language/translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

import '../login/origami_login.dart';

int selectedRadio = 2;

class TranslatePage extends StatefulWidget {
  const TranslatePage({
    Key? key,
    required this.employee, required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String Authorization;
  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  @override
  void initState() {
    super.initState();
    _loadSelectedRadio();
  }

  // โหลดค่าที่บันทึกไว้
  _loadSelectedRadio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedRadio = prefs.getInt('selectedRadio') ?? 2;
      Translate();
    });
  }

  // บันทึกค่าเมื่อมีการเปลี่ยนแปลง
  _handleRadioValueChange(int? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedRadio = value!;
      prefs.setInt('selectedRadio', selectedRadio);
      Translate();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            num: 0,
            popPage: 3,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Flag_of_Thailand_%28non-standard_colours%29.svg/180px-Flag_of_Thailand_%28non-standard_colours%29.svg.png',
                          // width: 200,
                          height: 100,
                        ),
                        TextButton(
                          // style:ButtonStyle(shadowColor:Color(colors.)),
                          onPressed: () {
                            _handleRadioValueChange(1);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (selectedRadio == 1)
                                  ? Icon(
                                Icons.radio_button_on,
                                color: Color(0xFFFF9900),
                              )
                                  : Icon(
                                Icons.radio_button_off,
                                color: Color(0xFFFF9900),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'ภาษาไทย',
                                style: GoogleFonts.openSans(
                                    fontSize: 16, color: Color(0xFF555555)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Flag_of_the_United_Kingdom_%281-2%29.svg/1200px-Flag_of_the_United_Kingdom_%281-2%29.svg.png',
                          // width: 200,
                          height: 100,
                        ),
                        TextButton(
                          onPressed: () {
                            _handleRadioValueChange(2);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (selectedRadio == 2)
                                  ? Icon(
                                Icons.radio_button_on,
                                color: Color(0xFFFF9900),
                              )
                                  : Icon(
                                Icons.radio_button_off,
                                color: Color(0xFFFF9900),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'English',
                                style: GoogleFonts.openSans(
                                    fontSize: 16, color: Color(0xFF555555)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Divider(),
            ),
          ],
        ),
      ),
    );
  }
}

