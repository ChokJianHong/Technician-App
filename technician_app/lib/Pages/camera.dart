import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:technician_app/API/cameraTaken.dart';

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  final String token;
  const MyApp({Key? key, required this.camera, required this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera App',
      home: TakePictureScreen(
        camera: camera,
        token: token,
      ), // Use the TakePictureScreen widget
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final String token; // Add a field for the token

  const TakePictureScreen({super.key, required this.camera, required this.token});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a Picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            // Navigate to the DisplayPictureScreen and pass the token
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                    imagePath: image.path,
                    token: widget.token), // Pass the token here
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
