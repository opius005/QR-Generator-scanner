import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

List<scannedData> historylist1 = [];
List<generatedData> historylist2 = [];
final box1 = Hive.box('b1');
final box2 = Hive.box('b2');
List storageList1 = [];
List storageList2 = [];
bool genbool = true;
bool scanbool = true;


@HiveType(typeId: 0)
class scannedData {
  @HiveField(0)
  String? data;
  @HiveField(1)
  DateTime dateTime;

  scannedData({this.data, required this.dateTime});

  Map<String, dynamic> toMap() {
    return {'data': data, 'DateTime': dateTime};
  }

  factory scannedData.fromMap(Map map) {
    return scannedData(
      data: map['data'],
      dateTime: map['DateTime'],
    );
  }

  @override
  String toString() {
    return 'data: $data DateTime: $dateTime';
  }
}

@HiveType(typeId: 1)
class generatedData {
  @HiveField(0)
  String? data;
  @HiveField(1)
  DateTime dateTime;

  generatedData({this.data, required this.dateTime});

  Map<String, dynamic> toMap() {
    return {'data': data, 'DateTime': dateTime};
  }

  factory generatedData.fromMap(Map map) {
    return generatedData(
      data: map['data'],
      dateTime: map['DateTime'],
    );
  }

  @override
  String toString() {
    return 'data: $data DateTime: $dateTime';
  }
}
class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool selected = false;
  bool _isShown = true;

  @override
  void initState() {
    super.initState();
    restore1();
    restore2();
  }
  void restore1() {
    storageList1 = box1.get('a1') ?? [];
    if (scanbool) {
      historylist1.clear();
      for (final map in storageList1) {
        historylist1.add(scannedData.fromMap(map));
      }
    }
    scanbool = false;
  }

  void restore2() {
    storageList2 = box2.get('a2') ?? [];
    if (genbool) {
      historylist2.clear();
      for (final map in storageList2) {
        historylist2.add(generatedData.fromMap(map));
      }

    }

    genbool = false;
  }

  void removeUser2(int itemCount) async {
    final userToDelete = await box2.values.firstWhere((element) => element.itemCount==itemCount);
    await userToDelete.delete();

  }
  void removeUser1(int itemCount) async {
    final userToDelete = await box1.values.firstWhere((element) => element.itemCount==itemCount);
    await userToDelete.delete();

  }

  @override
  Widget build(BuildContext context) {
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
            'History',
            style: TextStyle(
              fontFamily: 'heebo',
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
              fontSize: 24.0,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.history,
                color: Color(0xffffffff),
              ),
            )
          ],
          backgroundColor: const Color(0xff39AB44),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        selected = false;
                      });
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(const Color(0xff39AB44)),
                      backgroundColor: MaterialStateProperty.all(
                        selected == false
                            ? const Color(0xff39AB44)
                            : const Color(0xffffffff),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: const BorderSide(color: Color(0xff39AB44))),
                      ),
                    ),
                    child: const Text(
                      'Generated',
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontSize: 20.0,
                        fontFamily: 'Heebo',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        selected = true;
                      });
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(const Color(0xff39AB44)),
                      backgroundColor: MaterialStateProperty.all(
                        selected == true
                            ? const Color(0xff39AB44)
                            : const Color(0xffffffff),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: const BorderSide(color: Color(0xff39AB44))),
                      ),
                    ),
                    child: const Text(
                      'Scanned',
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontSize: 20.0,
                        fontFamily: 'Heebo',
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xff39AB44)),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor: const Color(0xff39AB44),
                                content: const Text(
                                  'Are you sure you want to delete al'
                                  'l the history?',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'hebdo',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                actions: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 130,
                                          height: 50,
                                          child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isShown = false;
                                                  if (selected) {
                                                    historylist1.clear();
                                                    storageList1.clear();
                                                    box1.clear();
                                                  } else {
                                                    historylist2.clear();
                                                    storageList2.clear();
                                                    box2.clear();
                                                  }
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                        const Color(
                                                            0xff39AB44)),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  const Color(0xffffffff),
                                                ),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      side: const BorderSide(
                                                          color: Color(
                                                              0xff39AB44))),
                                                ),
                                              ),
                                              child: const Text(
                                                'Yes',
                                                style: TextStyle(
                                                  color: Color(0xff000000),
                                                  fontSize: 20,
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                            width: 130,
                                            height: 50,
                                            child: TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color(
                                                              0xff39AB44)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    const Color(0xffffffff),
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        side: const BorderSide(
                                                            color: Color(
                                                                0xff39AB44))),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'No',
                                                  style: TextStyle(
                                                    color: Color(0xff000000),
                                                    fontSize: 20,
                                                  ),
                                                ))),
                                      ])
                                ],
                              );
                            });
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            selected
                ? historylist1.isEmpty
                    ? Container(
                        padding: const EdgeInsets.fromLTRB(60, 300, 60, 100),
                        child: const Text(
                          'Empty',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'heebo',
                            fontSize: 20,
                          ),
                        ))
                    : Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ListView.separated(
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: historylist1.length,
                          itemBuilder: (context, itemCount) {
                            return Column(
                              children: [
                                Container(
                                    padding:
                                        const EdgeInsets.only(left: 10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 330,
                                            child: TextButton(
                                              onPressed: () {
                                                Clipboard.setData(
                                                        ClipboardData(
                                                            text:
                                                                '${historylist1[itemCount].data}'))
                                                    .then((_) {
                                                  ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(
                                                          flutterToast());
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Text(
                                                      '${historylist1[itemCount].data}',
                                                      style:
                                                          const TextStyle(
                                                        color:
                                                            Color(0xff000000),
                                                        fontSize: 17,
                                                        fontFamily:
                                                            'Heebo',
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Text(
                                                      DateFormat.yMd().add_jm().format(historylist1[itemCount].dateTime).toString(),
                                                      style:
                                                          const TextStyle(
                                                        color:
                                                            Colors.grey,
                                                        fontSize: 11,
                                                        fontFamily:
                                                            'Heebo',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 50,
                                            height: 40,
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  scanbool=true;
                                                  historylist1.removeAt(itemCount);
                                                  storageList1.removeAt(itemCount);
                                                  removeUser1(itemCount);
                                                });
                                              },
                                              icon: const Icon(
                                                Icons
                                                    .delete_outline_sharp,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ])),
                              ],
                            );
                          },
                          separatorBuilder: (context, i) {
                            return const Divider(
                              color: Color(0xff39AB44),
                            );
                          },
                        ),
                      ),
                    )
                : historylist2.isEmpty
                    ? Container(
                        padding: const EdgeInsets.fromLTRB(60, 300, 60, 100),
                        child: const Text(
                          'Empty',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'heebo',
                            fontSize: 20,
                          ),
                        ))
                    : Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ListView.separated(
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: historylist2.length,
                          itemBuilder: (context, itemCount) {
                            return Column(
                              children: [
                                Container(
                                    padding:
                                        const EdgeInsets.only(left: 10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 330,
                                            child: TextButton(
                                              onPressed: () {
                                                Clipboard.setData(
                                                        ClipboardData(
                                                            text:
                                                                '${historylist2[itemCount].data}'))
                                                    .then((_) {
                                                  ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(
                                                          flutterToast());
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Text(
                                                      '${historylist2[itemCount].data}',
                                                      style:
                                                          const TextStyle(
                                                        color:
                                                            Color(0xff000000),
                                                        fontSize: 17,
                                                        fontFamily:
                                                            'Heebo',
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Text(
                                                      DateFormat.yMd().add_jm().format(historylist2[itemCount].dateTime).toString(),
                                                      style:
                                                          const TextStyle(
                                                        color:
                                                            Colors.grey,
                                                        fontSize: 11,
                                                        fontFamily:
                                                            'Heebo',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 50,
                                            height: 40,
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  genbool=true;
                                                  historylist2.removeAt(itemCount);
                                                  storageList2.removeAt(itemCount);
                                                  removeUser2(itemCount);
                                                });
                                              },
                                              icon: const Icon(
                                                Icons
                                                    .delete_outline_sharp,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ])),
                              ],
                            );
                          },
                          separatorBuilder: (context, i) {
                            return const Divider(
                              color: Color(0xff39AB44),
                            );
                          },
                        ),
                      ),
                    ),
          ],
        ));
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
}
