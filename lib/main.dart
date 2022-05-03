import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_native_image/flutter_native_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Attendance App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? image;

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  Future openCamera(String name) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);
    this.image = imageTemporary;
    File compressedFile = await FlutterNativeImage.compressImage(
        imageTemporary.path,
        quality: 10);
    List<int> bytes = File(compressedFile.path).readAsBytesSync();
    String ok = base64Encode(bytes);
    // print(compressedFile);
    print(ok.length);

    var uri1 = Uri.https(
        'n86gekya23.execute-api.ap-south-1.amazonaws.com', '/initial');
    http.Response response = await http.post(
      uri1,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'data': ok, 'name': name}),
    );

    Map data = await json.decode(response.body);
    List answer = data['body']['FaceMatches'];
    print(answer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(8.0, 14, 8, 0),
              child: Text(
                "Student's Name",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                controller: myController,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.black,
              ),
              splashColor: Colors.transparent,
              onPressed: () => openCamera(myController.text),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ListView _buildListView() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () async {},
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(4, 3, 4, 3),
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey,
              ),
              child: ListTile(
                leading: const Icon(Icons.person_outline, color: Colors.black),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                  ),
                  splashColor: Colors.transparent,
                  onPressed: () => openCamera(myController.text),
                ),
                title: const Text(
                  "Student 1",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
