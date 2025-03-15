import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class CameraPage extends StatefulWidget {
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? cameraController; // Controller for handling the camera
  CameraImage? cameraImage; // Stores the current camera frame
  List<CameraDescription>? cameras; // List of available cameras
  String output = 'No emotion detected'; // Default output text
  bool isFrontCamera = false; // Tracks the camera position (front or back)

  @override
  void initState() {
    super.initState();
    loadModel(); // Load the TensorFlow Lite model
    initializeCamera(isFront: true); // Initialize camera with front camera as default
  }

  // Initializes the camera with the selected position (front/back)
  Future<void> initializeCamera({required bool isFront}) async {
    try {
      cameras = await availableCameras(); // Fetch available cameras
      final selectedCamera = isFront ? cameras!.last : cameras!.first; // Select front or back camera

      if (cameraController != null) {
        await cameraController!.dispose(); // Dispose of any previous camera instance
      }

      // Create a new camera controller
      cameraController = CameraController(selectedCamera, ResolutionPreset.high);
      await cameraController?.initialize(); // Initialize the camera

      // Start capturing frames from the camera
      cameraController?.startImageStream((imageStream) {
        cameraImage = imageStream;
        runModel(); // Run emotion detection on each frame
      });

      setState(() {}); // Update UI
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  // Loads the TensorFlow Lite model for emotion detection
  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: 'assets/Model/model_unquant.tflite', // Path to model file
        labels: 'assets/Model/labels.txt', // Path to labels file
      );
      print("Model loaded successfully");
    } catch (e, stacktrace) {
      print("Error loading model: $e");
      print(stacktrace.toString());
    }
  }

  // Runs the TensorFlow Lite model on the current camera frame
  Future<void> runModel() async {
    if (cameraImage != null) {
      try {
        var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) => plane.bytes).toList(), // Convert image to required format
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2, // Number of results to return
          threshold: 0.1, // Confidence threshold
          asynch: true, // Run asynchronously
        );

        // Update UI with detected emotion
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
    cameraController?.dispose(); // Dispose camera controller when page is closed
    Tflite.close(); // Close TensorFlow Lite model to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
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
                isFrontCamera = !isFrontCamera; // Toggle between front and back camera
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
              child: CameraPreview(cameraController!), // Display live camera preview
            )
          else
            Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Colors.purple.shade400), // Show loading indicator while initializing camera
              ),
            ),
          SizedBox(height: 16),
          Text(
            output, // Display detected emotion
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
