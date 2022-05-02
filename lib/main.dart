import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<Uint8List> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File audioFile = new File.fromUri(myUri);
    Uint8List bytes="fs" as Uint8List;
    await audioFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });
    print(bytes.toString());
    return bytes;
  }

  Future openCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);
    this.image = imageTemporary;
    print(imageTemporary);
    // Uint8List bytes1="fs" as Uint8List;
    final bytes=File(imageTemporary.path).readAsBytesSync();
    String ok=base64Encode(bytes);
    print(ok);
    //_readFileByte(imageTemporary.path);

    /*File imageFile = File(imageTemporary.path);
    Uint8List imagebytes = await imageFile.readAsBytes();
    String base64String = base64.encode(imagebytes);
    print(base64String);*/

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
              onPressed: () => openCamera(),

            ),
          ],
        ),
      ),     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ListView _buildListView() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () async {
            },
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
                leading: const Icon(Icons.person_outline,
                    color: Colors.black),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                  ),
                  splashColor: Colors.transparent,
                  onPressed: () => openCamera(),
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
