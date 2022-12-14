import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:sample/ScanPage.dart';
import 'package:sample/GeneratePage.dart';
import 'package:sample/HistoryPage.dart';
import 'package:sample/HelpPage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE6E6E6),
      appBar: AppBar(
        title: const Text(
          'QR Generator and Scanner',
          style: TextStyle(
            fontFamily: 'Heebo',
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff),
            fontSize: 24.0,
          ),
        ),
        backgroundColor: const Color(0xff39AB44),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.fromLTRB(80, 30, 80, 30),
              child: const Image(
                image: AssetImage( 'assets/HomePageQR.png'),
                width: 150.0,
                height: 150.0,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.fromLTRB(30, 26, 20, 10),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Scanner()));
                  Fluttertoast.showToast(msg: 'Tap on the BOX to Scan',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.grey,
                      textColor: Colors.black);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff39AB44)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text(
                      'SCAN ',
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.bold,
                        fontSize: 36.0,
                        fontFamily: 'Hebdo',
                      ),
                    ),
                    Text(
                      'QR CODE',
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        fontFamily: 'Hebdo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.fromLTRB(30, 26, 20, 10),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Generator()));
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff39AB44)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text(
                      'GENERATE ',
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.bold,
                        fontSize: 36.0,
                        fontFamily: 'Heebo',
                      ),
                    ),
                    Text(
                      'QR CODE',
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontFamily: 'Heebo',
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 60,
                  child: Container(
                    color: const Color(0xff39AB44),
                    height: 65,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const History()));
                      },
                      icon: const Icon(
                        Icons.history,
                        color: Color(0xffffffff),
                        size: 26,
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: VerticalDivider(
                    indent: 1300,
                    endIndent: 0,
                    color: Color(0xffffffff),
                  ),
                ),
                Expanded(
                  flex: 60,
                  child: Container(
                    color: const Color(0xff39AB44),
                    height: 65,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Help()));
                      },
                      icon: const Icon(
                        Icons.help,
                        color: Color(0xffffffff),
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
