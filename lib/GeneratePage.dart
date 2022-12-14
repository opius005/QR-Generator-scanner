import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:sample/HistoryPage.dart';

class Generator extends StatefulWidget {
  const Generator({Key? key}) : super(key: key);

  @override
  State<Generator> createState() => _GeneratorState();
}

class _GeneratorState extends State<Generator> {
  GlobalKey globalKey = GlobalKey();
  String _dataString = "Hello from this QR";
  final String _inputErrorText = "";
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE6E6E6),
      appBar: AppBar(
        backgroundColor: const Color(0xff39AB44),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
            size: 30,
          ),
        ),
        title: const Text(
          'GENERATE QR',
          style: TextStyle(
              color: Color(0xffffffff),
              fontSize: 24,
              fontFamily: 'heebo',
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.qr_code,
              color: Color(0xffffffff),
              size: 30,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: _contentWidget(),
    );
  }

  _contentWidget() {
    //final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const SizedBox(height: 70),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  style: const TextStyle(color: Color(0xff000000)),
                  textAlign: TextAlign.center,
                  controller: _textController,
                  cursorColor: const Color(0xff39AB44),
                  decoration: InputDecoration(
                    hintText: "Enter the Text here",
                    hintStyle: const TextStyle(
                        color: Colors.grey, fontStyle: FontStyle.italic),
                    errorText: _inputErrorText,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                height: 50,
                width: 200,
                padding: const EdgeInsets.only(left: 10.0),
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xff39AB44)),
                      shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ))),
                  child: const Text(
                    'Generate',
                    style: TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'heebo',
                        fontSize: 24),
                  ),
                  onPressed: () {
                    genbool=true;
                    setState(() {
                      _dataString = _textController.text;

                      storageList2.add((scannedData(
                              data: _dataString, dateTime: DateTime.now()))
                          .toMap());
                      box2.put('a2', storageList2);
                    });
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 80,),
          Row(
            children: [
              const SizedBox(width: 35,),
              Expanded(
                child: Center(
                  child: RepaintBoundary(
                    key: globalKey,
                    //child: AspectRatio(
                      //aspectRatio: 1/1,
                      child: QrImage(
                        size: 300,
                        data: _dataString,
                        backgroundColor: Colors.white,
                      //),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 35,),
            ],
          ),
          const SizedBox(height: 70,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xff39AB44)),
                    color: const Color(0xffffffff)
                ),
                child: IconButton(
                  onPressed: () {
                    _save().then((_){
                      Fluttertoast.showToast(msg: 'Image Saved',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.grey,
                          textColor: Colors.black);
                    });
                  },
                  icon: const Icon(
                    Icons.file_download,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xff39AB44)),
                  color: const Color(0xffffffff)
                ),
                child: IconButton(
                  onPressed: () {
                    _share();
                  },
                  icon: const Icon(
                    Icons.share,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50)
        ],
      ),
    );
  }

  _share() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 5.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    if (byteData != null) {
      final pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/$_dataString.jpg').create();
      file.writeAsBytesSync(pngBytes);
      Share.shareFiles([file.path]);
    }
  }

  _save() async {
    PermissionStatus permission = await Permission.storage.request();
    if (permission.isGranted) {
      final boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 5.0);
      final byteData = await (image.toByteData(format: ImageByteFormat.png));
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        final directory = Directory('/storage/self/primary/Pictures/Sample');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        final imgFile = File(
          '/storage/self/primary/Pictures/Sample/$_dataString.png',
        );

        if (await directory.exists()) {
          await imgFile.writeAsBytes(pngBytes);
          await GallerySaver.saveImage(imgFile.path);
        }
      }
    }
  }
}
