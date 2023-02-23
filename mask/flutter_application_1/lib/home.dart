import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    loadmodel();
  }

  detect_image(File image) async {
    var prediction = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 4,
        threshold: 0.001,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _loading = false;
      _predictions = prediction!;
      print(_predictions);
    });
  }

  bool _loading = true;
  late File _image;
  final imagePicker = ImagePicker();
  List _predictions = [];

  loadmodel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquantt.tflite', labels: 'assets/labelss.txt');
  }

  _loadimagefromgallery() async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detect_image(_image);
  }

  _loadimagefromcamera() async {
    var image = await imagePicker.pickImage(source: ImageSource.camera);

    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detect_image(_image);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 243, 241, 241)),
              width: double.infinity,
              child: Image.asset('./assets/mask.jpg'),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Check if a person is Wearing Mask",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _loadimagefromgallery();
              },
              child: Container(
                height: 50,
                width: 300,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 119, 118, 118),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Center(child: Text('Check with Image')),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                _loadimagefromcamera();
              },
              child: Container(
                height: 50,
                width: 300,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 119, 118, 118),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Center(child: Text('Check with Camera')),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _loading == false
                ? Column(
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        child: Image.file(_image),
                      ),
                      Text(_predictions[0]['label'].toString().substring(1)),
                      Text(
                          'Confidence ${_predictions[0]['confidence'].toString().substring(2, 4)}.${_predictions[0]['confidence'].toString().substring(4, 6)}%'),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(_predictions[1]['label'].toString().substring(1)),
                      Text(
                          'Confidence ${_predictions[1]['confidence'].toString().substring(2, 4)}.${_predictions[0]['confidence'].toString().substring(4, 6)}%'),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  )
                : const Icon(Icons.error_outline),
          ],
        ),
      ),
    );
  }
}
