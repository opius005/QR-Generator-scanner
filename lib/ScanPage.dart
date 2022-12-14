import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sample/HistoryPage.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<StatefulWidget> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  File? imageFile;
  QRViewController? controller;
  Barcode? result;
  String? qrcode;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              buildQRView(context),
              Positioned(
                bottom: 180,
                child: buildResult(),
              ),
            ],
          ),
        ),
      );

  Widget buildResult() => Container(
        color: const Color(0xffE6E6E6),
        child: Text(
          qrcode != null ? '$qrcode' : '',
          maxLines: 3,
          style: const TextStyle(
            color: Color(0xff39AB44),
          ),
        ),
      );

  _launchURL(String? urlQRCode) async {
    Uri url = Uri.parse(urlQRCode!);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildQRView(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE6E6E6),
      appBar: AppBar(
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
          'SCAN QR',
          style: TextStyle(
            fontFamily: 'Heebo',
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff),
            fontSize: 24.0,
          ),
        ),
        actions: [
          IconButton(
            style: const ButtonStyle(
            ),
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {});
              },
              icon: FutureBuilder(
                future: controller?.getCameraInfo(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return const Icon(
                      Icons.cameraswitch,
                      color: Color(0xffffffff),
                    );
                  } else {
                    return Container();
                  }
                },
              )),
        ],
        backgroundColor: const Color(0xff39AB44),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () async {
                      await controller?.toggleFlash();
                      setState(() {});
                    },
                    icon: FutureBuilder<bool?>(
                      future: controller?.getFlashStatus(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return Icon(
                              color: const Color(0xff000000),
                              size: 40,
                              snapshot.data!
                                  ? Icons.flash_off_sharp
                                  : Icons.flash_on_sharp);
                        } else {
                          return Container();
                        }
                      },
                    )),
                IconButton(
                  onPressed: () {
                    pickImage();
                  },
                  icon: const Icon(
                    Icons.photo_library_sharp,
                    size: 40.0,
                    color: Color(0xff000000),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Center(
                    child: CustomPaint(
                      foregroundPainter: BorderPainter(),
                      child: SizedBox(
                        width: 300,
                        height: 300,

                        child: QRView(
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),
          const SizedBox(height: 70),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 307,
                  height: 52,
                  child: TextButton(
                    onPressed: () async {
                      _launchURL(qrcode);
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(
                          const Color(0xff39AB44)),
                      backgroundColor: MaterialStateProperty.all(
                          const Color(0xffffffff)),
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide(color: Color(0xff39AB44))),
                      ),
                    ),
                    child: const Text(
                      'OPEN IN BROWSER',
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        fontFamily: 'Heebo',
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xff39AB44)),
                  ),
                  child: IconButton(

                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: '$qrcode'))
                          .then((_) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(flutterToast());
                      });
                    },
                    icon: const Icon(
                      Icons.file_copy,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 55),
        ],
      ),
    );
  }

  flutterToast() {
    Fluttertoast.showToast(
        msg: 'Copied to clipboard',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      Vibration.vibrate(duration: 100);
      setState(() {
        result = scanData;
        qrcode = result!.code;
        storageList1.add(
            (scannedData(data: result!.code ?? '', dateTime: DateTime.now()))
                .toMap());
        box1.put('a1', storageList1);
        if(qrcode != null) scanbool=true;
      });
    });
  }

  pickImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String? str = await Scan.parse(pickedFile.path);
      if (str != null) {
        setState(() {
          qrcode = str;

          storageList1.add(
              (scannedData(data: qrcode ?? '', dateTime: DateTime.now()))
                  .toMap());
          box1.put('a1', storageList1);
          if(qrcode != null) scanbool=true;
        });
      }
    }
  }
}
class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.2; // desirable value for corners side

    Paint paint = Paint()
      ..color = const Color(0xff39AB44)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    Path path = Path()
      ..moveTo(cornerSide, 0)
      ..lineTo(0, 0)
      ..moveTo(0,cornerSide)
      ..lineTo(0, 0)
      ..moveTo(0, sh - cornerSide)
      ..lineTo(0, sh)
      ..moveTo(cornerSide , sh)
      ..lineTo(0, sh)
      ..moveTo(sw - cornerSide, sh)
      ..lineTo(sw, sh)
      ..moveTo(sh - cornerSide, 0)
      ..lineTo(sh, 0)
      ..moveTo(sw, cornerSide)
      ..lineTo(sh, 0)
      ..moveTo(sw, sh-cornerSide)
      ..lineTo(sh, sw);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
