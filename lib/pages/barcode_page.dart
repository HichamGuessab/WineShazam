import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class BarCodePage extends StatefulWidget {
  const BarCodePage({super.key});

  @override
  State<BarCodePage> createState() => _BarCodePageState();
}

class _BarCodePageState extends State<BarCodePage> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  void startCamera() async {
  cameras = await availableCameras();

  cameraController = CameraController(
      cameras[0],
      ResolutionPreset.max,
      enableAudio: false
  );

  await cameraController.initialize().then((value) {
    if (!mounted) {
      return;
    }
    setState(() {});
  }).catchError((e) {
    print(e);
  });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(cameraController.value.isInitialized) {
      return Scaffold(
        body: Stack(
          children: [
            CameraPreview(cameraController),
          ],
        )
      );
    } else {
      return const SizedBox();
    }
  }
}
