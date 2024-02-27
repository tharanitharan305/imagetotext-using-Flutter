import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    home: ImageToText(),
  ));
}

class ImageToText extends StatefulWidget {
  State<ImageToText> createState() => _ImageToTextState();
}

class _ImageToTextState extends State<ImageToText> {
  File? selectedImage;
  void getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null)
      setState(() {
        selectedImage = File(image!.path);
      });
  }

  Widget buildUi() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImageView(),
        FutureBuilder(
            future: extractText(selectedImage == null ? null : selectedImage!),
            builder: (context, snap) {
              return Text(
                snap.data ?? "No Text Found",
                style: TextStyle(fontSize: 30),
              );
            })
      ],
    );
  }

  Widget ImageView() {
    if (selectedImage == null) return Text('Select an Image');
    return Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: Image.file(selectedImage!)));
  }

  Future<String?> extractText(File? file) async {
    if (file == null) return 'Select an Image';
    final textRec = TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage image = InputImage.fromFile(file);
    var text = await textRec.processImage(image);
    return text.text;
  }

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image to Text Convertor'),
      ),
      body: buildUi(),
      floatingActionButton: FloatingActionButton(onPressed: getImage),
    );
  }
}
