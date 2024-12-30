import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:tflite/tflite.dart';
class CameraPage extends StatefulWidget {
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  String output = 'No emotion detected';
  bool isFrontCamera = true;
  late Timer _timer;
  int displayTime = 0;

  @override
  void initState() {
    super.initState();
    initializeCamera(isFront: true);
    // Start timer for initial delay and random emotions
    _timer = Timer.periodic(Duration(milliseconds: 1500), (timer) {
      setState(() {
        output = _getRandomEmotion();
      });

      // Start a continuous random emotion display after the first delay
      _timer = Timer.periodic(Duration(seconds: 2), (timer) {
        setState(() {
          output = _getRandomEmotion();
        });
      });
    });
  }

  /// Initialize the camera
  Future<void> initializeCamera({required bool isFront}) async {
    try {
      cameras = await availableCameras(); // Get available cameras
      final selectedCamera = isFront ? cameras!.last : cameras!.first;

      if (cameraController != null) {
        await cameraController!.dispose();
      }

      cameraController =
          CameraController(selectedCamera, ResolutionPreset.high);
      await cameraController?.initialize(); // Initialize camera

      setState(() {});
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  String _getRandomEmotion() {
    var emotions = ['Happy', 'Sad'];
    var randomEmotion = emotions[Random().nextInt(emotions.length)];
    return randomEmotion;
  }

  @override
  void dispose() {
    cameraController?.dispose();
    _timer.cancel();
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
          'Live Emotion Simulator',
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


// class CameraPage extends StatefulWidget {
//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }
//
// class _CameraPageState extends State<CameraPage> {
//   CameraController? cameraController;
//   CameraImage? cameraImage;
//   List<CameraDescription>? cameras;
//   String output = 'No emotion detected'; // Initial output message
//   bool isFrontCamera = false;
//
//   @override
//   void initState() {
//     super.initState();
//     loadModel(); // Load the pre-trained model
//     initializeCamera(isFront: true); // Initialize the camera with front camera
//   }
//
//   /// Initialize the camera
//   Future<void> initializeCamera({required bool isFront}) async {
//     try {
//       cameras = await availableCameras(); // Get available cameras
//       final selectedCamera = isFront ? cameras!.last : cameras!.first;
//
//       if (cameraController != null) {
//         await cameraController!.dispose(); // Dispose existing camera controller
//       }
//
//       // Create a new camera controller and initialize it
//       cameraController =
//           CameraController(selectedCamera, ResolutionPreset.high);
//       await cameraController?.initialize();
//
//       // Start streaming the camera frames
//       cameraController?.startImageStream((imageStream) {
//         cameraImage = imageStream; // Capture each camera frame
//         runModel(); // Process each frame with the model
//       });
//
//       setState(() {}); // Update UI when the camera is initialized
//     } catch (e) {
//       print("Error initializing camera: $e");
//     }
//   }
//
//   /// Load the TensorFlow Lite model
//   Future<void> loadModel() async {
//     try {
//       await Tflite.loadModel(
//         model: 'assets/Model/model_unquant.tflite',
//         labels: 'assets/Model/labels.txt',
//       );
//       print("Model loaded successfully");
//     } catch (e, stacktrace) {
//       print("Error loading model: $e");
//       print(stacktrace.toString());
//     }
//   }
//
//   /// Run the model to predict emotions from camera frames
//   Future<void> runModel() async {
//     if (cameraImage != null) {
//       try {
//         var predictions = await Tflite.runModelOnFrame(
//           bytesList: cameraImage!.planes.map((plane) => plane.bytes).toList(),
//           imageHeight: cameraImage!.height,
//           imageWidth: cameraImage!.width,
//           imageMean: 127.5,
//           imageStd: 127.5,
//           rotation: 90,
//           numResults: 2,
//           threshold: 0.1,
//           asynch: true,
//         );
//
//         if (predictions != null && predictions.isNotEmpty) {
//           setState(() {
//             output = predictions.first['label'] ?? 'Unknown'; // Set output based on prediction
//           });
//         }
//       } catch (e) {
//         print("Error running model: $e");
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     cameraController?.dispose(); // Dispose of the camera when done
//     Tflite.close(); // Close the model when done
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black87,
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context); // Navigate back on press
//           },
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//         ),
//         backgroundColor: Colors.purple.shade400,
//         title: Text(
//           'Live Emotion Detector',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.cameraswitch_sharp, color: Colors.white),
//             onPressed: () {
//               setState(() {
//                 isFrontCamera = !isFrontCamera; // Switch between front and back camera
//                 initializeCamera(isFront: isFrontCamera);
//               });
//             },
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           if (cameraController != null && cameraController!.value.isInitialized)
//             Expanded(
//               child: CameraPreview(cameraController!), // Show camera preview
//             )
//           else
//             Expanded(
//               child: Center(
//                 child: CircularProgressIndicator(color: Colors.purple.shade400), // Show loading indicator
//               ),
//             ),
//           SizedBox(height: 16),
//           Text(
//             output, // Display detected emotion
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//               color: Colors.green,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

