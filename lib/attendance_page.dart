import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class attendancePage extends StatefulWidget {
  const attendancePage({Key? key}) : super(key: key);

  @override
  State<attendancePage> createState() => _attendancePageState();
}

class _attendancePageState extends State<attendancePage> {
  List userData=[{"name":"loading","count":"loading"}];
  Future getAttendance() async {
    var uri = Uri.https(
        'zaba4768m0.execute-api.ap-south-1.amazonaws.com', '/get_attendance');
    http.Response response = await http.get(uri);
    Map data = json.decode(response.body);

    setState(() {
      userData = data["body"];
      print(userData);
      // priceData = data1["body"][1];
    });
  }
  @override
  void initState() {
    getAttendance().whenComplete(() async {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text("List of Students"),
      ),
      backgroundColor: Colors.black,
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 25, 20, 10),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: _buildListView(),
      ),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: userData.length,
        itemBuilder: (_, index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(4, 3, 4, 3),
            //margin: const EdgeInsets.fromLTRB(20, 5, 20, 10),
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey,
            ),
            child:ListTile(
              leading: Icon(Icons.person_outline, color: Colors.black),
              title: Text(
                userData[index]['name'].toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
              trailing:Text(
                userData[index]['count'].toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          );
        });
  }
}
