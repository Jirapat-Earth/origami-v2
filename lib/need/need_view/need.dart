import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../language/translate.dart';
import '../../login/origami_login.dart';
import '../../origami.dart';
import '../widget_mini/mini_department.dart';
import '../widget_mini/mini_employee.dart';
import '../widget_mini/mini_project.dart';
import '../widget_other/date_other.dart';
import '../widget_other/priority_other.dart';
import 'need_approve_detail.dart';
import 'need_detail.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class NeedsView extends StatefulWidget {
  const NeedsView({
    super.key,
    required this.employee, required this.Authorization,
  });
  final Employee employee;
  final String Authorization;
  @override
  _NeedsViewState createState() => _NeedsViewState();
}

class _NeedsViewState extends State<NeedsView> {
  TextEditingController _searchController = TextEditingController();
  // final FocusNode _focusNode = FocusNode();
  DateTime now = DateTime.now();

  int currentStep = 1;

  String searchText = '';

  String? filter_Priority = '';
  String? filter_Department = '';
  String? filter_Project = '';
  String? filter_Owner = '';
  String? need_Type = 'All';
  String? need_Status = 'All';

  String firstDay = '';
  String lastDay = '';

  String request_id = '';
  Widget _filter() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Card(color: Color(0xFFFF9900),child: Padding(padding: EdgeInsets.only(left: 40,right: 40,top: 8,)),),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateOther(
                    firstDay: (String value) => firstDay = value,
                    lastDay: (String value) => lastDay = value,
                    getfirstDay: firstDay,
                    getlastDay: lastDay,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Divider(),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          '$Priority : ',
                          style: GoogleFonts.openSans(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: PriorityOther(
                          priority: priorityOption,
                          callbackId: (String value) => priorityId = value,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Divider(),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          '$Department : ',
                          style: GoogleFonts.openSans(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: _department(departmentOption),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Divider(),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          '$Project : ',
                          style: GoogleFonts.openSans(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: _project(projectOption),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Divider(),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          '$Owner : ',
                          style: GoogleFonts.openSans(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: _owner(employeeOption),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Divider(),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFFF9900),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onPressed: () {
                  fetchNeedResponse();
                  // fetchNeedRespond(
                  //   typeName,
                  //   status_id,
                  //   searchText,
                  //   firstDay,
                  //   lastDay,
                  //   priorityId,
                  //   departmentId,
                  //   projectId,
                  //   ownerId,
                  // );
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      '$Save',
                      style: GoogleFonts.openSans(fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _selectcolor = 0;
  int _indexcolor = 0;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _showMyDialog();
    // });
    Day();
    futureLoadData = loadData();
    fetchProject(project_number, project_name);
    fetchDepartment(department_number, department_name);
    fetchPriority(priority_number, priority_name);
    fetchEmployee(employee_number, employee_name);
    fetchTypeRespond();
    fetchTypeItemRespond();
    _searchController.addListener(() {
      // ฟังก์ชันนี้จะถูกเรียกทุกครั้งเมื่อข้อความใน _searchController เปลี่ยนแปลง
      searchText = _searchController.text;
      fetchNeedResponse();
      print("Current text: ${_searchController.text}");
    });
    // _focusNode.addListener(() {
    //   if (!_focusNode.hasFocus) {
    //     // เมื่อ TextField สูญเสียโฟกัส
    //     _searchController.clear();
    //   }
    // });
  }

  @override
  void dispose() {
    _searchController.dispose();
    // _focusNode.dispose();
    super.dispose();
  }

  void Day() {
    DateTime thirtyDaysAgo = now.subtract(Duration(days: 30));
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    firstDay = formatter.format(thirtyDaysAgo);
    lastDay = formatter.format(now);
  }

  String typeName = '';
  String status_id = '';
  int indexI = 0;

  NeedTypeItemRespond? NeedTypeItemRes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: checkNeed == null ?Colors.grey.shade50:Colors.white,
      floatingActionButton: SpeedDial(
        elevation: 0,
        icon: Icons.add,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(100),
            bottomLeft: Radius.circular(100),
            bottomRight: Radius.circular(100),
            topLeft: Radius.circular(100),
          ),
        ),
        animatedIcon: AnimatedIcons.add_event,
        backgroundColor: Color(0xFFFF9900),
        foregroundColor: Colors.white,
        visible: true,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        // overlayOpacity: 0.5,
        children: List.generate(NeedTypeItemOption.length, (indexItem) {
          indexI = indexItem;
          NeedTypeItemOption.sort(
              (a, b) => b.type_id?.compareTo(a.type_id ?? '')??0);
          NeedTypeItemOption.sort(
              (a, b) => b.type_color?.compareTo(a.type_color ?? '')??0);
          NeedTypeItemOption.sort(
              (a, b) => b.type_name?.compareTo(a.type_name ?? '')??0);
          NeedTypeItemOption.sort(
              (a, b) => b.type_image?.compareTo(a.type_image ?? '')??0);
          return SpeedDialChild(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                NeedTypeItemOption[indexItem].type_image ?? '',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            label: NeedTypeItemOption[indexItem].type_name ?? '',
            labelStyle: GoogleFonts.openSans(
              fontSize: 14.0,
              color: Color(0xFF555555),
              fontWeight: FontWeight.bold,
            ),
            labelBackgroundColor: Color(int.parse(
                '0xFF${this.NeedTypeItemOption[indexItem].type_color}')),
            backgroundColor: Colors.transparent,
            elevation: 0,
            onTap: () {
              showModalBottomSheet<void>(
                barrierColor: Colors.black87,
                backgroundColor: Colors.transparent,
                context: context,
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
                builder: (BuildContext context) {
                  return Container(
                    color: Colors.white,
                    child: FractionallySizedBox(
                      heightFactor: 0.96,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: NeedDetail(
                          needTypeItem: NeedTypeItemOption[indexItem],
                          Authorization: widget.Authorization,
                          employee: widget.employee,
                          request_id: '',
                          // detailItem: ,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Color(0xFFFF9900),
                              width: 1.0,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            // focusNode: _focusNode,
                            decoration: InputDecoration(
                              hintText: '$Search...',
                              hintStyle: GoogleFonts.openSans(
                                color: Color(0xFF555555),
                              ),
                              labelStyle: GoogleFonts.openSans(
                                color: Color(0xFF555555),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color(0xFFFF9900),
                              ),
                              border: InputBorder.none,
                              suffixIcon: Container(
                                alignment: Alignment.centerRight,
                                width: 10,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {
                                        _searchController.clear();
                                      },
                                      icon: Icon(Icons.close),
                                      color: Color(0xFFFF9900),
                                      iconSize: 18),
                                ),
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet<void>(
                            barrierColor: Colors.black87,
                            backgroundColor: Colors.transparent,
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Container(
                                color: Colors.white,
                                child: FractionallySizedBox(
                                  heightFactor: 0.7,
                                  child: MaterialApp(
                                    debugShowCheckedModeBanner: false,
                                    home: Scaffold(
                                      backgroundColor: Colors.transparent,
                                      body: _filter(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.filter_alt_outlined,
                          color: Color(0xFFFF9900),
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      children: List.generate(NeedTypeOption.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectcolor = index;
                              });
                              typeName =
                                  NeedTypeOption[index].typeId ?? '';
                              fetchNeedResponse();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.5,
                                  ),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: (index == _selectcolor)
                                        ? Color(0xFFFF9900)
                                        : Colors.grey.shade100,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 6, top: 6, left: 16, right: 16),
                                    child: Text(
                                      NeedTypeOption[index].typeName ?? '',
                                      style: GoogleFonts.openSans(
                                          color: (index == _selectcolor)
                                              ? Colors.white
                                              : Color(0xFF555555)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(NeedTypeOption[_selectcolor].typeStatus?.length??0, (index) {
                      final typeStatus = NeedTypeOption[_selectcolor].typeStatus?[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 8, top: 4),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _indexcolor = index;
                            });
                            status_id = typeStatus?.statusId ?? '';
                            fetchNeedResponse();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: 4, top: 4, left: 2, right: 2),
                            child: ClipPath(
                              clipper: ArrowClipper(15, 32, Edge.RIGHT),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                height: 34,
                                // width: 150,
                                color: (index == _indexcolor)
                                    ? Color(0xFFFF9900)
                                    : Colors.grey.shade100,
                                child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8, right: 16),
                                      child: Text(
                                        "${typeStatus?.statusName}",
                                        style: GoogleFonts.openSans(
                                          color: (index == _indexcolor)
                                              ? Colors.white
                                              : Color(0xFF555555),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    )),
                              ),
                            ),
                            // Text(
                            //   NeedTypeOption[index].typeName ?? '',
                            //   style: GoogleFonts.openSans(
                            //       fontSize: 12.0, color: (index == _selectcolor)?Colors.white:Color(0xFF555555)),
                            // ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Divider(),
              ],
            ),
          ),
          Expanded(child: _loading()),
        ],
      ),
    );
  }

  Widget _loading() {
    return FutureBuilder<List<NeedRespond>>(
      future: fetchNeedResponse(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFFFF9900),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    '$Loading...',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF555555),
                    ),
                  ),
                ],
              ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return _getContentWidget(snapshot.data??[]);
        }
      },
    );
  }

  Widget _getContentWidget(List<NeedRespond> needList) {
    return (checkNeed == null || needList.isNotEmpty)
        ? ListView.builder(
            controller: ScrollController(),
            itemCount: needList.length,
            itemBuilder: (context, indexNl) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 16),
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(15),
                      //   side: BorderSide(width: 1, color: Color(0xFF555555)),
                      // ),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet<void>(
                            barrierColor: Color(0xFF555555),
                            backgroundColor: Colors.transparent,
                            context: context,
                            isScrollControlled: true,
                            isDismissible: false,
                            enableDrag: false,
                            builder: (BuildContext context) {
                              // fetchDetail('edit', needList[index].mny_request_id??'' , '');
                              return Container(
                                color: Colors.white,
                                child: FractionallySizedBox(
                                  heightFactor: 0.96,
                                  child: Scaffold(
                                    backgroundColor: Colors.transparent,
                                    body: (needList[indexNl]
                                                    .need_status !=
                                                "N" ||
                                            needList[indexNl]
                                                    .need_status !=
                                                "All")
                                        ? NeedDetailApprove(
                                            employee: widget.employee,
                                      Authorization: widget.Authorization,      
                                      request_id: needList[indexNl]
                                                    .mny_request_id ??
                                                '',
                                            // approvelList:needList[indexNl],
                                          )
                                        : NeedDetail(
                                            needTypeItem:
                                                NeedTypeItemOption[
                                                    indexI],
                                      Authorization: widget.Authorization,
                                            employee: widget.employee,
                                            request_id: needList[indexNl]
                                                    .mny_request_id ??
                                                '',
                                          ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: ListTile(
                          title: Text(
                            needList[indexNl].need_subject ?? '',
                            style: GoogleFonts.openSans(
                              fontSize: 18,
                              color: Color(0xFFFF9900),
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${needList[indexNl].mny_type_name ?? ''} - ${needList[indexNl].mny_request_generate_code ?? ''}',
                                      style: GoogleFonts.openSans(
                                        fontSize: 14.0,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "$Date : ${needList[indexNl].create_date ?? ''} ",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "$Amount : ${needList[indexNl].need_amount ?? ''} $Baht",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "$Status1 : ${needList[indexNl].need_status ?? ''}",
                                            style: GoogleFonts.openSans(
                                              fontSize: 14.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        null,
                                        color: Colors.grey,
                                        size: 30,
                                      )),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        null,
                                        color: Colors.grey,
                                        size: 30,
                                      )),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //     GoogleMap2(),
                                        //   ),
                                        // );
                                        setState(() {
                                          fetchDelete(needList[indexNl]
                                                  .mny_request_id ??
                                              '');
                                        });
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrigamiPage(
                                              employee: widget.employee,
                                              popPage: 0, Authorization: widget.Authorization,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: FaIcon(FontAwesomeIcons.trashAlt,
                                        color: Colors.redAccent,
                                      ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          // Add more details as needed
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        : Center(
            child: Container(
              child: Text(
                '$Empty',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          );
  }

  String editEmployeeText = '';
  String ownerId = '';
  Widget _owner(List<EmployeeData> _owner) {
    return Center(
        child: Container(
      height: 48,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: () {
          // setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MiniEmployee(
                callback: (String value) => editEmployeeText = value,
                employee: widget.employee,
                callbackId: (String value) => ownerId = value, Authorization: widget.Authorization,
              ),
            ),
          );
          filter_Owner = editEmployeeText;
          // });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  (editEmployeeText == '')
                      ? '$Owner'
                      : (editEmployeeText != '')
                          ? editEmployeeText
                          : 'null',
                  style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: (editEmployeeText == '')
                          ? Colors.black38
                          : Color(0xFF555555)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Icon(Icons.arrow_drop_down_outlined),
            ],
          ),
        ),
      ),
    ));
  }

  String editprojectText = '';
  String projectId = '';
  Widget _project(List<ProjectData> _project) {
    return Center(
        child: Container(
      height: 48,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MiniProject(
                callback: (String value) => editprojectText = value,
                employee: widget.employee,Authorization: widget.Authorization,
                callbackId: (String value) => projectId = value,
              ),
            ),
          );
          filter_Project = editprojectText;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  (editprojectText == '')
                      ? '$all_project'
                      : (editprojectText != '')
                          ? editprojectText
                          : 'null',
                  style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: (editprojectText == '')
                          ? Colors.black38
                          : Color(0xFF555555)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Icon(Icons.arrow_drop_down_outlined),
            ],
          ),
        ),
      ),
    ));
  }

  String editDepartmentText = '';
  String departmentId = '';
  Widget _department(List<DepartmentData> departmentOption) {
    return Center(
        child: Container(
      height: 48,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: () {
          // setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MiniDepartment(
                callback: (String value) => editDepartmentText = value,
                employee: widget.employee,Authorization: widget.Authorization,
                callbackId: (String value) => departmentId = value,
              ),
            ),
          );
          filter_Department = editDepartmentText;
          // });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  (editDepartmentText == '')
                      ? '$Department'
                      : (editDepartmentText != '')
                          ? editDepartmentText
                          : 'null',
                  style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: (editDepartmentText == '')
                          ? Colors.black38
                          : Color(0xFF555555)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Icon(Icons.arrow_drop_down_outlined),
            ],
          ),
        ),
      ),
    ));
  }

  Future<List<AnnounceData>> fetchAnnounce() async {
    final uri =
    Uri.parse("$host/api/origami/announce/announce.php");
    final response = await http.post(
      uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': widget.Authorization,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> instructorsJson = jsonResponse['announce_data'];
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return instructorsJson
          .map((json) => AnnounceData.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  String priorityId = '';
  List<NeedTypeRespond> NeedTypeOption = [];
  List<NeedTypeItemRespond> NeedTypeItemOption = [];
  Future<void> fetchTypeRespond() async {
    final uri =
        Uri.parse('$host/api/origami/need/need_type.php');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> needTypeJson = jsonResponse['need_type'];

          setState(() {
            NeedTypeOption = needTypeJson
                .map((json) => NeedTypeRespond.fromJson(json))
                .toList();
          });
          print(NeedTypeOption);
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  Future<void> fetchTypeItemRespond() async {
    final uri = Uri.parse(
        '$host/api/origami/need/need_type_item.php');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> needTypeItemJson = jsonResponse['need_type_item'];

          setState(() {
            NeedTypeItemOption = needTypeItemJson
                .map((json) => NeedTypeItemRespond.fromJson(json))
                .toList();
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  // List<NeedRespond> needList = [];
  List<NeedRespond>? checkNeed;
  String need_type = "";
  String need_status = "";
  String search = "";
  Future<List<NeedRespond>> fetchNeedResponse() async {
    final uri = Uri.parse(
        "$host/api/origami/need/need.php?need_type=$need_type&need_status=$need_status&search=$search");
    final response = await http.post(
      uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
        'Authorization': widget.Authorization,
        'start_date': firstDay,
        'end_date': lastDay,
        'filter_priority': filter_Priority,
        'filter_department': filter_Department,
        'filter_project': filter_Project,
        'filter_owner': filter_Owner,
        'need_type': need_type,
        'need_status': need_status,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // เข้าถึงข้อมูลในคีย์ 'instructors'
      final List<dynamic> needJson = jsonResponse['need_data'];
      checkNeed = needJson.map((json) => NeedRespond.fromJson(json)).toList();
      // แปลงข้อมูลจาก JSON เป็น List<Instructor>
      return needJson.map((json) => NeedRespond.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructors');
    }
  }

  // PriorityRespond
  List<PriorityData> priorityOption = [];
  int int_priority = 0;
  bool is_priority = false;
  String? priority_number = "";
  String? priority_name = "";
  Future<void> fetchPriority(priority_number, priority_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/priority.php?page=$priority_number&search=$priority_name');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> priorityJson = jsonResponse['priority_data'];
          final priorityRespond = PriorityRespond.fromJson(jsonResponse);
          int_priority = priorityRespond.next_page_number ?? 0;
          setState(() {
            priorityOption = priorityJson
                .map(
                  (json) => PriorityData.fromJson(json),
                )
                .toList();
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  List<DepartmentData> departmentOption = [];
  int int_department = 0;
  bool is_department = false;
  String? department_number = "";
  String? department_name = "";
  Future<void> fetchDepartment(department_number, department_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/department.php?page=$department_number&search=$department_name');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> departmentJson = jsonResponse['department_data'];
          final departmentRespond = DepartmentRespond.fromJson(jsonResponse);
          int_department = departmentRespond.next_page_number ?? 0;
          setState(() {
            departmentOption = departmentJson
                .map(
                  (json) => DepartmentData.fromJson(json),
                )
                .toList();
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  List<ProjectData> projectOption = [];
  List<ProjectData> projectList = [];
  int int_project = 0;
  bool is_project = false;
  String? project_number = "";
  String? project_name = "";
  Future<void> fetchProject(project_number, project_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/project.php?page=$project_number&search=$project_name');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> projectJson = jsonResponse['project_data'];
          setState(() {
            final projectRespond = ProjectRespond.fromJson(jsonResponse);
            int_project = projectRespond.next_page_number ?? 0;
            is_project = projectRespond.next_page ?? false;
            projectOption = projectJson
                .map(
                  (json) => ProjectData.fromJson(json),
                )
                .toList();
            projectList = projectOption;
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  List<EmployeeData> employeeOption = [];
  int int_employee = 0;
  String page_employee = '';
  bool is_employee = false;
  String? employee_number = "";
  String? employee_name = "";
  Future<void> fetchEmployee(employee_number, employee_name) async {
    final uri = Uri.parse(
        '$host/api/origami/need/employee.php?page=$employee_number&search=$employee_name');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> employeeJson = jsonResponse['employee_data'];
          final employeeRespond = EmployeeRespond.fromJson(jsonResponse);
          int_employee = employeeRespond.next_page_number ?? 0;
          setState(() {
            employeeOption = employeeJson
                .map(
                  (json) => EmployeeData.fromJson(json),
                )
                .toList();
          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }

  Future<void> fetchDelete(request_id) async {
    final uri =
        Uri.parse('$host/api/origami/need/delete.php');
    try {
      final response = await http.post(
        uri, headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'Authorization': widget.Authorization,
          'request_id': "$request_id",
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          setState(() {

          });
        } else {
          throw Exception(
              'Failed to load personal data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load personal data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }
}

// models.dart
class NeedData {
  final String? requestNo;
  final String? requestEmpId;
  final String? requestEmpName;
  final String? paytoEmpId;
  final String? departmentId;
  final String? departmentName;
  final String? effectiveDate;
  final String? divisionId;
  final String? divisionName;
  final String? returnDate;
  final String? needSubject;
  final String? needReason;
  final String? assetId;
  final String? assetName;
  final String? accountId;
  final String? accountName;
  final String? contactId;
  final String? contactName;
  final String? priorityId;
  final String? priorityName;
  final String? priorityColor;
  final String? projectId;
  final String? projectName;
  final String? paytoEmpName;
  final String? need_type_name;
  final List<String>? needItem_id;
  final List<String>? needItem_date;
  final List<String>? needItem_note;
  final List<String>? needItem_quantity;
  final List<String>? needItem_price;
  final List<String>? needItem_unit;
  final List<NeedItemData> itemData;

  NeedData({
    this.requestNo,
    this.requestEmpId,
    this.requestEmpName,
    this.paytoEmpId,
    this.departmentId,
    this.departmentName,
    this.effectiveDate,
    this.divisionId,
    this.divisionName,
    this.returnDate,
    this.needSubject,
    this.needReason,
    this.assetId,
    this.assetName,
    this.accountId,
    this.accountName,
    this.contactId,
    this.contactName,
    this.priorityId,
    this.priorityName,
    this.priorityColor,
    this.projectId,
    this.projectName,
    this.paytoEmpName,
    this.need_type_name,
    this.needItem_id,
    this.needItem_date,
    this.needItem_note,
    this.needItem_quantity,
    this.needItem_price,
    this.needItem_unit,
    required this.itemData,
  });

  factory NeedData.fromJson(Map<String, dynamic> json) {
    return NeedData(
      requestNo: json['request_no'],
      requestEmpId: json['request_emp_id'],
      requestEmpName: json['request_emp_name'],
      paytoEmpId: json['payto_emp_id'],
      departmentId: json['department_id'],
      departmentName: json['department_name'],
      effectiveDate: json['effective_date'],
      divisionId: json['division_id'],
      divisionName: json['division_name'],
      returnDate: json['return_date'],
      needSubject: json['need_subject'],
      needReason: json['need_reason'],
      assetId: json['asset_id'],
      assetName: json['asset_name'],
      accountId: json['account_id'],
      accountName: json['account_name'],
      contactId: json['contact_id'],
      contactName: json['contact_name'],
      priorityId: json['priority_id'],
      priorityName: json['priority_name'],
      priorityColor: json['priority_color'],
      projectId: json['project_id'],
      projectName: json['project_name'],
      paytoEmpName: json['payto_emp_name'],
      need_type_name: json['need_type_name'],
      needItem_id: List<String>.from(json['n_item_id']),
      needItem_date: List<String>.from(json['n_item_date']),
      needItem_note: List<String>.from(json['n_item_note']),
      needItem_quantity: List<String>.from(json['n_item_quantity']),
      needItem_price: List<String>.from(json['n_item_price']),
      needItem_unit: List<String>.from(json['n_item_unit']),
      itemData: (json['need_item_data'] as List)
          .map((item) => NeedItemData.fromJson(item))
          .toList(),
    );
  }
}

class NeedItemData {
  final String? itemId;
  final String? item_sort;
  final String? itemName;
  final String? itemQuantity;
  final String? itemPrice;
  final String? unitCode;
  final String? unitDesc;
  final String? itemAmount;
  final String? itemNote;
  final String? itemDate;
  final List<String>? itemImage;
  final List<String>? image_base64;
  final List<String>? image_type_data;

  NeedItemData(
      {this.itemId,
      this.item_sort,
      this.itemName,
      this.itemQuantity,
      this.itemPrice,
      this.unitCode,
      this.unitDesc,
      this.itemAmount,
      this.itemNote,
      this.itemDate,
      this.itemImage,
      this.image_base64,
      this.image_type_data});

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'item_sort': item_sort,
      'item_name': itemName,
      'item_quantity': itemQuantity,
      'item_price': itemPrice,
      'unit_code': unitCode,
      'unit_desc': unitDesc,
      'item_amount': itemAmount,
      'item_note': itemNote,
      'item_date': itemDate,
      'item_image': itemImage,
      'image_base64': image_base64,
      'image_type_data': image_type_data,
    };
  }

  factory NeedItemData.fromJson(Map<String, dynamic> json) {
    return NeedItemData(
      itemId: json['item_id'],
      item_sort: json['item_sort'],
      itemName: json['item_name'],
      itemQuantity: json['item_quantity'],
      itemPrice: json['item_price'],
      unitCode: json['unit_code'],
      unitDesc: json['unit_desc'],
      itemAmount: json['item_amount'],
      itemNote: json['item_note'],
      itemDate: json['item_date'],
      itemImage: List<String>.from(json['item_image']),
      image_base64: List<String>.from(json['image_base64']),
      image_type_data: List<String>.from(json['image_type_data']),
    );
  }
}

class NeedRespond {
  final String? mny_request_id;
  final String? mny_request_generate_code;
  final String? mny_request_type_id;
  final String? mny_type_name;
  final String? mny_type_color;
  final String? create_date_display;
  final String? create_date;
  final String? effective_date_display;
  final String? effective_date;
  final String? mny_request_location;
  final String? mny_request_note;
  final String? need_subject;
  final String? emp_to;
  final String? emp_id;
  final String? request_emp;
  final String? mny_request_total;
  final String? need_amount;
  final String? project_name;
  final String? request_detail;
  final String? request_name;
  final String? request_status;
  final String? request_ap_status;
  final String? action_data;
  final String? request_approve_step;
  final String? request_step;
  final String? status_desc;
  final String? tb_action;
  final String? need_status;
  final String? request_budget;
  final String? asset_name;
  final String? request_clearing;
  final String? request_ref;
  final String? request_ref_id;
  final String? request_ref_type;
  final String? request_edit;
  final String? remark;
  final String? can_manage;
  final String? cash_id;
  final String? cash_name;
  final String? request_item;
  final String? priority_id;
  final String? priority_name;
  final String? priority_color;
  final String? pay_type;
  final String? request_verify;
  final String? payto_type;
  final String? approve_step;
  final String? request_remark;

  NeedRespond({
    this.mny_request_id,
    this.mny_request_generate_code,
    this.mny_request_type_id,
    this.mny_type_name,
    this.mny_type_color,
    this.create_date_display,
    this.create_date,
    this.effective_date_display,
    this.effective_date,
    this.mny_request_location,
    this.mny_request_note,
    this.need_subject,
    this.emp_to,
    this.emp_id,
    this.request_emp,
    this.mny_request_total,
    this.need_amount,
    this.project_name,
    this.request_detail,
    this.request_name,
    this.request_status,
    this.request_ap_status,
    this.action_data,
    this.request_approve_step,
    this.request_step,
    this.status_desc,
    this.tb_action,
    this.need_status,
    this.request_budget,
    this.asset_name,
    this.request_clearing,
    this.request_ref,
    this.request_ref_id,
    this.request_ref_type,
    this.request_edit,
    this.remark,
    this.can_manage,
    this.cash_id,
    this.cash_name,
    this.request_item,
    this.priority_id,
    this.priority_name,
    this.priority_color,
    this.pay_type,
    this.request_verify,
    this.payto_type,
    this.approve_step,
    this.request_remark,
  });

  factory NeedRespond.fromJson(Map<String, dynamic> json) {
    return NeedRespond(
      mny_request_id: json['mny_request_id'],
      mny_request_generate_code: json['mny_request_generate_code'],
      mny_request_type_id: json['mny_request_type_id'],
      mny_type_name: json['mny_type_name'],
      mny_type_color: json['mny_type_color'],
      create_date_display: json['create_date_display'],
      create_date: json['create_date'],
      effective_date_display: json['effective_date_display'],
      effective_date: json['effective_date'],
      mny_request_location: json['mny_request_location'],
      mny_request_note: json['mny_request_note'],
      need_subject: json['need_subject'],
      emp_to: json['emp_to'],
      emp_id: json['emp_id'],
      request_emp: json['request_emp'],
      mny_request_total: json['mny_request_total'],
      need_amount: json['need_amount'],
      project_name: json['project_name'],
      request_detail: json['request_detail'],
      request_name: json['request_name'],
      request_status: json['request_status'],
      request_ap_status: json['request_ap_status'],
      action_data: json['action_data'],
      request_approve_step: json['request_approve_step'],
      request_step: json['request_step'],
      status_desc: json['status_desc'],
      tb_action: json['tb_action'],
      need_status: json['need_status'],
      request_budget: json['request_budget'],
      asset_name: json['asset_name'],
      request_clearing: json['request_clearing'],
      request_ref: json['request_ref'],
      request_ref_id: json['request_ref_id'],
      request_ref_type: json['request_ref_type'],
      request_edit: json['request_edit'],
      remark: json['remark'],
      can_manage: json['can_manage'],
      cash_id: json['cash_id'],
      cash_name: json['cash_name'],
      request_item: json['request_item'],
      priority_id: json['priority_id'],
      priority_name: json['priority_name'],
      priority_color: json['priority_color'],
      pay_type: json['pay_type'],
      request_verify: json['request_verify'],
      payto_type: json['payto_type'],
      approve_step: json['approve_step'],
      request_remark: json['request_remark'],
    );
  }
}

class NeedTypeRespond {
  String? typeId;
  String? typeName;
  String? typeColor;
  String? typeImage;
  List<Status> typeStatus;
  List<String> statusListString;

  NeedTypeRespond({
    this.typeId,
    this.typeName,
    this.typeColor,
    this.typeImage,
    required this.typeStatus,
    required this.statusListString,
  });

  factory NeedTypeRespond.fromJson(Map<String, dynamic> json) {
    return NeedTypeRespond(
      typeId: json['type_id'],
      typeName: json['type_name'],
      typeColor: json['type_color'],
      typeImage: json['type_image'],
      typeStatus: (json['type_status'] as List)
          .map((statusJson) => Status.fromJson(statusJson))
          .toList(),
      statusListString:
      (json['status_list_string'] as List).map((e) => e as String).toList(),
    );
  }
}

class Status {
  final String? statusId;
  final String? statusName;
  final int? statusFlag;

  Status({
    this.statusId,
    this.statusName,
    this.statusFlag,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      statusId: json['status_id'],
      statusName: json['status_name'],
      statusFlag: int.parse(json['status_flag'].toString()),
    );
  }
}

class NeedTypeItemRespond {
  final String? type_id;
  final String? type_name;
  final String? type_color;
  final String? type_image;

  NeedTypeItemRespond({
    this.type_id,
    this.type_name,
    this.type_color,
    this.type_image,
  });

  factory NeedTypeItemRespond.fromJson(Map<String, dynamic> json) {
    return NeedTypeItemRespond(
      type_id: json['type_id'],
      type_name: json['type_name'],
      type_color: json['type_color'],
      type_image: json['type_image'],
    );
  }
}

class AnnounceData {
  String announce_id;
  String announce_subject;
  String announce_description;
  String announce_date;
  String announce_accept;
  String announce_button;

  AnnounceData({
    required this.announce_id,
    required this.announce_subject,
    required this.announce_description,
    required this.announce_date,
    required this.announce_accept,
    required this.announce_button,
  });

  factory AnnounceData.fromJson(Map<String, dynamic> json) {
    return AnnounceData(
      announce_id: json['announce_id'],
      announce_subject: json['announce_subject'],
      announce_description: json['announce_description'],
      announce_date: json['announce_date'],
      announce_accept: json['announce_accept'],
      announce_button: json['announce_button'],
    );
  }
}
