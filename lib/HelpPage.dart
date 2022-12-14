import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
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
          'Help and Support',
          style: TextStyle(
            fontFamily: 'Heebo',
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff),
            fontSize: 24.0,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.help,
                color: Color(0xffffffff),
              )),
        ],
        backgroundColor: const Color(0xff39AB44),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Container(
            width: 380,
            padding: const EdgeInsets.only(left: 10),
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FAQ()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color(0xffffffff)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'FAQs',
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      fontFamily: 'Heebo',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 380,
            padding: const EdgeInsets.only(left: 10),
            child: TextButton(
              onPressed: () {
                _launchURLBrowser();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color(0xffffffff)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Watch Video',
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      fontFamily: 'Heebo',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.fromLTRB(80, 30, 80, 30),
              child: const Image(
                image: AssetImage( 'assets/HelpPageQR.png'),
                width: 350.0,
                height: 350.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _launchURLBrowser() async {
    var url = Uri.parse("https://youtu.be/pQ-sYKUufyE");
    if (await canLaunchUrl(url)) {
      await launchUrl(url,mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class FAQ extends StatefulWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
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
          'FAQs',
          style: TextStyle(
            fontFamily: 'Heebo',
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff),
            fontSize: 24.0,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit_note_outlined,
              color: Color(0xffffffff),
              size: 30,
            ),
          )
        ],
        backgroundColor: const Color(0xff39AB44),
        centerTitle: true,
      ),
      body: ListView.separated(
          itemCount: questions.length,
          itemBuilder: (context, i) {
            return ExpansionTile(
              title: Text(
                questions[i].title,
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000),
                    fontFamily: 'Heebo'),
              ),
              children: <Widget>[
                Column(
                  children: _buildExpandableContent(questions[i]),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: Color(0xff39AB44),
            );
          }),
    );
  }

  _buildExpandableContent(Question questions) {
    List<Widget> columnContent = [];

    for (String content in questions.contents) {
      columnContent.add(
        ListTile(
          title: Text(
            content,
            style: const TextStyle(fontSize: 18.0, color: Color(0xff000000)),
          ),
        ),
      );
    }

    return columnContent;
  }
}

class Question {
  final String title;
  List<String> contents = [];

  Question(this.title, this.contents);
}

List<Question> questions = [
  Question(
    'How many QR codes can I generate?',
    ['There is no limit to the number of QR codes you created'],
  ),
  Question('Why the QR codes I created cannot be scanned?', [
    '- The QR code is only the carrier of the content you generate. It will not be invalid, but the link you generated may be invalid. For example, if the source file of a website link invalid, people who scanned the QR code can not open the content you generated',
    '- The text or URL is too long, and the pattern of QR code is very complicated, which can easily cause the failure of scanning',
    ' - The foreground color of the QR code must be darker than the background color. If the foreground and background colors of the decorated QR code are too similar, or the background color is darker than the foreground color, the QR code will not be scanned.'
  ]),
  Question(
    'Do I need to pay to generate a QR code?',
    ['No, generating QR codes is free'],
  ),
  Question(
    'Is it safe to scan?',
    ['Yes,it is safe and the data is not shared with third parties'],
  ),
  Question(
    'Can i save the QR code generated?',
    [
      'Yes, there is a save option available through which we can save the image in gallery'
    ],
  ),
  Question(
    'Can I share the QR code generated? ',
    ['Yes, you can share image by clicking on the share icon in generate page'],
  ),
  Question(
    'Can I see previously generated QR codes ? ',
    ['Yes, You can access the history by taping on History icon in homepage of the app'],
  ),
  Question(
    'Does QR Images backup? ',
    ['No'],
  ),
];
