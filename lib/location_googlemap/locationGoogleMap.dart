import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
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

class LocationGoogleMap extends StatefulWidget {
  const LocationGoogleMap({super.key, required this.latLng});
  final Function(LatLng?) latLng;
  @override
  _LocationGoogleMapState createState() => _LocationGoogleMapState();
}

class _LocationGoogleMapState extends State<LocationGoogleMap> {
  late GoogleMapController mapController;
  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Text('Select location',style: GoogleFonts.openSans(
          color: Colors.white,
        ),),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            onTap: (LatLng location) {
              setState(() {
                _selectedLocation = location; // เก็บตำแหน่งที่ผู้ใช้แตะ
                widget.latLng(location);
              });
              Navigator.pop(context);
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(13.73409854731179, 100.62710791826248),
              zoom: 10,
            ),
            markers: _selectedLocation != null
                ? {
              Marker(
                markerId: MarkerId('selected-location'),
                position: _selectedLocation!,
              ),
            }
                : {},
          ),
          if (_selectedLocation != null)
            Positioned(
              bottom: 50,
              left: 20,
              child: Text(
                'Selected Position: \nLat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
