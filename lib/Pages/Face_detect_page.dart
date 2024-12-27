import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

class FaceDetectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple.shade400,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Spacing for animated text
            SizedBox(height: 20),
            Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'Welcome to EmoSense',
                    textStyle: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                repeatForever: false,
                totalRepeatCount: 1,
              ),
            ),

            const SizedBox(height: 100,),
            SizedBox(
              height: 200,
              width: 180,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CameraPage()));
                },
                child: Card(
                  elevation: 20,
                  color: Colors.purple.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.purple.shade400,
                        backgroundImage: AssetImage('assets/Images/emoji.png'),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Tap me to detect',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 10), // Small spacing at the bottom
          ],
        ),
      ),
    );
  }
}


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

  /// Initialize the camera
  Future<void> initializeCamera({required bool isFront}) async {
    try {
      cameras = await availableCameras();
      final selectedCamera = isFront ? cameras!.last : cameras!.first;

      if (cameraController != null) {
        await cameraController!.dispose(); // Dispose existing controller
      }

      cameraController =
          CameraController(selectedCamera, ResolutionPreset.high); // High resolution
      await cameraController?.initialize(); // Initialize the camera

      cameraController?.startImageStream((imageStream) {
        cameraImage = imageStream; // Get the image stream
        runModel(); // Process each frame
      });

      setState(() {});
    } catch (e) {
      print("Error initializing camera: $e");
      print('papaaaaaaaa');
    }
  }

  /// Load the TensorFlow Lite model
  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: 'assets/Model/model_unquant.tflite',
        labels: 'assets/Model/labels.txt',
      );
      print("Model loaded successfully");
    } catch (e, stacktrace) {
      print("talha" + stacktrace.toString());
      print("Error loading model: $e");
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
    cameraController?.dispose(); // Dispose of the camera
    Tflite.close(); // Close TensorFlow Lite resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        backgroundColor: Colors.purple.shade400,
        title: Text(
          'Live Emotion Detector',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.cameraswitch_sharp,color: Colors.white,),
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
            // child: cameraPrinter(cameraController!),
              //Show camera preview
              child: CameraPreview(cameraController!),
          )
          else
            Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Colors.purple.shade400,), // Loading indicator
              ),
            ),
          SizedBox(height: 16),
          Text(
            output, // Show detected emotion
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


