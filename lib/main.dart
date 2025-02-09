import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _selectedImage;
  String _prediction = "No prediction yet";

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _predict() async {
    if (_selectedImage == null) return;

    var response = await ApiService.uploadImage(_selectedImage!);
    if (response != null && response.containsKey("prediction")) {
      setState(() => _prediction =
          "Prediction: ${response['prediction']} (Confidence: ${response['confidence']}%)");
    } else {
      setState(() =>
          _prediction = "Error: ${response?['error'] ?? 'Unknown error'}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Image Classification")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedImage != null
                ? Image.file(_selectedImage!)
                : const Text("Pick an image"),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _pickImage, child: const Text("Select Image")),
            ElevatedButton(onPressed: _predict, child: const Text("Predict")),
            const SizedBox(height: 10),
            Text(_prediction),
          ],
        ),
      ),
    );
  }
}
