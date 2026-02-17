import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DITECTA")),
      body: Center(
        child: ElevatedButton(
          child: Text("Pick an image"),
          onPressed: _optionsDialogBox,
        ),
      ),
    );
  }

  void openCamera() async {
    var picture = await _picker.pickImage(source: ImageSource.camera);
  }

  void openGallery() async {
    var picture = await _picker.pickImage(source: ImageSource.gallery);
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Text("Take a picture"),
                  onTap: openCamera, //referencia, no llamada
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Choose from gallery"),
                  onTap: openGallery, //referencia, no llamada
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
