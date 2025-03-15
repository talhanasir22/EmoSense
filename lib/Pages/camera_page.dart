import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class CameraPage extends StatefulWidget {
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? cameraController;
  CameraImage? cameraImage;
  List<CameraDescription>? cameras;
  String output = 'No emotion detected';
  bool isFrontCamera = false;

  @override
  void initState() {
    super.initState();
    loadModel();
    initializeCamera(isFront: true);
  }

  Future<void> initializeCamera({required bool isFront}) async {
    try {
      cameras = await availableCameras();
      final selectedCamera = isFront ? cameras!.last : cameras!.first;

      if (cameraController != null) {
        await cameraController!.dispose();
      }

      cameraController = CameraController(selectedCamera, ResolutionPreset.high);
      await cameraController?.initialize();

      cameraController?.startImageStream((imageStream) {
        cameraImage = imageStream;
        runModel();
      });

      setState(() {});
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: 'assets/Model/model_unquant.tflite',
        labels: 'assets/Model/labels.txt',
      );
      print("Model loaded successfully");
    } catch (e, stacktrace) {
      print("Error loading model: $e");
      print(stacktrace.toString());
    }
  }

  Future<void> runModel() async {
    if (cameraImage != null) {
      try {
        var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) => plane.bytes).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.1,
          asynch: true,
        );

        if (predictions != null && predictions.isNotEmpty) {
          setState(() {
            output = predictions.first['label'] ?? 'Unknown';
          });
        }
      } catch (e) {
        print("Error running model: $e");
      }
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.purple.shade400,
        title: Text(
          'Live Emotion Detector',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.cameraswitch_sharp, color: Colors.white),
            onPressed: () {
              setState(() {
                isFrontCamera = !isFrontCamera;
                initializeCamera(isFront: isFrontCamera);
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          if (cameraController != null && cameraController!.value.isInitialized)
            Expanded(
              child: CameraPreview(cameraController!),
            )
          else
            Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Colors.purple.shade400),
              ),
            ),
          SizedBox(height: 16),
          Text(
            output,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
