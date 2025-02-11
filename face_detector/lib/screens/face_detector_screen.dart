import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetectorScreen extends StatefulWidget {
  @override
  State<FaceDetectorScreen> createState() => _FaceDetectorScreenState();
}

class _FaceDetectorScreenState extends State<FaceDetectorScreen> {
  File? _image;
  String _resultText = "Carregue uma imagem para análise.";
  final ImagePicker _picker = ImagePicker();
  final FaceDetector _faceDetector = FaceDetector(options: FaceDetectorOptions(enableContours: true));

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
      _resultText = "Processando...";
    });

    _detectFaces(_image!);
  }

  Future<void> _detectFaces(File image) async {
    final inputImage = InputImage.fromFile(image);
    final List<Face> faces = await _faceDetector.processImage(inputImage);

    setState(() {
      if (faces.isNotEmpty) {
        _resultText = "Rosto detectado!";
      } else {
        _resultText = "Nenhum rosto detectado.";
      }
    });
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detecção de Rostos")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null)
              Image.file(_image!, height: 250),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_resultText, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.image),
                  label: Text("Galeria"),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: Icon(Icons.camera),
                  label: Text("Câmera"),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
