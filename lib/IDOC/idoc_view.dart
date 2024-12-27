import '../login/origami_login.dart';
import 'idoc_edit.dart';
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

class IdocScreen extends StatefulWidget {
  const IdocScreen({
    Key? key,
    required this.employee,
    required this.pageInput, required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;

  @override
  _IdocScreenState createState() => _IdocScreenState();
}

class _IdocScreenState extends State<IdocScreen> {
  TextEditingController _searchController = TextEditingController();
  String _search = "";
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.pageInput == 'project')
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(0xFFFF9900),
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'IDOC',
                  style: GoogleFonts.openSans(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: _getContentWidget(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: _getContentWidget(),
          );
  }

  Widget _getContentWidget() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              style: GoogleFonts.openSans(
                color: Color(0xFF555555),
                fontSize: 14,
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                hintText: 'Search...',
                hintStyle: GoogleFonts.openSans(
                    fontSize: 14, color: Color(0xFF555555)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFFFF9900),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IdocEdit(
                                  employee: widget.employee,
                                  pageInput: widget.pageInput,
                                    Authorization: widget.Authorization
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey,
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.white,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        '$host/uploads/employee/5/employee/19777.jpg?v=1729754401',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'SUBJECT ${index + 1}',
                                        maxLines: 1,
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          color: Color(0xFFFF9900),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'SubTitile ${index + 1} (2024/10/25 16:17)',
                                        maxLines: 1,
                                        style: GoogleFonts.openSans(
                                          fontSize: 12,
                                          color: Color(0xFF555555),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'เอซีอาร์ เมเนจเมนท์ จำกัด(ACRM)',
                                        maxLines: 1,
                                        style: GoogleFonts.openSans(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Category : Dev',
                                        maxLines: 1,
                                        style: GoogleFonts.openSans(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Divider(),
                    )
                  ],
                );
              }),
        ),
      ],
    );
  }
}

class OtherPro {
  final String name;
  final IconData icon; // เพิ่มไอคอน
  OtherPro(this.name, this.icon);
}

class UnitOther {
  String name;
  IconData? icon;
  UnitOther({required this.name, this.icon});
}
