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

  int direction = 0;

  @override
  void initState() {
    startCamera(0);
    super.initState();
  }

  void startCamera(int direction) async {
  cameras = await availableCameras();

  cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.high,
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
      return Center(
        child: Stack(
          children: [
            CameraPreview(cameraController),
            GestureDetector(
              onTap: () {
                setState(() {
                  direction = direction == 0 ? 1 : 0;
                  startCamera(direction);
                });
              },
              child : button(Icons.flip_camera_ios_outlined, Alignment.bottomLeft),
            ),
            GestureDetector(
              onTap: () {
                cameraController.takePicture().then((value) => {
                  if(mounted) {
                    // Envoie vers le vin en question
                  }
                });
              },
              child : button(Icons.camera_alt_outlined, Alignment.bottomCenter),
            ),
          ],
        )
      );
    } else {
      return const SizedBox();
    }
  }
}

Widget button(IconData icon, Alignment alignment) {
  return Align(
    alignment: alignment,
    child: Container(
        margin: const EdgeInsets.only(
            left: 20,
            bottom: 20
        ),
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  offset: Offset(2, 2),
                  blurRadius: 10
              )
            ]
        ),
        child: Center(
            child: Icon(
              icon,
              color: Colors.black87,
            )
        )
    ),
  );
}
