import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DITECTA")),
      body: Center(
        child: ElevatedButton(
          onPressed: _optionsDialogBox,
          child: Text("Camera"),
        ),
      ),
    );
  }

  void _openCamera() {
    ImagePicker().pickImage(source: ImageSource.camera);
  }

  void _openGallery() {
    ImagePicker().pickImage(source: ImageSource.gallery);
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose option"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Take a picture"),
                  onTap: () {
                    _openCamera();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Select from gallery"),
                  onTap: () {
                    _openGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
