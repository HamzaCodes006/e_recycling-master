import 'package:e_recycling/worker_side/worker_profile.dart';
import 'package:flutter/material.dart';

import 'package:e_recycling/user/user_profile.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'dart:ui' as ui;


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_recycling/auth_screens_user/login.dart';
import 'package:e_recycling/provider/detail_screen_provider.dart';
import 'package:e_recycling/user/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../user/custom_animation.dart';


void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}
class WorkerFaceDetection extends StatefulWidget {
  @override
  _WorkerFaceDetectionState createState() => _WorkerFaceDetectionState();
}

class _WorkerFaceDetectionState extends State<WorkerFaceDetection> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  File? _imageFile;
  late List<Face> _faces;
  bool isLoading = false;
  late ui.Image _image;
  final picker = ImagePicker();
  UploadTask? task;
  File? image;
  Timer? _timer;
  int i=0;
  var snackBar = SnackBar(
    content: Text('Select an image first'),
  );
  var snackBar2 = SnackBar(
    content: Text('Select an image of your face'),
  );
  void initstate() {
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    //EasyLoading.showSuccess('Use in initState');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.lightGreen,
              onPressed: _getImage,
              child: Icon(Icons.add_a_photo),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              backgroundColor: Colors.lightGreen,
              onPressed: (){
                //EasyLoading.show(status: "Uploading Now");
                uploadImage();
              },
              child: Icon(Icons.arrow_forward),
            ),
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : (_imageFile == null)
            ? Center(child: Text('no image selected'))
            : Center(
            child: FittedBox(
              child: SizedBox(
                width: _image.width.toDouble(),
                height: _image.height.toDouble(),
                child: _faces.isEmpty?
                Center(
                  child: Text("No Face Detected",
                    style: TextStyle(
                        fontSize: 200,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                )
                    :CustomPaint(
                  painter: FacePainter(_image, _faces),
                ),
              ),
            )
        )
    );
  }
  _getImage() async {
    final imageFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      isLoading = true;
    });

    final image = GoogleVisionImage.fromFile(File(imageFile!.path));
    final faceDetector = GoogleVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(image);

    if (mounted) {
      setState(() {
        _imageFile = File(imageFile.path);
        _faces = faces;
        _loadImage(File(imageFile.path));
      });
    }
  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then((value) => setState(() {
      _image = value;
      isLoading = false;
    }));
  }
  uploadImage() async{
    if(_imageFile!=null && _faces.isNotEmpty){
      EasyLoading.show(status: "Uploading Now");
      final fileName = File(_imageFile!.path);
      final destination = 'files/$fileName';
      try {
        final ref =  FirebaseStorage.instance.ref(destination);


        task = ref.putFile(_imageFile!);
        final snapShot = await task!.whenComplete(() {

        });
        final urlDownload = await snapShot.ref.getDownloadURL();
        print("donload link is $urlDownload");
        var db = await FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser!.uid);

        Map<String,dynamic> ourData={
          'Image':urlDownload
        };

        db.update(ourData).then((value) {
          EasyLoading.showSuccess("Uploaded");
          EasyLoading.dismiss();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkerProfile()),
          );

        });
      }

      on FirebaseException catch (e) {
        return null;
      }
    }
    else if(_imageFile==null){
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else if(_faces.isNotEmpty){
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }
  }


}
class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rects = [];

  FacePainter(this.image, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.yellow;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter old) {
    return image != old.image || faces != old.faces;
  }
}
